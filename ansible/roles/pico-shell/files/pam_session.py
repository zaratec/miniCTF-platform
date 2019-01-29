"""
Set cgroup limits per user (and for all users collectively) each time a session
is opened.

Use the existing cgroups created by systemd which already map every process
into a hierarchy.  To do this, execute:
`systemctl set-property <slice> [properties...]`

See the systemd resource-control man page for available properties, and note
that they change between Ubuntu 16.04 and 18.04

Notes:

* In later versions of systemd the user-.slice template may be helpful and
  eliminate much of this code (though maybe not all).
* I've read that systemd removes the user.slice when no more users are logged
  in, so be careful making what should be persistent changes in some way
  outside of the pam stack.
* This should cover *most* processes a user creates.  Notably, cron jobs run in
  a scope outside of the user.slice so
  those processes would NOT be affected.  And, `systemd --user` procesess run
  within the user-{uid}.slice and ARE affected.
* Should work with Python 2 & 3


Installation:

0. install libpam-python
   >> apt-get install libpam-python
1. copy this file to /lib/security/pam_session.py
   >> cp pam_session.py /lib/security/
2. modify file(s) /etc/pam.d/
   >> echo "session [success=ok default=bad] pam_python.so pam_session.py" >> /etc/pam.d/sshd

"""
import os
import pwd
import syslog
import subprocess

pamh = None


def display(string):
    message = pamh.Message(pamh.PAM_TEXT_INFO, string)
    pamh.conversation(message)


def pam_sm_open_session(_pamh, flags, argv):
    global pamh
    pamh = _pamh

    syslog.syslog(syslog.LOG_DEBUG, "pam_session.py: pam_sm_open_session")
    #    display("pam_session.py: pam_sm_open_session")

    try:
        user = pamh.get_user(None)
    except pamh.exception as e:
        return e.pam_result

#    display("pam_auth.py: for user: {user}".format(user=user))

    try:
        entry = pwd.getpwnam(user)
    except:
        return pamh.PAM_USER_UNKNOWN

    option_sets = [
        ['--quiet', '--runtime'
        ],  # quiet and don't persist changes since they happen per session anyway
        ['--quiet'
        ],  # quiet and DO persist changes to make sure to overwrite any existing settings
    ]

    minsysmem_mb = 512.0  # minimum memory that should not be assigned to user.slice processes

    totalmem_mb = (os.sysconf('SC_PAGE_SIZE') *
                   os.sysconf('SC_PHYS_PAGES')) / 1024.0 / 1024.0
    memlimit_mb = totalmem_mb - minsysmem_mb

    # This applies to user.slice, so
    # *Accounting=yes enforces fair sharing where possible for the group of
    # user processes *against* the group of system processes
    #
    # Setting a specific CPUShares is so that in the worst case, the system
    # doesn't use the same amount as the users.  We can bias it for the users
    # but to a specified limit.
    # CPUShares is used here instead of CPUQuota so the setting doesn't need to
    # know how many cores are available.
    #
    # With shares_from_percentage(90) we let users use at most 90% of the
    # available CPU resources when the system wants resources, instead of using
    # up to 50% which would be the default
    #
    # Technically, the init.scope also has the same shares as system.slice, so
    # in the event that the init.scope has processes that want CPU, then this
    # gives 5% to system and 5% to init, but in practice there are no processes
    # in the init.scope that are utilizing CPU.  And the alternative of setting
    # shares with 'others=2' would limit the system.slice processes to 5% in the
    # typical case instead of 10% which is not what we want.
    all_properties = [
        "CPUAccounting=yes",
        "CPUQuota=",  # clear this so no interaction with CPUShares
        "CPUShares=%d" % (shares_from_percentage(90),),
        "MemoryAccounting=yes",
        "MemoryLimit=%dM" % memlimit_mb,
        "TasksAccounting=yes",
        "BlockIOAccounting=true",
    ]

    slice_name = 'user.slice'.format(uid=entry.pw_uid)
    for options in option_sets:
        subprocess.check_call(['systemctl', 'set-property', slice_name] +
                              options + all_properties)

    syslog.syslog(
        syslog.LOG_DEBUG, "pam_session.py: modified %s with %s" %
        (slice_name, ','.join(all_properties)))

    # manually set the memory.memsw.limit_in_bytes limit for user.slice if possible so we don't run out of swap.
    # this requires swapaccount=1 enabled on the kernel command line at boot (and propertly build/configured kernel)
    try:
        with open(
                '/sys/fs/cgroup/memory/user.slice/memory.memsw.limit_in_bytes',
                'wb') as fobj:
            fobj.write('%dM' % memlimit_mb)
        syslog.syslog(
            syslog.LOG_DEBUG,
            "pam_session.py: set memory.memsw.limit_in_bytes to match")
    except:
        syslog.syslog(
            syslog.LOG_DEBUG,
            "pam_session.py: failed to modify memory.memsw.limit_in_bytes")


