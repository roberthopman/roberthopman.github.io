---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<div class="main">
  <div class="title">Hello</div>
  <div>I develop software.</div>
  
  {% for post in site.posts %}
  {% assign post_date = post.date | date: "%s" | plus: 0 %}
  {% assign eighteen_months_ago = "now" | date: "%s" | minus: 15552000 | plus: 0 %}

  {% if post_date >= eighteen_months_ago %}
    <div class="main-posts">Posts:</div>  
    <div class='column-date'>{{ post.date | date: "%d-%m-%Y" }}</div>
    <div class='column-title'><a href="{{ post.url }}">{{ post.title }}</a></div>
  {% endif %}
  {% endfor %}
</div>

<a href="/archive">Archived Posts</a>