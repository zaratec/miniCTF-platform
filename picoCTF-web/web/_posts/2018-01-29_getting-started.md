---
title:  "Getting started"
date:   2018-01-01 19:00:00
categories: ctfs
---

Welcome! This post is meant to give some background on approaches and tools in
web exploitation.

### Approach

#### Finding points of interest

#### When reading source code

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
