---
layout: rg-page
title: Pictures
sidebar_link: true
permalink: "/pictures/"
sitemap:
  lastmod: 2022-01-18
  changefreq: weekly
pictures:
  - url: https://flic.kr/p/2mXTMyf
    src: https://live.staticflickr.com/65535/51828339146_f471f04f30_k.jpg
    title: 18/01/2022 - Dans le brouillard
  - url: https://flic.kr/p/2mXBrFT
    src: https://live.staticflickr.com/65535/51825150517_55c9dc2574_k.jpg
    title: 13/01/2022 - Sortie boueuse
  - url: https://flic.kr/p/2mXJ3Va
    src: https://live.staticflickr.com/65535/51826439699_6b110d9624_k.jpg
    title: 09/01/2022 - Mont Kemmel
  - url: https://flic.kr/p/2mXTFa6
    src: https://live.staticflickr.com/65535/51828317619_275612f57f_k.jpg
    title: 06/01/2022 - Traversée des champs
---

<div class="gallery">
{% for picture in page.pictures %}

<a href="{{ picture.url }}">
<div class="picture">
<img src="{{ picture.src }}" alt="{{ picture.title }}">
<div class="title">{{ picture.title }}</div>
</div>
</a>
{% endfor %}
</div>
