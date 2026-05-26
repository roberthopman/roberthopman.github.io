---
layout: default
hide_author: true
---

<div class="main">
  <div>Field notes about building and maintaining B2B technology by Robert, <a href="/author/">say hello</a>.</div>
  <br>

  {% for post in site.posts limit:10 %}
  <div class='post-row'>
    <div class='column-date'>{{ post.date | date: "%d-%m-%Y" }}</div>
    <div class='column-title'><a href="{{ post.url }}">{{ post.title }}</a></div>
  </div>
  {% endfor %}

</div>