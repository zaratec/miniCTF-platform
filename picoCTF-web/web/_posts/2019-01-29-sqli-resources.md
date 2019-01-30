---
title:  "SQL Injection Resources"
date:   2019-01-29 21:00:00
categories: ctfs
---

### Common Questions

**I don't remember how the `SUBSTR` or `LIKE` operators work.**

Check out these resources:
* [SUBSTR](https://www.w3schools.com/sql/func_mysql_substr.asp)
* [LIKE](https://www.w3schools.com/sql/sql_like.asp)

**I want to perform a blind SQL injection attack but it takes too long to do it by hand.**

Use Python. The [Python requests library](http://docs.python-requests.org/en/master/user/quickstart/)
allows you to programmatically issue HTTP requests.

This is where the Network tab on the developer tools will come in handy. Submit some example 
data and observe what is sent.

In my case, I entered `abc` in the flag submission box on this CTF platform. You can see that
the request was made to `http://getpwning.com/api/problems/submit` and was a POST request.

![](/img/minictf_network01.png)

If I scroll down a bit, I can see the form data that was submitted. In particular, I see that
my input `abc` is under the key named `key`. There are also 3 other key-value pairs of data
sent along with it, `pid`, `method`, and `token`.

![](/img/minictf_network02.png)

To issue the same request using Python, I would run the following script:

{% highlight python %}
import requests
r = requests.post('http://getpwning.com/api/problems/submit', data = {'key':'abc','pid':'???', 'method':'web', 'token':'???'})

# The following gives the response as a string
r.context     
{% endhighlight %}

### Additional Reading

* [SQL Injection](https://www.owasp.org/index.php/SQL_Injection)
* [Hacksplaining SQL Injection](https://www.hacksplaining.com/exercises/sql-injection)
* [How to exploit the SQL Injection Attack](https://sqlzoo.net/hack/)
