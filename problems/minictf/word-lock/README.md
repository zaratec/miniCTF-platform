# Bagel Shop

## Purpose

Teach students about blind SQL injection.

## Notes

* Was pretty easy to figure out it was an SQL injection
* Hardest part was probably writing the Python script
* If `LIKE` is used, `_` character may mess up since it is the single-character wildcard

## Guidance

* Make sure students are aware what the SQL query looks like (via `search.php` source)
* Slides are helpful for understanding how to craft the query
* Give an example template for Python requests
* If `LIKE` is being used, `_` may cause issues when getting the flag since it's a single-character wildcard. `\_` should be used instead.

## Solution

The website features a search box where users can enter the name of a bagel type
and the site tells them whether they are still in inventory (`X bagels found!`)
or not (`Sorry we don't seem to have those bagels... :(`). Competitors must
realize that they can perform an SQL injection attack with the inventory search
feature.

They should guess see in the provided source that there is a bagel with the
`Type` value equal to `Flag` and suspect that the flag contents may be in the
`Description` column for `Flag`.

However, they can't just dump the contents of that column since the only
feedback the app gives is whether there are bagels or a certain type or not.

They should be able to gather that blind SQL injection (Yes/No answers) could
be used here.

Since the query made is `"SELECT * FROM bagels WHERE type='" . $POST["bagel"] . "'"`,
competitors should craft a search for something like
`flag' AND description LIKE 'f%` or `flag' AND SUBSTR(description,1,1)='f` to
check if the first character is `'f'`, for example. If the first character is
`'f'`, then the query returns the "Flag bagel" row and the page reports that
there are bagels in the inventory. Otherwise, no rows are returned (via the
`AND`) and the page reports that they don't have those bagels.

Competitors can try different letters, numbers, and valid symbols per
character of the flag until the page reports bagels were found (which means
that the character is correct). Then they move onto the next character.

## Flag

`CTF{h4ck_4nd_g3t_b4g3ls}`
