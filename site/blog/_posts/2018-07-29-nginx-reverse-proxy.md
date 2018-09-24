---
title: NGINX Reverse Proxy
date: 2018-07-29T10:00:0+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - docker
  - nginx
---

My home server setup is composed of several Raspberry Pi, where I host different web applications (this blog, an RSS reader, some home IOT apps...). I've decided to setup a front gateway, that proxies the request to the right server:

![Infrastructure]({{ site.cdn_url }}/reverse-proxy.png)

<!--more-->

The requests are proxied by an NGINX reverse proxy, running in a Docker container on the gateway. It redirects the HTTP requests based on the host (eg. ```remyg.ovh``` runs on ```rpi1``` when ```rss.remyg.ovh``` runs on rpi2).

## NGINX Configuration

The main NGINX conf file (```nginx.conf```) looks like this:

```
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/sites-enabled/*.*;
}
```

The only difference with the base conf file (from the default NGINX Docker image) is the last line:

```
include /etc/nginx/conf.d/*.conf;
```

is replaced by

```
include /etc/nginx/sites-enabled/*.*;
```

It ignores the default configuration (```/etc/nginx/conf.d/default.conf```) and uses the proxy configuration files that I defined.

## Hosts Configuration

Each host has its own configuration file:

* for **remyg.ovh**, running on rpi1 (with a local IP 192.168.0.10, and port 8080):

```
server {
    listen 80;
    server_name remyg.ovh;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    location / {
        proxy_pass       http://192.168.0.10:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect   off;
    }
}
```

* for **rss.remyg.ovh**, running on rpi2 (with a local IP 192.168.0.11, and port 8081):

```
server {
    listen 80;
    server_name rss.remyg.ovh;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    location / {
        proxy_pass       http://192.168.0.11:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect   off;
    }
}
```

These files indicate that a request incoming to rss.remyg.ovh:80 (```server_name``` and ```listen```) will be redirected to 192.168.0.11:8081 (```proxy_pass```).

That's all the configuration you need to serve websites on HTTP.

## Running in Container

To run the reverse proxy in a Docker container, the file tree looks like this:

```
nginx-reverse-proxy
  -> conf
    -> nginx.conf
  -> sites
    -> remyg.ovh
       rss.remyg.ovh
```

With this structure, the command launching the container will be:

```
docker run --name mynginx-proxy \
  -v /home/pi/nginx-reverse-proxy/sites:/etc/nginx/sites-enabled:ro \
  -v /home/pi/nginx-reverse-proxy/conf/nginx.conf:/etc/nginx/nginx.conf:ro \
  -p 80:80 -d nginx:alpine
```

## HTTPS

To enable HTTPS on the different sites, I'm using Let's Encrypt, and their utility app Certbot.

I'm starting by installing the ```certbot``` package:

```
sudo apt install certbot
```

When generating a certificate, Certbot will need to validate that it can access a specific file that it generates, pointing to the URL ```http://your-host/.well-known/acme-challenge/{token}```. To do that, start by creating and mounting a new volume on the reverse proxy container:

```
docker run --name mynginx-proxy \
        -v /home/pi/nginx-reverse-proxy/sites:/etc/nginx/sites-enabled:ro \
        -v /home/pi/nginx-reverse-proxy/conf/nginx.conf:/etc/nginx/nginx.conf:ro \
        -v /home/pi/letsencrypt_www:/var/www/letsencrypt \
        -p 80:80 -p 443:443 -d nginx:alpine
```

Then specify in the sites proxy configuration that this volume is used when pointing to ```/.well-known/acme-challenge/```:

```
server {
    listen 80;
    server_name remyg.ovh;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt;
    }

    location / {
        proxy_pass       http://192.168.0.10:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect   off;
    }
}
```

And reload your NGINX config:

```
docker exec -it mynginx-proxy nginx -s reload
```

Now you can generate the certificate(s) :

```
sudo certbot certonly --authenticator webroot -w /home/pi/letsencrypt_www -d remyg.ovh -d rss.remyg.ovh
```

This will generate the ACME challenge files in ```/home/pi/letsencrypt_www```, and validate the challenge. It will also generate the certificates, in ```/etc/letsencrypt/certs/live/remyg.ovh/``` and ```/etc/letsencrypt/certs/live/rss.remyg.ovh/```.

The last step is to use the new certificates, and only allow HTTPS requests.

Start by mounting a new volume, containing the certificates:

```
docker run --name mynginx-proxy \
        -v /home/pi/nginx-reverse-proxy/sites:/etc/nginx/sites-enabled:ro \
        -v /home/pi/nginx-reverse-proxy/conf/nginx.conf:/etc/nginx/nginx.conf:ro \
        -v /etc/letsencrypt:/etc/nginx/certs \
        -v /home/pi/letsencrypt_www:/var/www/letsencrypt \
        -p 80:80 -p 443:443 -d nginx:alpine
```

Then update your proxy configuration:

```
server {
    listen 80;
    server_name remyg.ovh;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name remyg.ovh;

    ssl_certificate certs/live/remyg.ovh/fullchain.pem;
    ssl_certificate_key certs/live/remyg.ovh/privkey.pem;

    location / {
        proxy_pass       http://192.168.0.10:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect   off;
    }
}
```

Reload the NGINX configuration, and you're all set!
