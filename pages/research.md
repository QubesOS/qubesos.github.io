---
layout: default
title: Research
permalink: /research/
redirect_from:
- /doc/qubes-research/
- /en/doc/qubes-research/
- /doc/QubesResearch/
- /wiki/QubesResearch/
---

{% for research in site.data.research %}
  <li class="list-links">
    <a class="black-link" href="{{research.url}}">
      {{research.title}}
        <span class="detail"><strong>{{research.author}}</strong>, {{research.date}}</span>
    </a>
  </li>
{% endfor %}
