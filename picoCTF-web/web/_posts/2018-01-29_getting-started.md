---
title:  "Getting started"
date:   2018-01-01 19:00:00
categories: ctfs
---

Welcome! This post is meant to give some background on approaches and tools in
web exploitation.

### Approach

#### Finding points of interest

It's important to know where to look when exploiting a web app. Here are a few
tips on things to keep in mind.

* Examine everything and don't ignore seemingly unimportant features. Most parts
of the site are part of the challenge.
* Consider what user input is in the site and what it might cause the web app to do.
For instance, are there forms on the page? Does it let you search a database (SQL injection)?
Does it display your input on the page (XSS)? Does visiting a path cause the application
to do something?
* Google! If you encounter something you don't understand, give it a quick Google. 
Unsure about the meaning of a line of PHP? Don't know what the CSP violation error in
the JavaScript console means? Give it a quick Google. If you're still unsure, ask
one of helpers. :)

Some places to look for vulnerabilities include forms, cookies, HTML source code, network
traffic, and other source code.

#### When reading source code

Reading source code for exploitation may be different than when you've read
code before. Web exploitation oftentimes exploits faulty logic in the code. 
Rather than getting the gist of how the code works, you need to have an
in-depth understanding in order to spot the places where the logic breaks
down.

* If there's user input involved, come up with some examples and walk through
how the code may process it.
* If you note that the code does a certain task, ask yourself how _you_
may solve the same problem. Does the code seem to do it in a significantly
different way? Dig a bit deeper - there may be some faulty logic.

### Tools

#### CTF platform shell

For this competition, the main thing you need is a laptop and browser. 

You may need Python to perform an attack with multiple requests. If you have 
Python set up locally, great! If not, this site has a web shell you can access
[on your browser](http://getpwning.com/shell) or via ssh (`ssh username@157.230.91.253`).

#### Developer tools

Browser developer tools are very useful for analyzing different parts of a web 
application. To open developer tools, right-click a page and select `Inspect` or
`Inspect Element`.

There are three very important tabs in developer tools: `Elements`/`Inspector`, 
`Console`, and `Network`.

* **Elements/Inspector:** Displays the HTML source of the page. 
* **Console:** Allows you to execute JavaScript (great for testing!) and displays 
JavaScript errors for the page.
* **Network:** Shows the content of HTTP requests made.

#### Python

Some attacks (or analysis of a web app) may be greatly improved with the help of
Python scripts. **Blind SQL injection** attacks, for example, may require data to 
be uncovered over multiple requests which can be done with the help of Python.

Requests can be made programmatically with the help of [the Python requests library](http://docs.python-requests.org/en/master/user/quickstart/).
Python 2.7 and `requests` have been installed on [the CTF platform shell](http://getpwning.com/shell)
for your convenience.

#### Cookie editors

Cookies can oftentimes contains important bits of information and may need to be
analyzed or changed to carry out an attack. Extensions such as [Edit This Cookie](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg?hl=en)
for Chrome or [Cookie Editor](https://addons.mozilla.org/en-US/firefox/addon/edit-cookie/)
for Firefox can allow you to inspect and edit cookies.

#### HTTP request inspectors

HTTP request inspector tools provide a quick and easy alternative to setting up
your own server when capturing and analyzing traffic. For instance, they may be useful
when exploiting a **XSS** vulnerability as you can send back the admin's info 
to the HTTP request inspector.
