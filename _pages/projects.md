---
layout: rg-page
title: Projects
sidebar_link: false
permalink: "/projects/"
css: [fontawesome]
sitemap:
  lastmod: 2018-12-14
  changefreq: monthly
---

<div id="projects">
	<div class="project-cards">
		{% for project in site.data.projects %}
		<a class="project-card" href="{{project.url}}">
			<h2><i class="fas fa-{{project.icon}}"></i> {{ project.name }}</h2>
			<p>{{ project.description }}</p>
			<p class="tags">{{ project.category }} - {{ project.tags | join: " | " }}</p>
		</a>
		{% endfor %}
	</div>
</div>