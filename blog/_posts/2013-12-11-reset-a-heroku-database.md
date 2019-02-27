---
title: Reset a Heroku database
date: 2013-12-11T18:00:31+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - database
  - Heroku
---
I'm currently developing a Play! application, and I use [Heroku](https://www.heroku.com) to deploy and test it.

But sometimes when deploying it, the application crashes when trying to start up. What happens is that the database contains data that are in conflict with the new schema that I've deployed (eg. new required foreign keys that don't have a value...).

<!--more-->

To fix this, the easiest way I've found is to reset my Heroku database. When connected to Heroku (with the Heroku Toolbelt), just run
```
heroku pg
```
which will display the list of your databases, then run
```
heroku pg:reset HEROKU_DATABASE_SOMEBASE
```
which will reset your database ```HEROKU_DATABASE_SOMEBASE```.

Then you can restart your application with
```
heroku restart
```
and everything should be working fine.
