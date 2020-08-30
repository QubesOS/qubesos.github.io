---
layout: default
title: Downloads
permalink: /downloads/
redirect_from:
- /doc/QubesDownloads/
- /wiki/QubesDownloads/
---

<div class="more-bottom page-content">
  <div class="row">
    <div class="col-lg-4">
      <h3>Choosing Your Hardware</h3>
      <ul class="list-unstyled">
        <li>
          <a href="/doc/system-requirements/">
            <i class="fa fa-server fa-fw black-icon"></i> System Requirements
          </a>
        </li>
        <li>
          <a href="/doc/certified-hardware/">
            <i class="fa fa-floppy-o fa-fw black-icon"></i> Certified Hardware
          </a>
        </li>
        <li>
          <a href="/hcl/">
            <i class="fa fa-laptop fa-fw black-icon"></i> Hardware Compatibility
              List
          </a>
        </li>
      </ul>
    </div>
    <div class="col-lg-4">
      <h3>Installing Qubes Securely</h3>
      <ul class="list-unstyled">
        <li>
          <a href="/doc/installation-guide/">
            <i class="fa fa-book fa-fw black-icon"></i> Installation Guide
          </a>
        </li>
        <li>
          <a href="/security/verifying-signatures/">
            <i class="fa fa-lock fa-fw black-icon"></i> How and Why to Verify
              Signatures
          </a>
        </li>
        <li>
          <a href="/doc/install-security/">
            <i class="fa fa-lightbulb-o fa-fw black-icon"></i> Installation
              Security Considerations
          </a>
        </li>
      </ul>
    </div>
    <div class="col-lg-4">
      <h3>Help and Support</h3>
      <ul class="list-unstyled">
        <li>
          <a href="/support/">
            <i class="fa fa-life-ring fa-fw black-icon"></i> Help and Support
          </a>
        </li>
        <li>
          <a href="/doc/#troubleshooting">
            <i class="fa fa-file-text-o fa-fw black-icon"></i> Troubleshooting
              Guides
          </a>
        </li>
        <li>
          <a href="/doc/reporting-bugs/">
            <i class="fa fa-bug fa-fw black-icon"></i> Report a Bug
          </a>
        </li>
      </ul>
    </div>
  </div>
  <hr class="more-bottom">
  <div class="row">
    <div class="col-lg-12">
      <h3>Qubes OS is made possible by your donations!</h3>
      <p>
        As a free and open-source software project, we rely on donations from
        users like you in order to keep running. Your contributions directly
        support the developers who work hard every day to improve your security.
        Please consider making a donation today.
      </p>
      <a class="btn btn-lg btn-primary" href="/donate/">Donate</a>
    </div>
  </div>
</div>
<div class="white-box more-bottom page-content">
  {% for releasex in site.data.downloads.releases %}
  <div class="row">
    <div class="col-lg-12">
      {% assign release_name = releasex[0] %}
      {% assign release = releasex[1] %}
      {% assign testing = release.testing | default: false %}
      {% assign latest = release.latest | default: false %}
      {% assign aging = release.aging | default: false %}
      {% assign deprecated = release.deprecated | default: false %}
      <h3 id="{{ release_name | slugify }}">
        {{ release_name }}
      </h3>
      {% if testing %}
      <div class="alert alert-info" role="alert">
        <i class="fa fa-question-circle"></i>
        {% if testing != true %}
          {{ testing }}
        {% else %}
          This is a <a href="/doc/testing/">testing release</a>. Please help us
          improve it by <a href="/doc/reporting-bugs/">reporting any bugs you
          encounter</a>. For important work, we recommend the latest stable
          release.
        {% endif %}
      </div>
      {% endif %}
      {% if latest %}
      <div class="alert alert-success" role="alert">
        <i class="fa fa-check-circle"></i>
        {% if latest != true %}
          {{ latest }}
        {% else %}
          This is the latest stable Qubes OS release. We recommend this release
          for all new and existing users.
        {% endif %}
      </div>
      {% endif %}
      {% if aging %}
      <div class="alert alert-warning" role="alert">
        <i class="fa fa-info-circle"></i>
        {% if aging != true %}
          {{ aging }}
        {% else %}
          This is an old, <a href="/doc/supported-versions/">supported</a>
          release. For the best Qubes OS experience, we suggest upgrading to the
          latest stable release.
        {% endif %}
      </div>
      {% endif %}
      {% if deprecated %}
      <div class="alert alert-danger" role="alert">
        <i class="fa fa-exclamation-circle"></i>
        {% if deprecated != true %}
          {{ deprecated }}
        {% else %}
          This is an old, <a href="/doc/supported-versions/">unsupported</a>
          release. We strongly recommend upgrading to a supported release in
          order to receive the latest security updates.
        {% endif %}
      </div>
      {% endif %}
    </div>
  </div>
  <div class="row download-content">
    {% for source in release.sources %}
    {% if source.display %}
    <div class="col-lg-4 add-bottom">
      <a class="btn btn-primary btn-block" href="{{ source.url }}"
         title="{{ release_name }} {{ source.type }}: {{ source.size }}">
        <i class="fa fa-fw fa-download"></i>
        <samp>{{ source.filename }}</samp>
      </a>
      {% for verifier in source.verifiers %}
        {% if verifier[0] == "hash" %}
        <a class="btn btn-default btn-block" href="{{ verifier[1] }}"
           title="Cryptographic hash values for {{ release_name }}">
          <i class="fa fa-fw fa-download"></i>Cryptographic hash values
        </a>
        {% elsif verifier[0] == "sig" %}
        <a class="btn btn-default btn-block" href="{{ verifier[1] }}"
           title="Detached PGP signature file for {{ release_name }}">
          <i class="fa fa-fw fa-download"></i>Detached PGP signature
        </a>
        {% elsif verifier[0] == "key" %}
        <a class="btn btn-default btn-block" href="{{ verifier[1] }}"
           title="PGP Release Signing Key for {{ release_name }}">
          <i class="fa fa-fw fa-download"></i>Qubes Release Signing Key
        </a>
        {% endif %}
      {% endfor %}
    </div>
    {% endif %}
    {% endfor %}
    <div class="col-lg-4">
      <ul class="list-unstyled">
        <li>
          <a href="#mirrors" title="View all download mirrors">
            <i class="fa fa-fw fa-cloud-download black-icon"></i>
            All Download Mirrors
          </a>
        </li>
        <li>
          <a href="/security/verifying-signatures/">
            <i class="fa fa-fw fa-question-circle black-icon"></i>
            How to Verify Downloads
          </a>
        </li>
        {% for docdata in release.docs %}
        {% assign doc_name = docdata[0] %}
        {% assign doc = docdata[1] %}
        {% if doc_name == "Installation Guide" %}
        <li>
          <a href="{{ doc.url }}">
            <i class="fa fa-fw fa-book black-icon"></i> {{ doc_name }}
          </a>
        </li>
        {% endif %}
        {% if doc_name == "Release Notes" %}
        <li>
          <a href="{{ doc.url }}">
            <i class="fa fa-fw fa-file-text-o black-icon"></i> {{ doc_name }}
          </a>
        </li>
        {% endif %}
        {% if doc_name == "Release Schedule" %}
        <li>
          <a href="{{ doc.url }}">
            <i class="fa fa-fw fa-calendar black-icon"></i> {{ doc_name }}
          </a>
        </li>
        {% endif %}
        {% endfor %}
        <li>
          <a href="Help and Support">
            <i class="fa fa-fw fa-life-ring black-icon"></i> Help and Support
          </a>
        </li>
        <li>
          <a href="/doc/source-code/">
            <i class="fa fa-fw fa-code black-icon"></i> Source Code
          </a>
        </li>
      </ul>
    </div>
  </div>
  <hr class="more-bottom">
  {% endfor %}
