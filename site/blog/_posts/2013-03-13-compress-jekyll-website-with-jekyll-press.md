---
title: Compress Jekyll website with jekyll-press
date: 2013-03-13T18:00:50+00:00
author: RemyG
layout: rg-post
categories: System
tags:
  - Jekyll
  - jekyll-press
  - Ubuntu
---

To compress your output files (from the ```_site``` folder), you can use [jekyll-press](https://github.com/stereobooster/jekyll-press).

It's very easy to install, configure and enable.

<!--more-->

## Install g++

Install ```build-essential``` and ```g++```:

```
sudo apt-get install build-essential g++
```

## Install the bundler gem

```
sudo gem install bundler
```

## Install jekyll-press

In the root folder of your Jekyll instance, create a file ```Gemfile```, and add this:

```
source 'https://rubygems.org'

gem 'jekyll'
gem 'execjs'
gem 'therubyracer'
gem 'jekyll-press'
```

Then execute:

```
$ bundle
```

## Enable jekyll-press

Create the following plugin in your project's ```_plugins``` directory.

```
# _plugins/bundler.rb
require &quot;rubygems&quot;
require &quot;bundler/setup&quot;
Bundler.require(:default)
```

This will automatically require all of the gems specified in your Gemfile.

## Configure jekyll-press

In your ```_congif.yml``` file, add this block:

```
jekyll-press:
  exclude: 'atom.xml' # Exclude files from processing - file name, glob pattern or array of file names and glob patterns
  js_options: {}      # js minifier options
  css_options: {}     # css minifier options
  html_options: {}    # html minifier options
```

## Enjoy

Next time you rebuild your website, the output files will be compressed.
