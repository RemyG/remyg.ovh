---
title: Comics Calendar
date: 2013-07-03T18:00:27+00:00
author: RemyG
layout: rg-post
categories: Project
tags:
  - calendar
  - comics
  - PHP
---

I'm an avid comic books reader, mostly from the Marvel franchise (X-Men, Spider-Man, Avengers...), and some DC too (Batman, Superman...). But every series has its own monthly release date, which makes difficult to follow what the current issue is for a series.

That's why I've developed an on-line calendar that regroups the release dates for all new comic books issues. The data are retrieved from [ComicVine](http://www.comicvine.com), which is a huge wiki-based website for comics.

<!--more-->

ComicVine has a very useful (if not well documented) API that allows you to run searches on their comics database. ComicsCalendar uses this API to retrieve, every night, every issue released in the last week. It's not possible to retrieve the upcoming issues as the issues are added on ComicVine only on the day of their release.

The main use case is:
* sign up / log in (you also can use the demo account, which is demo / demo)
* go to "Manage my series" to select the series you want to follow
* on the main page, the calendar displays the released issues for this month (you can navigate to the previous/next months)
* when you buy/read/download an issue, just check it either on the calendar or on the series page so you can see the difference between your already bought/read/downloaded issues and the new ones

Currently, an instance of ComicsCalendar is deployed on my personal server, at [http://comics.remyg.fr](http://comics.remyg.fr). I use it for my own comics, and you can use it too (just create an account and you will have access to all the functionalities). You can download the source code on GitHub (see [this page](/projects/comicscalendar/) for the installation instructions) and deploy it on your own server. You can also fork the project or contribute to it, as the sources are released under the [MIT License](http://opensource.org/licenses/MIT).

[![Go to ComicsCalendar](http://remyg.fr/blog/wp-content/uploads/2013/07/comicscalendar-1024x495.png)](http://comics.remyg.fr)
