---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<svg id="clock" xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200">
  <circle cx="100" cy="100" r="95" fill="none" stroke="black" stroke-width="5" />
  <line id="hour" x1="100" y1="100" x2="100" y2="50" stroke="black" stroke-width="8" stroke-linecap="round" />
  <line id="minute" x1="100" y1="100" x2="100" y2="30" stroke="black" stroke-width="6" stroke-linecap="round" />
  <line id="second" x1="100" y1="100" x2="100" y2="20" stroke="red" stroke-width="4" stroke-linecap="round" />
  <circle cx="100" cy="100" r="5" fill="black" />
</svg>

<script>
  function updateClock() {
    var now = new Date(),
        seconds = now.getSeconds(),
        minutes = now.getMinutes(),
        hours = now.getHours();
    
    document.getElementById('second').setAttribute('transform', 'rotate(' + seconds * 6 + ', 100, 100)');
    document.getElementById('minute').setAttribute('transform', 'rotate(' + (minutes * 6 + seconds * 0.1) + ', 100, 100)');
    document.getElementById('hour').setAttribute('transform', 'rotate(' + (hours % 12 / 12 * 360 + minutes / 60 * 30) + ', 100, 100)');
    
    setTimeout(updateClock, 1000);
  }

  updateClock(); 
</script>
  

  <ul style="list-style-type: none; margin: 0;">
    {% for post in site.posts %}
      <li>
        <a href="{{ post.url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
  </ul>
<br>
