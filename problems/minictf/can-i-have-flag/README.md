# Can I Have Flag

## Purpose

Teach students about hash length extension attacks.

## Notes

* Cookie => hash length extension attacks is a pretty big jump
* Resources on JWT token structure may be useful
* Is the CRC-32 done on secret + header + payload or just secret + payload?
* "Why can't I get the same CRC-32 when run on the payload?" => b/c of the prepended secret
* Noted from the slides that we can do double GET parameter silliness to append "&isAdmin=true"
* It was very helpful once they knew to use hashpump
* May not realize there's a secret prepended in the CRC-32
* Length => guess 8?

## Guidance

* Need to help people look at the cookie - compare with JWTs
* Point to GET parameter portion of slides to realize that "&isAdmin=true" could be appended ononto the payload 
* Get them to look at hash length extension attack
* Make sure they try to look for tools rather than implementing it themselves

## Solution

Competitors need to read the source to find information regarding "UWTs" 
(JWTs). The next step should be figuring out to append "&isAdmin=true" to the 
payload of the JWT - the idea may come from the lecture slides. 

However, the competitor needs to then figure out how to craft a signature that
matches up with the new payload. They can do this with a hash length 
extension attack. The Python library `hashpumpy` can help with crafting the new
cookie at this point.

## Flag

`CTF{more_length_extension_than_pinocchio}`
