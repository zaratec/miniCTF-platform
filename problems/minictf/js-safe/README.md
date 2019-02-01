# JS Safe

## Purpose

TBD

## Notes

* TBD

## Guidance

* TBD

## Solution

The main script is a post-order traversal of the dom that is used to construct 
a recursive function. The recursive function then xor's your input against a 
rotating key. To solve it, you can just figure out what the value of the key is
for each character of the input, and then xor it with what it compares it to

## Flag

`CTF{i_<3_js}`
