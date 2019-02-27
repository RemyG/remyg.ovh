---
title: Learning Kotlin
date: 2017-08-13T12:46:29+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - eclipse
  - intellij
  - Kotlin
---

Kotlin is, as described on [the official website](https://kotlinlang.org/), a
> Statically typed programming language for modern multiplatform applications

Programiz has [a great infographic](https://www.programiz.com/kotlin-programming) that explains the interest of learning Kotlin.

<!--more-->

***

The Kotlin website has [a well written documentation](https://kotlinlang.org/docs/reference/), with a complete language reference, as well as different tutorials.

If, like me, you have some experience in Java development, a good starting point are the Kotlin Koans. The Koans are a series of TDD exercises, each of them introducing an element of the Kotlin syntax. It starts slowly, with the basic Kotlin syntax and the differences with Java, but then goes to specific collections handling concepts that can remind you of the new Java 8 or Scala transformation methods.

To start working on the Koans, you can either fork the project on GitHub ([here](https://github.com/Kotlin/kotlin-koans)) or clone it directly. I've forked it, and created a new branch for my work (```git@github.com:RemyG/kotlin-koans.git```).

Then open the project in IntelliJ (Kotlin is supported and developed by JetBrains).

You can see that the project provides failing unit tests, as well as the skeleton for the classes to implement. All you need to do is implement the methods so the unit tests pass.

***

After having familiarized yourself with the basic Kotlin syntax, you can move to more practical experiments.

You can find good tutorials on how to integrate Kotlin with Spring Boot: [Creating a RESTful Web Service with Spring Boot](https://kotlinlang.org/docs/tutorials/spring-boot-restful.html), [Spring Boot and Kotlin](http://www.baeldung.com/spring-boot-kotlin).

Kotlin is also fully supported for Android development (see [this blog post](https://blog.jetbrains.com/kotlin/2017/05/kotlin-on-android-now-official/)), but that's not an area I'm working in.
