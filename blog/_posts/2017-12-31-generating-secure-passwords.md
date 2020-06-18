---
title: Generating secure passwords
date: 2017-12-31T10:00:0+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - Python
  - password
  - Diceware
description: Use the Diceware method to generate much more secured and easy to remember passwords / passphrases.
---

I've recently ordered and received a [YubiKey Neo](https://www.yubico.com/), which is a security key that can be used for two-factor authentication. This has motivated me to step up my security with stronger passwords.

<!--more-->

Some time ago, I read this comic on xkcd:
![Password Strength](https://imgs.xkcd.com/comics/password_strength.png)
Source: [xkcd](https://www.xkcd.com/936/)

It explains that a passphrase, that can be easily remembered, is actually much more difficult to guess for an attacker than a password with every "extra" security recommendation (caps, special characters, numbers...).

## Generating a passphrase

A common method to generate a random passphrase is [the Diceware method](http://world.std.com/%7Ereinhold/diceware.html).

> Diceware™ is a method for picking passphrases that uses dice to select words at random from a special list called the Diceware Word List. Each word in the list is preceded by a five digit number. All the digits are between one and six, allowing you to use the outcomes of five dice rolls to select a word from the list.

The regular way to generate a passphrase is to throw a dice 5 times in a row. This will give you a five-digit number, that you can lookup on the word list, and get the matching word. Repeat the operation as many times as you want words, and you get your randomly generated passphrase.

## Automating the generation

Throwing dice 30+ times can be boring. So I've decided to write a passphrase generator based on the Diceware method.

The program, written in Python, asks you to choose the number of words in your passphrase, and the words separator (you can use any character for this).

```
$ python passgen.py                              
How many words will the password contain?  > 6
What character should separate the words?  > .
Generating a 6 words password, with >.< as separator.
thyme.gear.plum.dogma.yore.rubric
```

The program is based on the ```random.SystemRandom``` class to generate random numbers.

You can find the sources [on GitHub](https://github.com/RemyG/passgen).