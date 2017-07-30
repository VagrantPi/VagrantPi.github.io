---
layout: page
title: Tag Cloud
---
<ul class="tag-cloud">
{% assign sorted_tags = (site.tags | sort: 0) %}
{% for tag in sorted_tags %}
  <li class="tags-status">
    <a href="/tags/{{ tag[0] }}" class="tags">
      {{ tag | first }} ({{ tag | last | size }})
    </a>
  </li>
{% endfor %}
</ul>

<div id="test">
  {% include tagCloud.html %}
</div>
