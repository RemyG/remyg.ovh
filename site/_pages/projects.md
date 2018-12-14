---
layout: rg-page
title: Projects
sidebar_link: true
permalink: "/projects/"
css: [fontawesome]
js: [vue]
sitemap:
  lastmod: 2018-12-14
  changefreq: monthly
---

{% raw %}
<div id="projects">
  <div>
    Category: 
    <select id="categories" v-model="selectedCat">
      <option value="">All projects</option>
      <option v-for="cat in categories" v-bind:value="cat">
          {{ cat }}
      </option>
    </select>
  </div>
  <div class="project-cards">
    <template v-for="item in selectedProjects">
    <div class="project-card" :onclick="`location.href='${item.url}'`">
      <h2><i :class="`fas fa-${item.icon}`"></i> {{ item.name }}</h2>
      <p>{{ item.description }}</p>
      <p class="tags">{{ item.category }} - {{ item.tags.join(" | ") }}</p>
    </div>
    </template>
  </div>
</div>
{% endraw %}

<script>
  var projects = new Vue({
  el: '#projects',
  data: {
    selectedCat: '',
    items: {{ site.data.projects | jsonify }},
    categories: Array.from(new Set({{ site.data.projects | jsonify }}.flatMap(x => x.category))).filter(Boolean).sort()
  },
  computed: {
    selectedProjects: function() {
      return this.items.filter(item => this.selectedCat == '' || this.selectedCat == item.category);
    }
  }
})
</script>