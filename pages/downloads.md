---
layout: boxless
title: Download Qubes OS
permalink: /downloads/
redirect_from:
- /doc/QubesDownloads/
- /wiki/QubesDownloads/
---

<div class="white-box more-bottom page-content">
  <div class="row">
    <div class="col-lg-4 col-md-4">
      <h3>Choosing Your Hardware</h3>
      <ul class="list-unstyled">
        <li><a href="/doc/system-requirements/"><i class="fa fa-server fa-fw black-icon"></i> System Requirements</a></li>
        <li><a href="/doc/hardware/"><i class="fa fa-floppy-o fa-fw black-icon"></i> General Hardware Information</a></li>
        <li><a href="/hcl/"><i class="fa fa-laptop fa-fw black-icon"></i> Hardware Compatibility List</a></li>
      </ul>
    </div>
    <div class="col-lg-4 col-md-4">
      <h3>Installing Qubes Securely</h3>
      <ul class="list-unstyled">
        <li><a href="/doc/installation-guide/"><i class="fa fa-book fa-fw black-icon"></i> Installation Guide</a></li>
        <li><a href="/security/verifying-signatures/"><i class="fa fa-lock fa-fw black-icon"></i> How and Why to Verify Signatures</a></li>
        <li><a href="/doc/install-security/"><i class="fa fa-lightbulb-o fa-fw black-icon"></i> Installation Security Considerations</a></li>
      </ul>
    </div>
    <div class="col-lg-4 col-md-4">
      <h3>Help and Support</h3>
      <ul class="list-unstyled">
        <li><a href="/support/"><i class="fa fa-life-ring fa-fw black-icon"></i> Help and Support</a></li>
        <li><a href="/doc/#troubleshooting"><i class="fa fa-file-text-o fa-fw black-icon"></i> Troubleshooting Guides</a></li>
        <li><a href="/doc/reporting-bugs/"><i class="fa fa-bug fa-fw black-icon"></i> Report a Bug</a></li>
      </ul>
    </div>
  </div>
  <hr class="more-bottom">
  <div class="row">
    <div class="col-lg-12 col-md-12">
      <h3>Qubes OS is made possible by your donations!</h3>
      <p>As a free and open-source software project, we rely on donations from users like you in order to keep running.
      Your contributions directly support the developers who work hard every day to improve your security.
      Please consider making a donation today.</p>
      <a class="btn btn-lg btn-primary" href="/donate/">Donate</a>
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
      <h3 class="more-bottom" id="{{ release_name | slugify }}">{{ release_name }}</h3>
      {% if testing %}
      <div class="alert alert-info" role="alert">
        <i class="fa fa-question-circle"></i>{% if testing != true %} {{ testing }}{% else %} This is a <a href="/doc/testing/">testing release</a>. Please help us improve it by <a href="/doc/reporting-bugs/">reporting any bugs you encounter</a>. For important work, we recommend the latest stable release.{% endif %}
      </div>
      {% endif %}
      {% if latest %}
      <div class="alert alert-success" role="alert">
        <i class="fa fa-check-circle"></i>{% if latest != true %} {{ latest }}{% else %} This is the latest stable Qubes OS release. We recommend this release for all new and existing users.{% endif %}
      </div>
      {% endif %}
      {% if aging %}
      <div class="alert alert-warning" role="alert">
        <i class="fa fa-info-circle"></i>{% if aging != true %} {{ aging }}{% else %} This is an old, <a href="/doc/supported-versions/">supported</a> release. For the best Qubes OS experience, we suggest upgrading to the latest stable release.{% endif %}
      </div>
      {% endif %}
      {% if deprecated %}
      <div class="alert alert-danger" role="alert">
        <i class="fa fa-exclamation-circle"></i>{% if deprecated != true %} {{ deprecated }}{% else %} This is an old, <a href="/doc/supported-versions/">unsupported</a> release. We strongly recommend upgrading to a supported release in order to receive the latest security updates.{% endif %}
      </div>
      {% endif %}
      <table class="table">
        <thead>
          <tr>
            <th>Download</th>
            <th>Verify
              <a class="fa fa-question-circle" href="/security/verifying-signatures/"
                 title="How do I verify my download?"></a></th>
            <th>File</th>
            <th>Size</th>
            <th>Source <a class="pull-right" href="#mirrors" title="View all download mirrors"><i class="fa fa-cloud-download"></i> All Mirrors</a></th>
          </tr>
        </thead>
        <tbody>
          {% for source in release.sources %}
            {% if source.display %}
            <tr>
              <td>
                <a class="btn btn-primary btn-block" href="{{ source.url }}">
                  <i class="fa fa-download"></i> {{ source.type }}
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
                <small><samp>{{ source.filename }}</samp></small>
              </td>
              <td>
                <small><samp>{{ source.size }}</samp></small>
              </td>
              <td>
                <div class="d-inline">
                  <a href="https://www.{{ source.name }}/">
                    {% if source.name == "kernel.org" %}
                    <i class="fa fa-linux fa-fw black-icon"></i>
                    {% elsif source.name == "qubes-os.org" %}
                    <i class="fa fa-cubes fa-fw black-icon"></i>
                    {% else %}
                    <i class="fa fa-cloud-download fa-fw black-icon"></i>
                    {% endif %}
                    <samp>{{ source.name }}</samp>
                  </a>
                </div>
              </td>
            </tr>
            {% endif %}
          {% endfor %}
        </tbody>
      </table>
        {% for docdata in release.docs %}
        {% assign doc_name = docdata[0] %}
        {% assign doc = docdata[1] %}
          {% if doc_name == "Installation Guide" %}
            <a class="btn btn-link" href="{{ doc.url }}"><i class="fa fa-book black-icon"></i> {{ doc_name }}</a>
          {% endif %}
          {% if doc_name == "Release Notes" %}
            <a class="btn btn-link" href="{{ doc.url }}"><i class="fa fa-file-text-o black-icon"></i> {{ doc_name }}</a>
          {% endif %}
          {% if doc_name == "Release Schedule" %}
            <a class="btn btn-link" href="{{ doc.url }}"><i class="fa fa-calendar black-icon"></i> {{ doc_name }}</a>
          {% endif %}
          {% if doc_name contains "Upgrading" %}
            <a class="btn btn-link" href="{{ doc.url }}"><i class="fa fa-arrow-circle-up black-icon"></i> {{ doc_name }}</a>
          {% endif %}
        {% endfor %}
          <a class="btn btn-link" href="#versions"><i class="fa fa-history black-icon"></i> Version Information</a>
          <a class="btn btn-link" href="#source-code"><i class="fa fa-code black-icon"></i> Source Code</a>
      <hr class="more-top more-bottom">
      {% endfor %}
    </div>
  </div>
