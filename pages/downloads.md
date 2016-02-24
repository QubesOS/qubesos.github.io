---
layout: downloads
title: Get Qubes OS
permalink: /downloads/
redirect_from:
- /doc/releases/
- /en/doc/releases/
- /doc/QubesDownloads/
- /wiki/QubesDownloads/
---

<div class="download-steps">

{% assign release_name = site.data.downloads.featured_release %}
{% assign release = site.data.downloads.releases[release_name] %}
{% assign primary_source = release.sources|first %}

<h1 class="more-top add-left">Get</h1>

<table class="step-options">
<tr>
  <td colspan="{{ release.sources|size - 1}}"><a class="btn btn-primary btn-lg" href="{{ primary_source[1].url }}">Download {{ release_name }}</a></td>
</tr>
<tr>
{% for source in release.sources %}
{% if source[0] == primary_source[0] %}{% continue %}{% endif %}
  <td><a class="btn btn-default" href="{{ source[1].url }}">Via {{ source[1].method }} from {{ source[0] }}</a></td>
{% endfor %}
</tr>
</table>

<p><a class="btn btn-default" href="#more-releases">See live, experimental and past releases</a></p>

<ul>
  {% for fdoc in release.featured_docs["get"] %}
  <li><a href="{{ release.docs[fdoc].url }}">{{ fdoc }}</a></li>
  {% endfor %}
  <li><a href="/doc/supported-versions/">Supported Qubes OS versions</a></li>
  <li><a href="/doc/version-scheme/">The Qubes OS version scheme</a></li>
  <li><a href="/doc/license/">Read the Qubes OS License</a></li>
</ul>


<h1 class="more-top add-left">Verify</h1>

<table class="step-options">
<tr>
  <td colspan="3"><a class="btn btn-primary btn-lg" href="/doc/verifying-signatures/">How to verify your Qubes OS is authentic</a></td>
</tr>
<tr>
  <td><a class="btn btn-default" href="{{ primary_source[1].verifiers['hash'] }}">Hashes</a></td>
  <td><a class="btn btn-default" href="{{ primary_source[1].verifiers['sig'] }}">Signature</a></td>
  <td><a class="btn btn-default" href="{{ primary_source[1].verifiers['key'] }}">Signer key</a></td>
</tr>
</table>


<ul>
  <li><a href="/doc/install-security/">Installation Security Considerations</a></li>
</ul>


<h1 class="more-top add-left">Deploy</h1>

<table class="step-options">
<tr>
  <td><a class="btn btn-primary btn-lg" href="/doc/installation-guide/#burning-the-iso-onto-a-dvd-or-usb-stick">How to deploy and boot Qubes OS</a></td>
</tr>
</table>

<ul>
  <li><a href="/doc/system-requirements/">System Requirements</a></li>
  <li><a href="/hcl/">Hardware Compatibility List</a></li>
</ul>


<h1 class="more-top add-left">Enjoy</h1>

<table class="step-options">
<tr>
  <td colspan="2"><a class="btn btn-primary btn-lg" href="/getting-started/#already-installed">Get started with Qubes OS</a></td>
</tr>
<tr>
  <td><a class="btn btn-default btn-lg" href="/help/">Get help</a></td>
  <td><a class="btn btn-default btn-lg" href="https://github.com/QubesOS">See the source</a></td>
</tr>
</table>


</div>

<div class="white-box more-bottom page-content">

<h1 id="more-releases">Live, experimental and older releases</h1>

{% for releasex in site.data.downloads.releases %}
{% assign release_name = releasex[0] %}
{% assign release = releasex[1] %}
{% assign deprecated = release.deprecated | default: false %}
{% assign testing = release.testing | default: false %}

<h2>{{ release_name }}</h2>

{% if deprecated %}<p>⚠ {% if deprecated != true %}{{ deprecated }}{% else %}This is an old release.  We strongly recommend you prefer <a href="/doc/supported-versions/">using a current and supported release</a>.{% endif %}</p>{% endif %}

{% if testing %}<p>⚠ {% if testing != true %}{{ testing }}{% else %}This is a testing release.  We appreciate your desire to help us with testing Qubes OS; that said, we recommend you use <a href="/doc/supported-versions/">a current and supported release</a> for your daily computing.{% endif %}</p>{% endif %}

<table class="table">
  <thead>
    <tr>
      <th>Source</th>
      <th>Download</th>
      <th><a href="/doc/verifying-signatures/"
             title="How to verify the authenticity of your download">Verifiers</a></th>
    </tr>
  </thead>
  <tbody>
    {% for sourcedata in release.sources %}
    {% assign source_name = sourcedata[0] %}
    {% assign source = sourcedata[1] %}
    <tr>
      <td><em><a href="https://{{ source_name }}/">{{ source_name }}</a></em><br/>{{ source.method }}</td>
      <td><a href="{{ source.url }}">{{ source.filename }}</a><br/>{{ source.type }}</td>
      <td>
        {% for verifier in source.verifiers %}
          <a class="btn btn-default" href="{{ verifier[1] }}">{{ verifier[0] }}</a>
        {% endfor %}
      </td>
    </tr>
    {% endfor %}
  </tbody>
</table>

<ul>
  {% for docdata in release.docs %}
  {% assign doc_name = docdata[0] %}
  {% assign doc = docdata[1] %}
  {% assign featured = doc.featured | default: "no" %}
  <li>
    <a href="{{ doc.url }}">{{ doc_name }}</a>
    {% if featured != "no" %} ☚{% endif %}
  </li>
  {% endfor %}
</ul>

<br/><!-- TODO: this is needed because of the shit 0-top big-bottom margin in the headings -->

{% endfor %}


<h2>Mirrors</h2>


<p>Qubes ISOs are available from the following mirrors:</p>

<ul>
  <li><a href="http://burnbit.com/search?q=qubes">Burnbit torrent</a></li>
  <li><a href="https://mirrors.kernel.org/qubes/iso/">mirrors.kernel.org</a></li>
</ul>


</div>
