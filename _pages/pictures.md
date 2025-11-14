---
layout: rg-page
title: Pictures
sidebar_link: false
permalink: "/pictures/"
sitemap:
  lastmod: 2022-01-18
  changefreq: weekly
---

<div class="gallery">
{% for picture in site.data.pictures %}

<a href="{{ picture.url }}" target="_blank">
<div class="picture">
<img src="{{ picture.src }}" alt="{{ picture.title }}">
<div class="title">{{ picture.title }}</div>
</div>
</a>
{% endfor %}
</div>