</div>
<div class="row">
  <div class="col-lg-4 col-md-4">
    <div class="white-box more-bottom page-content">
      <h3 id="mirrors">Download Mirrors</h3>
      <ul class="list-unstyled">
        <li><a href="https://mirrors.edge.kernel.org/qubes/iso/"><i class="fa fa-cloud-download fa-fw black-icon"></i> mirrors.edge.kernel.org</a></li>
        <li><a href="http://ftp.halifax.rwth-aachen.de/qubes/iso/"><i class="fa fa-cloud-download fa-fw black-icon"></i> ftp.halifax.rwth-aachen.de</a></li>
        <li><a href="https://mirrors.dotsrc.org/qubes/"><i class="fa fa-cloud-download fa-fw black-icon"></i> mirrors.dotsrc.org</a></li>
        <li><a href="https://mirrors.ukfast.co.uk/sites/qubes-os.org/"><i class="fa fa-cloud-download fa-fw black-icon"></i> ukfast.co.uk</a></li>
        <li><a href="https://mirror.hackingand.coffee/qubes/"><i class="fa fa-cloud-download fa-fw black-icon"></i> hackingand.coffee</a></li>
        <li><a href="https://ftp.acc.umu.se/mirror/qubes-os.org/"><i class="fa fa-cloud-download fa-fw black-icon"></i> ftp.acc.umu.se</a></li>
        <li><a href="http://mirror.linux.pizza/qubes-os.org/"><i class="fa fa-cloud-download fa-fw black-icon"></i> mirror.linux.pizza</a></li>
        <li><a href="https://mirror.cryptoworld.is/qubes/"><i class="fa fa-cloud-download fa-fw black-icon"></i> mirror.cryptoworld.is</a></li>
        <li><a href="https://mirrors.gigenet.com/qubes/"><i class="fa fa-cloud-download fa-fw black-icon"></i> mirrors.gigenet.com</a></li>
        <li><a href="https://quantum-mirror.hu/mirrors/pub/qubes"><i class="fa fa-cloud-download fa-fw black-icon"></i> quantum-mirror.hu</a></li>
        <li><a href="https://ftp.cc.uoc.gr/mirrors/linux/qubes/"><i class="fa fa-cloud-download fa-fw black-icon"></i> ftp.cc.uoc.gr</a></li>
        <li><a href="http://ftp.icm.edu.pl/pub/os/qubes/"><i class="fa fa-cloud-download fa-fw black-icon"></i> ftp.icm.edu.pl</a></li>
        <li><a href="http://lxpizzamm6twgep2.onion/"><i class="fa fa-cloud-download fa-fw black-icon"></i> lxpizzamm6twgep2.onion</a></li>
        <li><a href="https://archive.org/download/QubesOS"><i class="fa fa-cloud-download fa-fw black-icon"></i> archive.org</a></li>
        <li><a href="https://ftp.qubes-os.org/iso/"><i class="fa fa-cloud-download fa-fw black-icon"></i> ftp.qubes-os.org</a></li>
        <li><a href="http://ftp.qubesos4rrrrz6n4.onion/iso/"><i class="fa fa-cloud-download fa-fw black-icon"></i> ftp.qubesos4rrrrz6n4.onion</a></li>
        <li><a href="http://ftp.sik5nlgfc5qylnnsr57qrbm64zbdx6t4lreyhpon3ychmxmiem7tioad.onion/iso/"><i class="fa fa-cloud-download fa-fw black-icon"></i> ftp.sik5nlgf...em7tioad.onion</a></li>
        <li><a href="/downloads/mirrors/#instructions-for-mirror-operators"><i class="fa fa-cloud fa-fw black-icon"></i> Contribute a mirror!</a></li>
      </ul>
    </div>
  </div>
  <div class="col-lg-4 col-md-4">
    <div class="white-box more-bottom page-content">
      <h3 id="versions">Version Information</h3>
      <ul class="list-unstyled">
        <li><a href="/doc/supported-versions/"><i class="fa fa-history fa-fw black-icon"></i> Supported Versions</a></li>
        <li><a href="/doc/version-scheme/"><i class="fa fa-code-fork fa-fw black-icon"></i> Version Scheme</a></li>
        <li><a href="/doc/templates/"><i class="fa fa-clone fa-fw black-icon"></i> Templates</a></li>
        <li><a href="/doc/system-requirements/"><i class="fa fa-server fa-fw black-icon"></i> System Requirements</a></li>
        <li><a href="/security/"><i class="fa fa-lock fa-fw black-icon"></i> Security Information</a></li>
      </ul>
    </div>
  </div>
  <div class="col-lg-4 col-md-4">
    <div class="white-box more-bottom page-content">
      <h3 id="source-code">Source Code</h3>
      <ul class="list-unstyled">
        <li><a href="/doc/source-code/"><i class="fa fa-code fa-fw black-icon"></i> Source Code</a></li>
        <li><a href="/doc/license/"><i class="fa fa-file-text-o fa-fw black-icon"></i> Software License</a></li>
        <li><a href="/doc/coding-style/"><i class="fa fa-terminal fa-fw black-icon"></i> Coding Guidelines</a></li>
        <li><a href="/doc/#developer-documentation"><i class="fa fa-book fa-fw black-icon"></i> Developer Documentation</a></li>
        <li><a href="/doc/architecture/"><i class="fa fa-cubes fa-fw black-icon"></i> OS Architecture</a></li>
      </ul>
    </div>
  </div>
</div>
