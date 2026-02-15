---
layout: default
title: Archive
hide_author: true
---

<div class="main">

  <div class="archive-filters">
    <div class="filter-group">
      <span class="filter-label">Words:</span>
      <button class="filter-btn active" data-filter="words" data-value="all">All</button>
      <button class="filter-btn" data-filter="words" data-value="short">&lt;400</button>
      <button class="filter-btn" data-filter="words" data-value="medium">400-800</button>
      <button class="filter-btn" data-filter="words" data-value="long">800+</button>
    </div>
    <div class="filter-group">
      <span class="filter-label">Tag:</span>
      <input type="text" id="tag-filter" placeholder="Type to filter by tag..." autocomplete="off">
      <div id="tag-suggestions"></div>
    </div>
  </div>

  {% for post in site.posts %}
  {% assign post_date = post.date | date: "%s" | plus: 0 %}
  {% assign eighteen_months_ago = "now" | date: "%s" | minus: 15552000 | plus: 0 %}

  {% if post_date >= eighteen_months_ago %}
  <div class='post-row' data-tags="{{ post.tags | join: ',' | downcase }}" data-words="{{ post.content | number_of_words }}">
    <div class='column-date'>{{ post.date | date: "%d-%m-%Y" }}</div>
    <div class='column-title'><a href="{{ post.url }}">{{ post.title }}</a></div>
  </div>
  {% endif %}
  {% endfor %}

  {% for post in site.posts %}
  {% assign post_date = post.date | date: "%s" | plus: 0 %}
  {% assign eighteen_months_ago = "now" | date: "%s" | minus: 15552000 | plus: 0 %}

  {% if post_date < eighteen_months_ago %}
  <div class='post-row' data-tags="{{ post.tags | join: ',' | downcase }}" data-words="{{ post.content | number_of_words }}">
    <div class='column-date'>{{ post.date | date: "%d-%m-%Y" }}</div>
    <div class='column-title'><a href="{{ post.url }}">{{ post.title }}</a></div>
  </div>
  {% endif %}
{% endfor %}

  {% for page in site.pages %}
  {% if page.tags and page.tags.size > 0 %}
  <div class='post-row' data-tags="{{ page.tags | join: ',' | downcase }}" data-words="{{ page.content | number_of_words }}">
    <div class='column-date'>{{ page.last_modified_at }}</div>
    <div class='column-title'><a href="{{ page.url }}">{{ page.title }}</a></div>
  </div>
  {% endif %}
  {% endfor %}

  <p class="filter-count"></p>
</div>

<a href="/">Home</a>

<script>
(function() {
  var rows = document.querySelectorAll('.post-row');
  var wordBtns = document.querySelectorAll('[data-filter="words"]');
  var tagInput = document.getElementById('tag-filter');
  var tagSuggestions = document.getElementById('tag-suggestions');
  var countEl = document.querySelector('.filter-count');

  var activeWord = 'all';
  var activeTag = 'all';

  // Collect all tags from post data
  var tagSet = {};
  rows.forEach(function(row) {
    var tags = row.getAttribute('data-tags');
    if (tags) {
      tags.split(',').forEach(function(t) {
        t = t.trim();
        if (t) tagSet[t] = true;
      });
    }
  });
  var allTags = Object.keys(tagSet).sort();

  function applyFilters() {
    var visible = 0;
    rows.forEach(function(row) {
      var words = parseInt(row.getAttribute('data-words'), 10);
      var tags = row.getAttribute('data-tags') || '';
      var showWord = activeWord === 'all' ||
        (activeWord === 'short' && words < 400) ||
        (activeWord === 'medium' && words >= 400 && words <= 800) ||
        (activeWord === 'long' && words > 800);
      var showTag = activeTag === 'all' || tags.split(',').indexOf(activeTag) !== -1;
      if (showWord && showTag) {
        row.style.display = '';
        visible++;
      } else {
        row.style.display = 'none';
      }
    });
    if (activeWord === 'all' && activeTag === 'all') {
      countEl.textContent = '';
    } else {
      countEl.textContent = visible + ' of ' + rows.length + ' posts';
    }
  }

  function showSuggestions(query) {
    tagSuggestions.innerHTML = '';
    if (!query) {
      tagSuggestions.style.display = 'none';
      return;
    }
    var matches = allTags.filter(function(t) {
      return t.indexOf(query.toLowerCase()) !== -1;
    });
    if (matches.length === 0) {
      tagSuggestions.style.display = 'none';
      return;
    }
    matches.forEach(function(tag) {
      var div = document.createElement('div');
      div.className = 'tag-suggestion';
      div.textContent = tag;
      div.addEventListener('mousedown', function(e) {
        e.preventDefault();
        tagInput.value = tag;
        activeTag = tag;
        tagSuggestions.style.display = 'none';
        applyFilters();
      });
      tagSuggestions.appendChild(div);
    });
    tagSuggestions.style.display = 'block';
  }

  tagInput.addEventListener('input', function() {
    var val = tagInput.value.trim();
    if (val === '') {
      activeTag = 'all';
      applyFilters();
    }
    showSuggestions(val);
  });

  tagInput.addEventListener('focus', function() {
    if (tagInput.value.trim()) showSuggestions(tagInput.value.trim());
  });

  tagInput.addEventListener('blur', function() {
    tagSuggestions.style.display = 'none';
  });

  tagInput.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      tagInput.value = '';
      activeTag = 'all';
      tagSuggestions.style.display = 'none';
      applyFilters();
    }
  });

  wordBtns.forEach(function(btn) {
    btn.addEventListener('click', function() {
      wordBtns.forEach(function(b) { b.classList.remove('active'); });
      btn.classList.add('active');
      activeWord = btn.getAttribute('data-value');
      applyFilters();
    });
  });
})();
</script>
