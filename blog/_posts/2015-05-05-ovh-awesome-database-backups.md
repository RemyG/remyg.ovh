---
title: OVH awesome database backups
date: 2015-05-05T06:00:46+00:00
author: RemyG
layout: rg-post
categories: System
tags:
  - backup
  - database
  - OVH
  - SSH
---

Yesterday, I made a huge mistake while testing a new version of my RSS syndication application: I ran the installation script, which has the effect of (re)creating all the tables used by the application.

<!--more-->

This has reminded me of 2 things:

* an installation script should not wipe existing tables, at least not without warning the user
* a backup strategy would not be the worse idea

But knowing that and having a solution to my current problem are two completely different things.

Fortunately, OVH (the hosting service I'm using) are awesome, and allow you to retrieve a backup of your database, either from yesterday or from last week.

To create a dump of your database, connect to your hosting with SSH, then enter the following command:

    mysqldump --host=your_host --user=your_user --password=your_password --port=3307 your_bdd > mybackup.sql

Port 3307 is used for yesterday's backup, port 3317 is for last week's.

This will create a dump of your database in the file `mybackup.sql`. To import it back, enter:

    cat mybackup.sql | mysql --host=your_host --user=your_user --password=your_password your_bdd

And voilà, your database is back to the state it was in yesterday.
