---
layout: default
title: Tags
hide_author: true
permalink: /tags/
---

<div class="main">
  <h1>Browse by Tag</h1>

  {% assign sorted_tags = site.tags | sort %}
  {% for tag in sorted_tags %}
    {% assign tag_name = tag[0] %}
    {% assign posts = tag[1] %}
    <div class="tag-group">
      <h2 id="{{ tag_name | slugify }}">
        <a href="/tags/{{ tag_name | slugify }}/">{{ tag_name }}</a>
        <span class="tag-count">({{ posts | size }})</span>
      </h2>
      <ul class="post-list">
        {% for post in posts %}
          <li>
            <span class="post-meta">{{ post.date | date: "%d-%m-%Y" }}</span>
            <a href="{{ post.url }}">{{ post.title }}</a>
          </li>
        {% endfor %}
      </ul>
    </div>
  {% endfor %}
</div>

<a href="/">Home</a>
