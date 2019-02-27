---
title: Update Jekyll to version 1.0.2
date: 2013-05-14T18:00:45+00:00
author: RemyG
layout: rg-post
categories: Ops
tags:
  - Jekyll
  - Ubuntu
---

Today, I've updated my version of Jekyll from 0.12.1 to 1.0.2. I'll detail the procedure I followed to do it. Most of the commands have to be ran as root.

<!--more-->

## Clean the project

You will need to start by deleting the ```Gemfile.lock``` file, so it can be re-generated with the correct version numbers.

## Update the Jekyll gem

```
$ gem update jekyll
```

## Update the Kramdown gem

If you're using Kramdown as your markdown parser, you'll need to update it:

```
$ gem update kramdown
```

## Disable jekyll-press

If you're using jekyll-press to compress the generated output files, this plugin doesn't seem to be compatible with Uglifier 2.0.1 (one of the gems used by it). When I tried to run a local instance of Jekyll, I got this error:

```
error: Invalid option: inline_script
```

So you're going to have to disable it for now (I haven't found a solution yet). Edit your ```Gemfile``` and remove (or comment) the line:

```
gem 'jekyll-press'
```

## Retrieve all the gem dependencies

```
$ bundle
```

## Remove the automatic re-generation parameter

In your ```_config.yml``` file, remove (or comment) the line:

```
auto="true" # or "false"
```

## Run Jekyll

Now you should be able to run Jekyll. To launch a local instance, use:

```
$ jekyll serve
```

instead of:

```
$ jekyll --server
```

To run it with auto-regeneration, run:

```
$ jekyll serve --watch
```
