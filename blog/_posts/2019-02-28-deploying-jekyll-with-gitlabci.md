---
title: Deploying Jekyll with GitLabCI
date: 2019-02-27T10:00:0+00:00
author: RemyG
layout: rg-post
categories: Ops
tags:
  - Jekyll
  - GitLabCI
description: Automated deployment of a Jekyll website, using a GitLabCI pipeline.
---

My blog is based on [Jekyll][jekyll], a static website generator. This means that the pages need to be generated before they're deployed. Until recently, I used to build the content locally using a [Jekyll Docker image][jekyll-image], commit and push the generated content to my [GitHub repo][github-repo], SSH to my web server, and pull the changes from the repo.

The process was quite annoying, which is why I decided to set up a CI/CD (Continuous Integration and Delivery) pipeline, using [GitLabCI][gitlab-ci].

<!--more-->

## Pipeline

The CI/CD pipeline I've implemented is the following:

![GitLabCI Pipeline]({{ site.baseurl }}/assets/img/jekyll-gitlab-ci.png)

The pipeline is defined in a file ```.gitlab-ci.yml``` at the root of the project:

```yaml
image: ruby:2.5

cache:
  key: "jekyll"
  paths:
    - vendor

variables:
  JEKYLL_ENV: production
  LC_ALL: C.UTF-8
  NOKOGIRI_USE_SYSTEM_LIBRARIES: "true"

before_script:
- bundle install

test:
  stage: test
  script:
  - bundle exec jekyll build -d ./public
  - bundle exec htmlproofer ./public --only-4xx --check-favicon --check-html --assume-extension
  artifacts:
    paths:
    - public

deploy:
  stage: deploy
  before_script:
  - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
  - eval $(ssh-agent -s)
  - ssh-add <(echo "$SSH_PRIVATE_KEY" | base64 -d)
  - mkdir -p ~/.ssh
  - chmod 700 ~/.ssh
  - echo "$SSH_HOST_KEY" > ~/.ssh/known_hosts
  - chmod 644 ~/.ssh/known_hosts
  - which rsync || ( apt-get update -y && apt-get install rsync -y )
  script:
  - ssh -p$SSH_PORT $SSH_SRV "mkdir -p /tmp/jekyll"
  - ssh -p$SSH_PORT $SSH_SRV "rm -rf /tmp/jekyll_old"
  - ssh -p$SSH_PORT $SSH_SRV "mv /tmp/jekyll /tmp/jekyll_old"
  - rsync -rav -e "ssh -p $SSH_PORT" --exclude='.git/' --exclude='.gitlab-ci.yml' --delete-excluded ./public $SSH_SRV:/tmp/jekyll
  - ssh -p$SSH_PORT $SSH_SRV "sh /home/gitlabci/rsync-jekyll.sh"
  only:
  - master
```

It consists of 2 steps: ```test``` and ```deploy```.

The ```test``` step builds the Jekyll project, then runs [HTMLProofer][html-proofer] on the generated files. This step will check and validate the HTML output.

The ```deploy``` step transfers the generated files to my home gateway, then runs a script (located on the gateway) to transfer those files to my web server (the web server is not exposed outside of my network).

## SSH Configuration

The gateway is accessed via SSH. To do that, I've created a specific SSH key only used by GitLab CI.

To generate a new SSH key:

```
ssh-keygen -o -t rsa -b 4096 -C "gitlabci"
```

The public key needs to be added to the authorized keys before it can be used:

```
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

## Configuration

The pipeline contains variables to improve the security:

- ```SSH_PRIVATE_KEY```: a base-64 representation of the SSH private key used to access my gateway. The value is retrieved by running this command on the gateway:  
```cat id_rsa > base64 -w0```
- ```SSH_HOST_KEY```: the RSA key of the gateway. Retrieved by running on the gateway:  
```ssh-keyscan -t rsa server_ip```
- ```SSH_SRV```: the SSH connection information, like ```my_user@my_server```
- ```SSH_PORT```: the SSH port on the gateway

## Usage

I can now follow the following process to publish changes to my website:

- if needed, clone the GitHub repo on my computer
- make the changes (create a new blog post,...)
- test the changes locally (the Docker compose file allows me to build and serve the website on my computer)
- commit and push the changes
    - if I push to a branch other than ```master```, only the ```test``` step is executed
    - if I push to ```master```, the whole pipeline is executed, so my site is built, tested and automatically deployed.



[jekyll]: https://jekyllrb.com/ "Jekyll"
[jekyll-image]: https://hub.docker.com/r/jekyll/jekyll "Jekyll Docker image"
[github-repo]: https://github.com/RemyG/remyg.ovh "Sources on GitHub"
[gitlab-ci]: https://docs.gitlab.com/ee/ci/ "GitLab Continuous Integration (GitLab CI/CD)"
[html-proofer]: https://github.com/gjtorikian/html-proofer "HTMLProofer"