---
title:  "XSS Resources"
date:   2018-01-30 01:00:00
categories: ctfs
---

### Common Questions

**I tried `<script>alert(1)</script>` like you said. Why don't I get an alert pop up?**

Have you tried something like `<h1>This is a header</h1>`? Does the resulting text look 
like a header? If so, there is a XSS vulnerability on the app, but JavaScript may be 
prevented from running. 

Check the console in developer tools. Does it give an error on the page where you expect 
the script to run? Either the code is incorrect or the JavaScript may violate a Content 
Security Policy (CSP) directive. Search up what the error says - it may give you a clue
how to fix your JavaScript or where you should put it so it doesn't violate CSP. 

### Additional Reading

* [Cross-site Scripting]https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet(https://www.owasp.org/index.php/Cross-site_Scripting_(XSS))
* [XSS Filter Evasion](https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet)
* [XSS Vectors Cheatsheet](https://gist.github.com/kurobeats/9a613c9ab68914312cbb415134795b45)
* [What is PHP and why is XSS so common there?](https://www.youtube.com/watch?v=Q2mGcbkX550)
