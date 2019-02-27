---
title: 'Custom PHP Scripts - LinkedIn Resume'
date: 2012-12-27T18:00:39+00:00
author: RemyG
layout: rg-post
categories: Project
tags:
  - PHP
  - scripts
  - Webscraping
deprecated: true
---

Some time ago, I’ve decided to centralize my resume information in one place, to avoid having to update it on several places every time I changed anything in it.  
I’ve decided to use the LinkedIn interface to update it, as it allows resumes in different languages (my profile [in French](http://www.linkedin.com/in/remygardette/fr) and [in English](http://www.linkedin.com/in/remygardette/en)).

To retrieve my resume information from my LinkedIn profile, I’ve created a PHP script to scrape the webpage and compile the result in an XML file.

<!--more-->

The resulting file has the following format:

```
<?xml version="1.0" encoding="UTF-8"?>
<resume>
    <position>
	<title>position title</title>
	<company>company</company>
	<location>location</location>
	<from>from date</from>
	<to>to date</to>
	<description>description</description>
    </position>
    <position>
	...
    </position>
</resume>
```

Then I can use this file as a source data in other webpages (like [my personal homepage](https://remyg.fr/)).

This script uses the [Simple HTML DOM library](http://sourceforge.net/projects/simplehtmldom/) to parse the HTML source from the webpage.

The script is in the ```linkedin.php file```, and needs the library in ```simple_html_dom.php```.

To run it, just call ```scrapeResume($resume_url, $dest_file)```, which will create or replace the file ```$dest_file``` with the XML scraping of the resume at ```$resume_xml```.

Now I could create a custom and lightweight XML marshaller and unmarshaller, to simplify the XML operations.

The sources can be found [on GitHub](https://github.com/RemyG/PHPScripts), and you can directly download the sources as a [Zip File](https://github.com/RemyG/PHPScripts/zipball/master) or a [TAR Ball](https://github.com/RemyG/PHPScripts/tarball/master). You can also simply clone the repository with Git by running:

```
$ git clone https://github.com/RemyG/PHPScripts.git
```
