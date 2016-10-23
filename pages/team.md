---
layout: boxless
title: Team
permalink: /team/
redirect_from:
- /people/
- /doc/QubesDevelopers/
- /wiki/QubesDevelopers/
---
<div id="pre-contact" class="white-box page-content more-bottom">
  <div class="row team">
    <div class="col-lg-2 col-md-2"></div>
    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
      <ul class="list-unstyled">
        <li><a href="/security/"><i class="fa fa-lock fa-fw black-icon"></i> Report a security issue</a></li>
        <li><a href="/doc/reporting-bugs/"><i class="fa fa-bug fa-fw black-icon"></i> Report a bug</a></li>
        <li><a href="/mailing-lists/"><i class="fa fa-envelope fa-fw black-icon"></i> Join the mailing lists</a></li>
        <li><a href="/join/"><i class="fa fa-user-plus fa-fw black-icon"></i> Join the team</a></li>
      </ul>
    </div>
    <div id="pre-contact" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
      <ul class="list-unstyled">
        <li><i class="fa fa-newspaper-o fa-fw"></i> Press inquiries: <a href="mailto:press@qubes-os.org">press@qubes-os.org</a></li>
        <li><i class="fa fa-briefcase fa-fw"></i> Business inquiries: <a href="mailto:business@qubes-os.org">business@qubes-os.org</a></li>
        <li><a href="/join/"><i class="fa fa-globe fa-fw black-icon"></i> Become a Qubes partner</a></li>
        <li><a href="/join/"><i class="fa fa-laptop fa-fw black-icon"></i> Request hardware certification</a></li>
      </ul>
    </div>
  </div>
</div>
<div id="team-core" class="white-box page-content more-bottom">
  <div class="col-lg-12 col-md-12 col-sm-12">
    <h2 class="text-center more-bottom">Core Team</h2>
  </div>
  {% assign core_count = 0 %}
  {% assign maintainers_count = 0 %}
  {% assign emeritus_count = 0 %}
  {% for team in site.data.team %}
  {% if team.type == "core" %}
  {% assign core_count = core_count | plus:1 %}
  <div class="row team team-core">
    <div class="col-lg-2 col-md-2 col-sm-5 col-xs-12 text-center">
    <div class="picture more-bottom">
      {% if team.picture %}
      <img src="/attachment/site/{{team.picture}}" title="Picture of {{team.name}}">
      {% else %}
      <i class="fa fa-user"></i>
      {% endif %}
    </div>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-7 col-xs-12">
      {% assign name_array = team.name | split:" " %}
      <h4 class="half-bottom">{{team.name}}</h4>
      <em class="role half-bottom">{{team.role}}</em>
      {% if team.email %}
      <a href="mailto:{{team.email}}" class="add-right"><i class="fa fa-envelope"></i> Email</a>
      {% endif %}
      {% if team.website %}
      <a href="{{team.website}}" class="add-right" target="blank"><i class="fa fa-link"></i> Website</a>
      {% endif %}
      {% if team.twitter %}
      <a href="https://twitter.com/{{team.twitter}}" target="blank"><i class="fa fa-twitter"></i> Twitter</a>
      {% endif %}
    </div>
    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12 text-center">
      {% if team.fingerprint %}
      <span class="fingerprint" title="{{team.name}}'s PGP Encryption Key Fingerprint">{{team.fingerprint}}</span>
      {% endif %}
      {% if team.pgp_key %}
      <a href="{{team.pgp_key}}"><i class="fa fa-key"></i> Get {{name_array[0]}}'s PGP Encryption Key</a>
      {% endif %}
    </div>
  </div>
  {% endif %}
  {% endfor %}
  <div class="text-center more-bottom">
    <a href="/join/" class="btn btn-primary"><i class="fa fa-user-plus fa-fw white-icon"></i> Join the team!</a>
  </div>
</div>
<div class="white-box page-content more-bottom">
  <div class="col-lg-12 col-md-12 col-sm-12">
    <h2 class="text-center more-bottom">Emeritus</h2>
    <p>Emeriti are honorary members of the Qubes team who previously
    contributed to the project in a central way but who are no longer
    currently active.</p>
  </div>
  <div class="row team">
    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
      {% for team in site.data.team %}
      {% if team.type == "emeritus" %}
      {% assign emeritus_count = emeritus_count | plus:1 %}
      {% include team-simple.html %}
      {% endif %}
      {% endfor %}
    </div>
  </div>
</div>
<div class="white-box page-content more-bottom">
  <div class="col-lg-12 col-md-12 col-sm-12">
    <h2 class="text-center more-bottom">Community Contributors</h2>
    <p>Qubes would not be where it is today without the input of the many users,
    testers, and developers of all skill levels who have come together to form
    this thriving community. The community's discussions take place primarily on
    the <a href="/doc/mailing-lists/">Qubes mailing lists</a>.</p>
  </div>
  {% assign non_community_count =  core_count | plus:maintainers_count | plus:emeritus_count %}
  {% assign community_count =  site.data.team | size | minus:non_community_count %}
  {% assign community_half = community_count | divided_by:2 | plus:1 %}
  {% assign community_shown =  0 %}
  <div class="row team">
    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
      {% for team in site.data.team %}
      {% if team.type == "community" %}
      {% if community_shown < community_half %}
      {% include team-simple.html %}
      {% elsif community_shown == community_half %}
      </div>
      <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
      {% include team-simple.html %}
      {% else %}
      {% include team-simple.html %}
      {% endif %}
      {% assign community_shown = community_shown | plus:1 %}
      {% endif %}
      {% endfor %}
    </div>
  </div>
</div>

