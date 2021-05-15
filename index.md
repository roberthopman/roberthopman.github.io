---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

## Introductie

Als software ontwikkelaar vind ik het leuk om producten en teams te bouwen die zorgen voor een mooi resultaat. 

<br>

## Welke technieken gebruik je?

Ruby, Rails, JavaScript, PostgreSQL, MySQL, RSpec, MiniTest, Git flow

<br>

## Artikelen

<ul style="list-style-type: none; margin: 0;">
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>

<br>
