---
title: Display GitHub repositories on Jekyll
date: 2013-03-08T18:00:35+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - GitHub
  - Jekyll
---

This website is mostly meant to present my personnal work and projects, which are stored on GitHub. That's why I wanted to display the last GitHub repositories I've worked on.

To do that, I've decided to use jQuery to make an AJAX call to the GitHub API, and display the result on my home page.

<!--more-->

## Get jQuery

Start by downloading the compressed version of jQuery (for me it was jquery-1.9.1.min.js) on [the official site](http://jquery.com/download/). Save the file in the directory ```assets/themes/your_theme/js/```.

Include the script file in your default layout (```_includes/themes/your_theme/default.html```). I always include the file in the head of the HTML:

```
...
{% raw %}
{% for item in page.js %}
    {% if item == 'jquery' %}
        <script type="text/javascript" src="{{ ASSET_PATH }}/js/jquery-1.9.1.min.js"></script>
    {% endif %}
{% endfor %}    
{% endraw %}
</head>
```

The loop and condition allow me to only include the file when needed. I'll explain later how to trigger the include in a specific page.

## Create the layout used to display the repositories

The layout is created as ```_includes/JB/github``` (no extension).

```
{% raw %}
{% if site.github.user %}
    <section>
        <h2>On GitHub</h2>
        <div id="gh_repos">
            <p>Status updating...</p>
        </div>
        {% if site.github.show_profile_link %}
            <a href="https://github.com/{{site.github.user}}"
                title="Follow {{site.github.user}} on Github" id="followGithub" class="noBg">
                <img src="https://github.com/favicon.ico" />
                <span>Follow me on Github</span>
            </a>
        {% endif %}
    </section>
{% endif %}
{% endraw %}
```

The configuration for ```site.github.user``` and ```site.github.show_profile_link``` will be put in ```_config.yml```.

## Make the AJAX call and display the results

I want to display my repositories on my home page, which is ```index.md``` for my configuration.

First you have to enable the inclusion of jQuery for this page. So add this in the YAML Front Matter:

```
js: [jquery]
```

Then, we have to include the layout ```github``` we just wrote, where we want to display the list of repositories:

```
{% raw %}{% include JB/github %}{% endraw %}
```

Now it's time to write the AJAX call that will retrieve the list. I use jQuery to simplify the JS manipulation, but you can write all this in basic JS:

```
<script type="text/javascript">
// <!--
    $.ajax({
        type: "GET",
        url: 'https://api.github.com/users/{{ site.github.user }}/repos?callback=?',
        data: { type: "all", sort: "pushed", direction: "desc" },
        dataType: 'json',
        success: function(resp) {
            if (resp.data.length > 0) {
                $('#gh_repos').html('<ul></ul>');
                for(var i = 0; i < $(resp.data).length && i < {{ site.github.repo_count }}; i++)
                {
                   $('#gh_repos > ul').append(
                        '<li><a href="' + resp.data[i]['html_url'] + '">'
                        + resp.data[i]['name'] + '</a>'
                        + '<p>'
                        + (resp.data[i]['description'] ? resp.data[i]['description'] : '(No description)')
                        + '</p></li>'
                    );
                }
            }
            else {
                $('#gh_repos').html('<p>No public repositories.</p>');
            }
        }
    });
// -->
</script>
```

## Configure Jekyll to retrieve the repositories

And then it's just a matter of configuring your GitHub information. In ```_config.yml```, just add:

```
github:
  user: your_github_username
  repo_count: 5
  show_profile_link: true
```
