---
title: Piwik to replace Google Analytics
date: 2013-07-31T18:00:41+00:00
author: RemyG
layout: rg-post
categories: Other
tags:
  - Analytics
  - Piwik
---

Since the PRISM "scandal" (yes, everybody already knew that the USA have been spying on us at least since 2001), we see lots of open-source solutions emerging to replace the "old" proprietary (and potentially a bit too curious) web-applications. A good example is [DuckDuckGo](https://duckduckgo.com/‎), an anonymous Internet search engine that has seen its traffic exploding after the revelations (1.5 million queries / day on 01/01/2013, almost 3.5 millions queries / day today). You can see the evolution of the traffic [on their website](https://duckduckgo.com/traffic.html).

I've been trying for a while to clean my digital footprint (I still have a lot to do), and to reduce my dependency to proprietary services, but some major solutions are unavoidable, like GMail (or YMail). A few weeks ago, I've managed to replace a Google service, [Google Analytics](http://www.google.com/analytics/), by an open-source, self-hosted application, [Piwik](http://piwik.org/).

<!--more-->

Piwik provides advanced analytics in real-time, with the possibility of consulting the **visitors statictics** (location, provider, settings, time...), the **actions statictics** (entry and exit pages, bounce rate...).

![Visitors overview]({{ site.baseurl }}/assets/img/PiwikVisitorsOverview.png)

You can also look at a **real-time visitors map**, or see which links are the most clicked on each page.

![Visitors real-time map]({{ site.baseurl }}/assets/img/PiwikVisitorsRealTimeMap.png)

It also allows you to create advanced **goals**, but I've not reach this point, since my use of an analytics solution is relatively basic.

The installation process is as easy as deploying a Wordpress instance on you server (they also have their 5-minute installation). It's well documented [on the website](http://piwik.org/docs/installation/). Mainly, you download the [latest release](http://builds.piwik.org/latest.zip) of Piwik, unzip it, upload it to your server, create a new database, and follow the 9-step installation process.

It's only been a few weeks since I've started to use Piwik, but I already know that I prefer it to Google Analytics. I've found all the information I used to have, the dashboards are more customizable, and more importantly, all my data are stored on my personnal server instead of a Google server. That means that if someday Google Analytics is no longer free, or even closes (yes Google Reader, I'm looking at you), I'll still be able to get my analytics data, and also that my data really are **my data**.
