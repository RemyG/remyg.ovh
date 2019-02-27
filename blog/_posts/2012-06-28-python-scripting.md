---
title: Python scripting
date: 2012-06-28T08:00:07+00:00
author: RemyG
layout: rg-post
categories: Project
tags:
  - GitHub
  - LinkedIn
  - LXML
  - Python
  - PythonScripts
  - requests
  - scraping
  - script
---

I started recently to look into Python development. I wanted to learn something new, and it was the logical choice.

So I started by working on a simple script, which would scrape the content of my LinkedIn profile to create an XML file with all the information I want. I could then display the content of this file on my home page. The purpose of this is to standardize my resumes between different applications / websites.

<!--more-->

This script needed 3 functionalities:

* retrieving the content of an HTML page (here, my LinkedIn profile)
* parsing the content and selecting the information I wanted
* creating an output file with all the information

For the HTML content retrieving, I found the "requests" module, which can be used like
```
res = requests.get(profile_url)
html_content = res.content
```

For the parsing, I found [lxml](http://lxml.de/), which allows you to parse the content you just retrieved, and then (in my case), access the elements you want with some XPath.

Then, I just had to output the resulting XML into a file, which is read by my PHP home page, to get [this result](http://remy-gardette.fr/en) (or [here](http://remy-gardette.fr/fr) in French).

I added a call to this script as a cron task, so it is called every Sunday morning (which allows to get the updates from my resume, and still be relatively lightweight).

You can find the source code on GitHub, in my project [PythonScripts](https://github.com/RemyG/PythonScripts). You only need the linkedin.py file to run this script.
