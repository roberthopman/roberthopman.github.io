---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

## Introductie

Mijn missie is vastgelopen IT projecten uit de brand helpen. 

Ik maak daarbij gebruik van de volgende [vragen](https://github.com/roberthopman/toetsing):

- Streeft het project een helder doel na of lost het een probleem op (zakelijke rechtvaardiging)?
- Is het project zo ingericht dat er vertrouwen is dat het doel ook wordt gehaald (slaagkans)?

Ik maak ook gebruik van de volgende technieken:

Ruby, Rails, JavaScript, PostgreSQL, MySQL, RSpec, Minitest, Git flow

## Artikelen

<ul style="list-style-type: none; margin: 0;">
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>

<br>
