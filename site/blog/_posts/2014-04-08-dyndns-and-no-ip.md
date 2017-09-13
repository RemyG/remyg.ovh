---
title: DynDNS and No-IP
date: 2014-04-08T18:00:33+00:00
author: RemyG
layout: rg-post
categories: System
tags:
  - DynDNS
  - No-IP
---

For a few years now, I've been using a [DynDNS](http://dyn.com/dns/) free account to access my personal server (at home), even though I have a dynamic IP address. This means that I've had a URL that would always point to my server, even when my IP would change.

<!--more-->

But yesterday I've received an email from DynDNS:

>  For the last 15 years, all of us at Dyn have taken pride in offering you and millions of others a free version of our Dynamic DNS Pro product. What was originally a product built for a small group of users has blossomed into an exciting technology used around the world.
> That is why with mixed emotions we are notifying you that in 30 days, we will be ending our free hostname program. This change in the business will allow us to invest in our customer support teams, Internet infrastructure, and platform security so that we can continue to strive to deliver an exceptional customer experience for our paying customers.
> We would like to invite you to upgrade to VIP status for a 25% discounted rate, good for any package of Remote Access (formerly DynDNS Pro). By doing so, you'll have access to customer support, additional hostnames, and more.

I've always been very happy with the service I've received from DynDNS, since I had a free account, and the only action required from me was to click on a link they sent me every month (I think) to keep my account active. But I don't need this enough to pay for it.

So I've looked for a replacement for DynDNS, and I've found [No-IP](https://www.noip.com). It's a very similar service, that has a free plan, and allows you to register up to 3 hosts. The inscription process is self-explanatory, and lets you register 1 host.

After registering (and validating your account), you need to install an update client on your host, which will regularly (by default every 30 minutes) contact the No-IP servers to update your mapping IP / URL. This way, your URL will always point to your host, with a maximum delay of 30 minutes (don't use a free account if you need a good QOS with no or little "downtime"). The installation process of the client is very well explained on the knowledge base of No-IP: [How to Install the Dynamic Update Client on Linux](http://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client/).

I'm now the proud owner of the URL <http://remyg.no-ip.biz/>, which allows me to access my personal server via SSH (or HTTP if I decide to use it to test my web projects). The total time spent for the registration, installation and configuration was less than 20 minutes, which shows how easy and well-explained the process is.
