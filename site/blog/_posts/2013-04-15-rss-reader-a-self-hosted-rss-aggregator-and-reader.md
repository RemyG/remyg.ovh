---
title: 'RSS Reader - A self-hosted RSS aggregator and reader'
date: 2013-04-15T18:00:38+00:00
author: RemyG
layout: rg-post
categories: Project
tags:
  - PHP
  - RSS
  - RSS Reader
---

A few weeks ago, Google announced they would stop their service [Google Reader](https://www.google.com/reader/) on July 1, 2013 ([original post](http://googleblog.blogspot.co.uk/2013/03/a-second-spring-of-cleaning.html)). I have never used this service to read my RSS feeds, prefering to use [Netvibes](https://www.netvibes.com/), mainly because it's been developed by a French company, but also because I like the UI better.

<!--more-->

But this announce has made me think. Every now and then, we hear about another service being shut down. Google, which regroups a huge part of the webapps used in the world, has his traditionnal Spring Cleaning. Other companies have closed worldwide-used websites. You can never know how long you'll be able to use a specific service.

This is the reason I've decided to develop my own RSS aggregator and reader, to allow me to take control over my personnal data.

The project is named RSS Reader (not very original). It's a PHP based project, that you can deploy on a personnal server, or self-hosting service. It's released under the [MIT License](http://www.opensource.org/licenses/MIT). It uses 2 external libraries: [Propel ORM](http://propelorm.org/) (an open source ORM for PHP5, released under the MIT License), and [SimplePie](http://simplepie.org/) (an open source feed parser, released under the BSD License).

The installation process is described on the project page [here]({{ site.baseurl }}{% link _pages/projects/rss-reader.md %}).
