---
title: Auto-upload Jekyll after pushing to GitHub
date: 2013-03-05T18:00:10+00:00
author: RemyG
layout: rg-post
categories: System
tags:
  - FTP
  - GitHub
  - Jekyll
---

My Jekyll site is hosted on a shared web hosting service, provided by OVH. It's the most basic service, which consists of a PHP server, a MySql database, and that's about it. The only way to change the files on the server is to access it via FTP, as there is no SSH connection available.

So, with the concept of Jekyll, which is to generate static HTML files and use them for the final web site, the only option I had was to manually upload the ```_site``` folder each time I made some changes in the source code. And this after pushing my changes to GitHub (the sources and generated files are stored in a public GitHub repository).

<!--more-->

But I've actually found another way to automate the process. For this I need my personnal server, which is an old eeePc running Debian I have at home (but can't use as a web server, for basic QoS reasons).

<!--more-->

## Clone the git repository

I started by cloning the repository on my personnal server:

```
$ cd /home/username
$ mkdir jekyll
$ git clone https://github.com/RemyG/remyg.fr.git jekyll
```

This create a clone of the repository in ```/home/username/jekyll```.

## Create the FTP upload script

To automatically upload my files via FTP, I used ```lftp```:

```
$ sudo apt-get install lftp
```

Then I've created the script used to upload my ```_site``` folder to the shared server:

```
$ touch /usr/local/bin/ftp-upload-jekyll.sh
$ chmod +x /usr/local/bin/ftp-upload-jekyll.sh
$ vim /usr/local/bin/ftp-upload-jekyll.sh
```

The content of the script is a simple ```mirror``` command:

```
#!/bin/sh

lftp -u your_username,your_password your_host_url <<EOF

cd /dest_folder/_site # The distant directory
lcd /home/username/jekyll/_site # The local directory

mirror -R

quit 0

EOF
```

When this script is executed, it will upload the content of the local ```_site``` folder on the host ```your_host_url```.

## Create the git pull script

Before uploading the website to the server, the repository has to be pulled. I've created a script for it:

```
$ touch /usr/local/bin/github-pull-jekyll.sh
$ chmod +x /usr/local/bin/github-pull-jekyll.sh
$ vim /usr/local/bin/github-pull-jekyll.sh
```

The content of the script is simply:

```
#!/bin/sh

cd /home/username/jekyll
git pull
```

When this script is executed, it will pull the repository.

## Create a GitHub post-receive hook

### On my personnal server

I've just created a PHP file, which is exposed on Internet.

```
$ cd /var/www
$ vim github-hook.php
```

The content of this file is very simple: first it pulls the repository, then it calls the script ```ftp-upload-jekyll.sh``` to upload the content of the ```_site``` folder to the shared server.

```
<?php
    `sh /usr/local/bin/github-pull-jekyll.sh`;
    `sh /usr/local/bin/ftp-upload-jekyll.sh`;
?>
```

### On GitHub

Then I just had to create the post-receive hook on GitHub, as described on the <a href='https://help.github.com/articles/post-receive-hooks'>GitHub documentation</a>. The WebHook URL is the URL of the PHP file on my personnal server.

## Conclusion

Now, each time I push some changes to my GitHub repository, they are automatically uploaded to my web server, and instantly available to be browsed.
