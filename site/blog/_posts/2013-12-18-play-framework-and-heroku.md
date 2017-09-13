---
title: Play! Framework and Heroku
date: 2013-12-18T18:00:29+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - Heroku
  - Java
  - Kanban
  - Play!
  - Trello
---

I'm currently developing a web application in Java. To do so, I'm using the <a href="http://www.playframework.com/">Play! Framework</a>, which is a
> High Velocity Web Framework For Java and Scala

This framework allows you to quickly build web applications with Java (and Scala, but I'm sticking to Java for now).

<!--more-->

You can find the tutorial for a todo list application [here](http://www.playframework.com/documentation/2.2.x/JavaTodoList). This tutorial allows you to create a very basic application and deploy it in less than an hour (excluding the framework and tools download and installation time).

The application I'm working on is a Kanban board, similar to [Trello](https://trello.com/), that you can host on your personal server, or, in my case, on [Heroku](https://www.heroku.com).

Heroku is a cloud application platform, based on Amazon AWS, which allows you to deploy and host applications with git. They offer a free hosting option, which includes 1 dyno (their own unit of computing power), and a PostGreSQL database that can contain 10k rows. This should be enough for you to test your application, and a free option is always welcome. You can then pay for additional dynos, DB options, and add-ons (data stores, logging, emails,...). See the pricing details [here](https://www.heroku.com/pricing).

My application is still in development. I'm trying to learn how to use Play!, and also playing with the UI. You can find it [here](http://stark-citadel-5916.herokuapp.com/).
