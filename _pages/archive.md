---
layout: rg-page
title: Archive
permalink: "/archive/"
sitemap:
  lastmod: 2018-09-19
  changefreq: monthly
---

{% for post in site.posts  %}
{% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}
{% capture next_year %}{{ post.previous.date | date: "%Y" }}{% endcapture %}

{% if forloop.first %}
<h2 id="{{ this_year }}-ref">{{this_year}}</h2>
<ul class="archive">
{% endif %}

<div class="listing-post">
<a href="{{ post.url }}">{{ post.title }}</a>
<div class="post-date">{{ post.date | date: "%b %d" }}</div>
</div>

{% if forloop.last %}
</ul>
{% else %}
{% if this_year != next_year %}
</ul>
<h2 id="{{ next_year }}-ref">{{next_year}}</h2>
<ul class="archive">
{% endif %}
{% endif %}
{% endfor %}