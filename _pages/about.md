---
layout: rg-page
title: About Me
sidebar_link: false
permalink: "/about/"
sitemap:
  lastmod: 2018-09-19
  changefreq: monthly
---

## Who am I?

{% assign dob = "1987-05-26" | date: "%s" %}
{% assign now = "now" | date: "%s" %}

My name is Rémy Gardette, I'm a {{ now | minus: dob | divided_by: 3600 | divided_by: 24 | divided_by: 365 }} years old Software Engineer and Enthusiast, and I live near Lille, in the north of France.

## Resume

Find my complete resume on [LinkedIn]({{ site.social.linkedin.baseurl }}{{ site.social.linkedin.username }}).

## Want to help?

You can tip me:

### Ether

<img src="{{ site.cdn_url }}/ether.png" id="ether-qr-code" alt="Ether QR code"/>

<div class="wallet-address"><pre>0x72b65112d90782b85c00D8C53BE3a1d2C9845080</pre></div>

### Bitcoin

<img src="{{ site.cdn_url }}/bitcoin.png" id="bitcoin-qr-code" alt="Bitcoin QR code" />

<div class="wallet-address"><pre>14My8gg6KLRKonGA3aNzQHB3zeWfqNq1Z7</pre></div>

### PayPal

<a href="https://paypal.me/remygardette" target="_blank" class="button center">Donate with PayPal</a>

### Buy me a coffee

<a href='https://ko-fi.com/H2H8VHJI' target='_blank'>
  <img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=2' alt='Buy Me a Coffee at ko-fi.com' />
</a>