---
layout: boxless
title: Download Qubes OS
permalink: /downloads/
redirect_from:
- /doc/releases/
- /en/doc/releases/
- /doc/QubesDownloads/
- /wiki/QubesDownloads/
---

<div class="white-box more-bottom page-content">
  {% assign release_name = site.data.downloads.featured_release %}
  {% assign release = site.data.downloads.releases[release_name] %}
  {% assign primary_source = release.sources|first %}

  <div class="row">
    <div class="col-lg-12 col-md-12">
      <h2>{{ release_name }}</h2>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-4 col-md-4">
      <h3>1. Download ISO Image</h3>

      <a class="btn btn-primary" href="{{ primary_source[1].url }}">
        <i class="fa fa-download"></i> Download Now <br>
        <small>{{ primary_source[0] }} ({{ primary_source[1].method }})</small>
      </a>

      {% for source in release.sources %}
      {% if source[0] == primary_source[0] %}{% continue %}{% endif %}
      <a class="btn btn-default" href="{{ source[1].url }}">
        <i class="fa fa-download"></i> Download Now {{source.count}} <br>
        <small>{{ source[0] }} ({{ source[1].method }}) </small>
      </a>
      {% endfor %}

      <ul class="more-top">
        {% for fdoc in release.featured_docs["get"] %}
        <li><a href="{{ release.docs[fdoc].url }}">{{ fdoc }}</a></li>
        {% endfor %}
        <li><a href="/doc/supported-versions/">Supported Qubes OS versions</a></li>
        <li><a href="/doc/version-scheme/">The Qubes OS version scheme</a></li>
        <li><a href="/doc/license/">Read the Qubes OS License</a></li>
      </ul>

    </div>
    <div class="col-lg-4 col-md-4">
      <h3>2. Verify Your Download</h3>
      <table class="step-options">
        <tr>
        <td><a class="btn btn-default" href="{{ primary_source[1].verifiers['hash'] }}">Hashes</a></td>
        <td><a class="btn btn-default" href="{{ primary_source[1].verifiers['sig'] }}">Signature</a></td>
        <td><a class="btn btn-default" href="{{ primary_source[1].verifiers['key'] }}"><i class="fa fa-key"></i> Get Signing Key</a></td>
        </tr>
      </table>
      <ul class="more-top">
        <li><a href="/doc/install-security/">Installation Security Considerations</a></li>
        <li><a href="/doc/verifying-signatures/">Learn To Verify Signatures</a></li>
      </ul>
    </div>

    <div class="col-lg-4 col-md-4">
      <h3>3. Install & Setup</h3>
      <table class="step-options">
        <tr>
        <td><a class="btn btn-primary" href="/doc/installation-guide/#burning-the-iso-onto-a-dvd-or-usb-stick">Create Bootable USB / DVD</a></td>
        </tr>
      </table>
      <ul class="more-top">
        <li><a href="/doc/system-requirements/">System Requirements</a></li>
        <li><a href="/hcl/">Hardware Compatibility List</a></li>
      </ul>
    </div>

  </div>
</div>

## Experimental and Older Releases

<div class="white-box more-bottom page-content">

  <div class="row">
    <div class="col-lg-12 col-md-12">
      {% for releasex in site.data.downloads.releases %}
      {% assign release_name = releasex[0] %}
      {% assign release = releasex[1] %}
      {% if release_name == site.data.downloads.featured_release %}{% continue %}{% endif %}
      {% assign aging = release.aging | default: false %}
      {% assign deprecated = release.deprecated | default: false %}
      {% assign testing = release.testing | default: false %}
      <h3>{{ release_name }}</h3>
      {% if aging %}
      <div class="alert alert-info" role="alert">
        <i class="fa fa-info-circle"></i>{% if aging != true %}{{ aging }}{% else %} This is an old, <a href="/doc/supported-versions/" class="alert-link">supported</a> release. For the best Qubes OS experience, we suggest upgrading to the latest stable release.{% endif %}
      </div>
      {% endif %}
      {% if deprecated %}
      <div class="alert alert-warning" role="alert">
        <i class="fa fa-exclamation-triangle"></i>{% if deprecated != true %}{{ deprecated }}{% else %} This is an old, <a href="/doc/supported-versions/" class="alert-link">unsupported</a> release. We strongly recommend upgrading to a supported release in order to receive the latest security updates.{% endif %}
      </div>
      {% endif %}
      {% if testing %}
      <div class="alert alert-info" role="alert">
        <i class="fa fa-info-circle"></i>{% if testing != true %}{{ testing }}{% else %} This is a testing release. We appreciate your desire to help us test Qubes. However, we recommend you use a <a href="/doc/supported-versions/" class="alert-link">current and supported release</a> for daily use.{% endif %}
      </div>
      {% endif %}
      <table class="table">
        <thead>
          <tr>
            <th>Download</th>
            <th>Verify
              <a class="fa fa-question-circle" href="/doc/verifying-signatures/"
                 title="How do I verify my download?"></a></th>
            <th>File</th>
            <th>Source</th>
          </tr>
        </thead>
        <tbody>
          {% for sourcedata in release.sources %}
          {% assign source_name = sourcedata[0] %}
          {% assign source = sourcedata[1] %}
          <tr>
            <td>
              <a class="btn btn-primary" href="{{ source.url }}">
                <i class="fa fa-download"></i> Download Now
              </a>
            </td>
            <td>
              {% for verifier in source.verifiers %}
                {% if verifier[0] == "hash" %}
                <a class="btn btn-default" href="{{ verifier[1] }}">Hash</a>
                {% elsif verifier[0] == "sig" %}
                <a class="btn btn-default" href="{{ verifier[1] }}">Signature</a>
                {% elsif verifier[0] == "key" %}
                <a class="btn btn-default" href="{{ verifier[1] }}"><i class="fa fa-key"></i> Get Signing Key</a>
                {% endif %}
              {% endfor %}
            </td>
            <td>
              <strong>{{ source.filename }}</strong><br>
              <em>{{ source.type }}</em>
            </td>
            <td>
              <a href="https://{{ source_name }}/">{{ source_name }}</a><br/>
              <em>{{ source.method }}</em>
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
        </li>
        {% endfor %}
      </ul>
      {% endfor %}

    </div>
  </div>
</div>
