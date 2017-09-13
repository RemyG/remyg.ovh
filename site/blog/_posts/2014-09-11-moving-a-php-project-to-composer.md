---
title: Moving a PHP project to Composer
date: 2014-09-11T17:00:07+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - Composer
  - PHP
  - PropelORM
---

A few months ago, I've discovered [Composer][composer], which is a dependency manager for PHP (you can compare it to Maven, for Java). With Composer, you can simply checkout the main project, and install the dependencies.

The transition to a Composer project is very easy, so I decided to start using Composer in my [ComicsCalendar][comicscalendar] project. In this post, I'll explain how you can migrate to Composer for a very simple project (in this case, using [PropelORM][propel1] to access your databases).

<!--more-->

The project structure at the start of this work is:
```
- comicslist
	- application
		+ build
		+ config
		+ controllers
		+ helper
		- plugins
			+ propel
			  recaptchalib.php
		+ views
		  build.properties
		  propel-gen
		  runtime-conf.xml
		  schema.xml
	+ static
	+ system
	  .gitignore
	  .gitmodules
	  .htaccess
	  index.php
```

## 1. Install Composer

It's really easy to install Composer. Just follow the instructions on [the official documentation][composer-install].

In the following commands, I'll assume that you've installed Composer so you can run it with:
```
$ composer
```

## 2. Create the setup file

Each Composer project requires a `composer.json` file. This file (equivalent to the `pom.xml` file for Maven), contains a list or the project dependencies (and lots of other things I won't mention here).

Create a `composer.json` file at the root of your project:
```
{
	"require": {
		"propel/propel1": "1.7.1"
	}
}
```

As you can guess, this will install version 1.7.1 of PropelORM.

This is the only dependency you will install right now (Composer automatically installs the dependencies of your dependencies).

## 3. Install the dependencies

To install the dependencies, run from the project root:
```
$ composer install
```

This command created the `vendor` folder (if it doesn't exist), and the `vendor/autoload.php` file, which contains the list of files to include into the project.

## 4. Include the dependencies in the project

The work is almost done, you just need to include the dependencies in your project. As I just explained, the file `vendor/autoload.php` contains the dependencies you need to include.

Just include this file in any "global" PHP file:
```
<?php
require_once('vendor/autoload.php');
```

## 5. Clean-up the project

The last action is to clean-up the project from the previous Propel installation. Remove the `application/plugins/propel` folder (which contains the old Propel classes), the `.gitmodules` file (which contains references to the Git sub-modules), as well as the reference to the main Propel script (which is now referenced in the `autoload.php` file).

## 6. Configure Git

If you're using Git to track your sources, you'll need to add a few changes to your project.

Add a `.gitignore` file at the root of the `vendor` folder, containing:

```
*
!.gitignore
```

This will allow you to commit the `vendor` folder, without any sub-folders (those will be re-created when running `$ composer install`).

You also need to add the `composer.json` and `composer.lock` files. The `composer.lock` file contains the actual versions of all your dependencies (since you can specify ranges in the versions), so someone who installs the dependencies will have the same versions as you do.

---

You're now ready to keep using PropelORM, and add new dependencies that could help you (yes Monolog, I'm looking at you...).


[composer]: https://getcomposer.org/ "Composer"
[propel1]: http://propelorm.org/Propel/ "Propel - The Fast PHP5 ORM"
[comicscalendar]: https://github.com/RemyG/ComicsCalendar "ComicsCalendar on GitHub"
[composer-install]: https://getcomposer.org/doc/00-intro.md#installation-nix "Composer - Installation - *nix"