###### doesnt work since cgroup already has tasks (see kernel cgroup docs)
#    # manually set the memory.kmem.limit_in_bytes limit for user.slice.
#    try:
#        with open('/sys/fs/cgroup/memory/user.slice/memory.kmem.limit_in_bytes', 'wb') as fobj:
#            fobj.write('%dM' % (memlimit_mb/2))
#        syslog.syslog(syslog.LOG_DEBUG,
#                      "pam_session.py: set memory.kmem.limit_in_bytes to half of user limit")
#    except:
#        syslog.syslog(syslog.LOG_DEBUG,
#                      "pam_session.py: failed to modify memory.kmem.limit_in_bytes")

###### probably not really what we want.  Doesn't seem to help anything at least
#    # manually set the memory.swapiness for user.slice to 0
#    try:
#        with open('/sys/fs/cgroup/memory/user.slice/memory.swappiness', 'wb') as fobj:
#            fobj.write('0')
#        syslog.syslog(syslog.LOG_DEBUG,
#                      "pam_session.py: set memory.swappiness")
#    except:
#        syslog.syslog(syslog.LOG_DEBUG,
#                      "pam_session.py: failed to modify memory.swappiness")

# dont set specific limits on user 0 and 1000 to make testing easier, but keep fair sharing
    if entry.pw_uid in (0, 1000):
        return pamh.PAM_SUCCESS

    # This applies to user-{uid}.slice, so
    # *Accounting=yes enforces fair sharing (where possible) among users
    # CPUQuota sets a maximum for each user (aggregate is limited via all_properties settings)
    # MemoryLimit sets a maximum for each user (doesn't seem to be a way to handle the aggregate, unfortunately)
    # TasksMax sets a maximum for each user (aggregate can have a max set in all_properties but maybe not useful)
    each_properties = [
        "CPUAccounting=yes",
        "CPUQuota=20%",
        "CPUShares=",  # clear this so no interaction with CPUQuota
        "MemoryAccounting=yes",
        "MemoryLimit=128M",
        "TasksAccounting=yes",
        "TasksMax=100",
        "BlockIOAccounting=true",
    ]

    slice_name = 'user-{uid}.slice'.format(uid=entry.pw_uid)
    for options in option_sets:
        subprocess.check_call(['systemctl', 'set-property', slice_name] +
                              options + each_properties)

    syslog.syslog(
        syslog.LOG_DEBUG, "pam_session.py: modified %s with %s" %
        (slice_name, ','.join(each_properties)))

    return pamh.PAM_SUCCESS


def pam_sm_close_session(pamh, flags, argv):
    return pamh.PAM_SUCCESS


def shares_from_percentage(p, other_shares=1024, others=1):
    '''Calculate CPUShares value given percentage p.  p should
    be in [0-100]

    We expect CPUShares is 1024 by default and only 1 other party.

    So, to set a relative percentage P where P = p/100, S=other_shares*others
        total shares = S + x
        P == x / (S + x) -> x == (P*S) / (1-P)
    '''

    P = 1.0 * p / 100
    S = other_shares * others
    x = (P * S) / (1 - P)
    # result needs to be an integer, take floor
    return int(x)
