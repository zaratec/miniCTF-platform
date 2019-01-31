# We Rate Birds

## Purpose

Teach students about directory traversal and LFI.

## Solution

The website features bird gifs and accompanying descriptions. The main point of
interest for competitors should be the source linked at the bottom of the page.

The source primarily interprets the path of the request and determines how to
respond to the user. For each path prefix in the app's list, it will attempt to
match it to the beginning of the path. If it does so, it performs different
actions based on whether it is a file, directory, or filter. If it is unmatched,
it assumes the path is some file and responds with the file name. Filters are
functions that are run on a recursive call to the rest of the path.

NOTE: It is _very_ important competitors take the time to understand the source
code.

Competitors need to realize that the logic for parsing/interpreting the path
seems off. The source has a list of prefixes and attempts to match them to the
beginning of the path by length. So if abc is a valid prefix, it will match with
both of the following paths: `abc/def` and `abcdef/ghi`.

This allows them to use a filter which is not at the beginning of the path.
Whereas `XXX/@filter/...` would get blocked, `XXX@filter/...` will run the
filter on the rest of the path.

The next obstacle to overcome is the issue that we would like the content of the
`flag.txt` file, but if we just use `assets/flag.txt`, when it matches the
prefix, it also checks that the file isn't protected. The fact that the file
paths used to dump the content are hardcoded into the prefix paths list means
that we can't trick this - so getting the contents of `flag.txt` via a prefix
with the "file" type will not work. It would be great if we could throw a `../`
into the path, but the app checks for the presence of `..`.

The only other place we can get the contents of a file are via directory
prefixes. The path of the file that's opened is the hardcoded path + a recursive
call on the remainded of the path. If we can do something such that the result
of the recursive call contains `../flag.txt`, we could get the contents of the
flag.

Filters provide us a way to hide the `..`. `@base64decode` will return the base
64 decoded contents of the rest of the path. 

Visiting `http://problems.getpwning.com:9630/assets/js@base64decode/Li4vZmxhZy50eHQ=`
will produce the flag.

## Flag

`CTF{orange_might_have_been_on_to_something_there}`