# How to Contribute to picoCTF

One of our goals with the picoCTF platform is to make CTF style
computer security competitions available to anyone who is interested.
Our focus is on making the best platform for students and teachers but
the platform should also be suitable for any organizations who want to
incorporate CTFs into their training or professional development
process.


We hope you find the picoCTF platform useful and easy to get started
with.  Towards that end we welcome any contributions that you find
improve your competition. This guide captures the simple process to
submit a contribution.

Note: we keep everything in one repository so that anyone can bring up
the whole infrastructure at once. We've tried alternate methods, e.g.,
submodules, but we've found the one-big-repo workflow works best for
us.


## Getting Setup

The GitHub guide to
[Forking Projects](https://guides.github.com/activities/forking/)
covers many of these steps in more detail if this is your first time
contributing on GitHub.

1. Create a personal fork of the project on [GitHub](https://github.com/picoCTF/picoCTF#fork-destination-box).
2. Clone your personal fork to your local computer.
3. Create a feature branch for the changes you would like to make.
4. Make your changes and commit along the way.
    - We greatly prefer small single topic features. If at all possible break any wide sweeping changes into logical chunks.
5. Make sure all the tests are passing.
6. Once you are done making changes rebase your branch off the latest master branch.
    - See [staying up to date](#staying-up-to-date) below.
    - Note only do this if you have not already published your branch. Linus has some good [rules of thumb](http://www.mail-archive.com/dri-devel@lists.sourceforge.net/msg39091.html).
7. Push your feature branch up to your fork on GitHub and create a pull request.
8. The picoCTF team will review your pull request.

## Staying up to date

Since you are developing on your personal fork of the picoCTF platform
you will want to stay in sync with the public version. This can be
done by adding the official
[picoCTF/picoCTF](https://github.com/picoCTF/picoCTF) repository as an
`upstream` remote.

GitHub has two good guides that explain this process in greater detail:
- First [configure a remote for a fork](https://help.github.com/articles/configuring-a-remote-for-a-fork/).
- Then [sync a fork](https://help.github.com/articles/syncing-a-fork/).


1. Add an `upstream` remote for the official repository.
    ```git remote add upstream https://github.com/picoCTF/picoCTF.git```
2. Fetch any changes from the official repository.
    ```git fetch upstream```
3. Merge any changes into your local copy of the repository.
    ```
    git checkout master
  git merge upstream/master
    ```
    Now your local copy of the repository has all the latest changes. Be sure to rebase any private feature branches you are working on off of this fresh version of `master`.
4. Push your synchronized branch up to your copy of the repository on GitHub.
    ```git push origin master```

## Git Workflow

The steps described above are our interpretation of a Forking Workflow
as excellently described by
[Atlassian](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow).
Additionally please consider reading their section on the
[Feature Branch Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)
which this is based.

Other common conventions:
- `master` is the primary branch and represents the official history
  of the project.
- `master` should always be deployable.
- Merges to `master` are done with `--no-ff` to ensure a merge commit
  is made.
- Releases are tagged and live in a release branch. Based on the
  nature of the picoCTF team these releases are typically centered
  around a competition. Once a release is made it should only expect
  to receive bug fixes.

If you are seeking to run your own competition, and don't require the
features under active development on `master`, we recommend working
off of a release as a stable, known good point.

## Coding

We are in the process of pushing for code quality. Going forward,
please:
- Follow the [PEP8 Standard](https://www.python.org/dev/peps/pep-0008/)
  (including editor line length).
- Strive to leave the code base in better shape than when you got it.
- Add test cases when you add code.
- Run [Flake8](https://pypi.python.org/pypi/flake8)
- Use underscores (e.g., `get_unique`), not camelCase (e.g., not `getUnique`).
- In docstrings, follow
  [PEP 257](https://www.python.org/dev/peps/pep-0257)
- Use [isort](https://github.com/timothycrosley/isort#readme) for
  imports. We have checked in a `.isort.cfg` to help, so you should just have to
  run `isort -rv .`

We really appreciate your help improving the code quality.
