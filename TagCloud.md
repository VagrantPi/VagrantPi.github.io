---
layout: page
title: Tag Cloud
---
<ul class="tag-cloud">
{% for tag in site.tags %}
  <li class="tags-status">
    <a href="/tags/{{ tag[0] }}" class="tags">
      {{ tag | first }} ({{ tag | last | size }})
    </a>
  </li>
{% endfor %}
</ul>

<div id="tag-jqcloud">
  {% include tagCloud.html %}
</div>
