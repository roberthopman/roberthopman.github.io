---
layout: default
title: Archive
---

<div class="main">
  <div class="title">Archive:</div>
  {% for post in site.posts %}
  {% assign post_date = post.date | date: "%s" | plus: 0 %}
  {% assign eighteen_months_ago = "now" | date: "%s" | minus: 15552000 | plus: 0 %}

  {% if post_date < eighteen_months_ago %}
  <div class='post-row'>
    <div class='column-date'>{{ post.date | date: "%d-%m-%Y" }}</div>
    <div class='column-title'><a href="{{ post.url }}">{{ post.title }}</a></div>
  </div>
  {% endif %}
{% endfor %}
</div>

<a href="/">Recent Posts</a>
