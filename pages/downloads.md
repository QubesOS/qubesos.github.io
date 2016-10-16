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
  <div class="row">
    <div class="col-lg-4 col-md-4">
      <h3>Choosing Your Hardware</h3>
      <ul class="more-top">
        <li><a href="/doc/system-requirements/">System Requirements</a></li>
        <li><a href="/hcl/">Hardware Compatibility List</a></li>
        <li><a href="/doc/certified-laptops">Qubes-Certified Laptops</a></li>
      </ul>
    </div>
    <div class="col-lg-4 col-md-4">
      <h3>Installing Qubes Securely</h3>
      <ul class="more-top">
        <li><a href="/doc/installation-guide/">Installation Guide</a></li>
        <li><a href="/doc/verifying-signatures/">How and Why to Verify Signatures</a></li>
        <li><a href="/doc/install-security/">Installation Security Considerations</a></li>
      </ul>
    </div>
    <div class="col-lg-4 col-md-4">
      <h3>Qubes Versions & License</h3>
      <ul class="more-top">
        <li><a href="/doc/supported-versions/">Supported Qubes OS Versions</a></li>
        <li><a href="/doc/version-scheme/">Qubes OS Version Scheme</a></li>
        <li><a href="/doc/license/">Qubes OS Software License</a></li>
      </ul>
    </div>
  </div>
</div>
<div class="white-box more-bottom page-content">
  <div class="row">
    <div class="col-lg-12 col-md-12">
      {% for releasex in site.data.downloads.releases %}
      {% assign release_name = releasex[0] %}
      {% assign release = releasex[1] %}
      {% assign testing = release.testing | default: false %}
      {% assign latest = release.latest | default: false %}
      {% assign aging = release.aging | default: false %}
      {% assign deprecated = release.deprecated | default: false %}
      <h3 class="more-bottom" id="{{ release.link }}">{{ release_name }}</h3>
      {% if testing %}
      <div class="alert alert-info" role="alert">
        <i class="fa fa-question-circle"></i>{% if testing != true %} {{ testing }}{% else %} This is a testing release. We appreciate your desire to help us test Qubes. However, we recommend you use a <a href="/doc/supported-versions/" class="alert-link">current and supported release</a> for daily use.{% endif %}
      </div>
      {% endif %}
      {% if latest %}
      <div class="alert alert-success" role="alert">
        <i class="fa fa-check-circle"></i>{% if latest != true %} {{ latest }}{% else %} This is the latest stable Qubes OS release. We recommend this release for all new and existing users.{% endif %}
      </div>
      {% endif %}
      {% if aging %}
      <div class="alert alert-warning" role="alert">
        <i class="fa fa-info-circle"></i>{% if aging != true %} {{ aging }}{% else %} This is an old, <a href="/doc/supported-versions/" class="alert-link">supported</a> release. For the best Qubes OS experience, we suggest upgrading to the latest stable release.{% endif %}
      </div>
      {% endif %}
      {% if deprecated %}
      <div class="alert alert-danger" role="alert">
        <i class="fa fa-exclamation-circle"></i>{% if deprecated != true %} {{ deprecated }}{% else %} This is an old, <a href="/doc/supported-versions/" class="alert-link">unsupported</a> release. We strongly recommend upgrading to a supported release in order to receive the latest security updates.{% endif %}
      </div>
      {% endif %}
      <table class="table">
        <thead>
          <tr>
            <th>Type</th>
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
              <strong>{{ source.type }}</strong>
            </td>
            <td>
              <a class="btn btn-primary" href="{{ source.url }}">
                <i class="fa fa-download"></i> Download
              </a>
            </td>
            <td>
              {% for verifier in source.verifiers %}
                {% if verifier[0] == "hash" %}
                <a title="MD5, SHA-128, SHA-256, and SHA-512 hash values" class="btn btn-default" href="{{ verifier[1] }}">Digests</a>
                {% elsif verifier[0] == "sig" %}
                <a title="Detached PGP signature file" class="btn btn-default" href="{{ verifier[1] }}">Signature</a>
                {% elsif verifier[0] == "key" %}
                <a title="PGP Release Signing Key" class="btn btn-default" href="{{ verifier[1] }}">PGP Key</a>
                {% endif %}
              {% endfor %}
            </td>
            <td>
              <code>{{ source.filename }}</code><br>
              <strong>Size:</strong> {{ source.size }}
            </td>
            <td>
              <a href="https://{{ source_name }}/">{{ source_name }}</a><br/>
              <strong>Method:</strong> {{ source.method }}
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
      <hr class="more-top more-bottom">
      {% endfor %}
    </div>
  </div>
</div>