</div>
<div class="row">
  <div class="col-lg-12 col-md-12">
    <div class="more-bottom page-content">
      <article>
        <h3 id="mirrors">Download Mirrors</h3>
        <p>
          Listed in alphabetical order by geographic location.
        </p>
        <table>
          <tr>
            <th>Organization</th>
            <th>Location</th>
            <th>URL</th>
          </tr>
          {% for mirror in site.data.mirrors %}
          <tr id="{{ mirror.organization | slugify }}">
            <td>
              <a href="{{ mirror.org_url }}">{{ mirror.organization }}</a>
            </td>
            <td>
              {{ mirror.location }}
            </td>
            <td>
              {% for url in mirror.urls %}
              <a href="{{ url.url }}">{{ url.url | truncate: 76 }}</a><br>
              {% endfor %}
            </td>
          </tr>
          {% endfor %}
        </table>
        <a href="/downloads/mirrors/#instructions-for-mirror-operators">
          <i class="fa fa-cloud fa-fw black-icon"></i>
          How to contribute a download mirror
        </a>
      </article>
    </div>
  </div>
</div>
<div class="white-box more-bottom page-content">
  <div class="row">
    <div class="col-lg-4 col-md-4">
      <h3 id="versions">Security Information</h3>
      <ul class="list-unstyled">
        <li>
          <a href="/security/">
            <i class="fa fa-lock fa-fw black-icon"></i> Security Center
          </a>
        </li>
        <li>
          <a href="/security/pack/">
            <i class="fa fa-folder fa-fw black-icon"></i> Security Pack
          </a>
        </li>
        <li>
          <a href="/doc/security-guidelines/">
            <i class="fa fa-tasks fa-fw black-icon"></i> Security Guidelines
          </a>
        </li>
      </ul>
    </div>
    <div class="col-lg-4 col-md-4">
      <h3 id="versions">Version Information</h3>
      <ul class="list-unstyled">
        <li>
          <a href="/doc/supported-versions/">
            <i class="fa fa-history fa-fw black-icon"></i> Supported Versions
          </a>
        </li>
        <li>
          <a href="/doc/templates/">
            <i class="fa fa-clone fa-fw black-icon"></i> Templates
          </a>
        </li>
        <li>
          <a href="/doc/version-scheme/">
            <i class="fa fa-code-fork fa-fw black-icon"></i> Version Scheme
          </a>
        </li>
      </ul>
    </div>
    <div class="col-lg-4 col-md-4">
      <h3 id="source-code">Source Code</h3>
      <ul class="list-unstyled">
        <li>
          <a href="/doc/source-code/">
            <i class="fa fa-code fa-fw black-icon"></i> Source Code
          </a>
        </li>
        <li>
          <a href="/doc/coding-style/">
            <i class="fa fa-terminal fa-fw black-icon"></i> Coding Guidelines
          </a>
        </li>
        <li>
          <a href="/doc/license/">
            <i class="fa fa-file-text-o fa-fw black-icon"></i> Software License
          </a>
        </li>
      </ul>
    </div>
  </div>
</div>
