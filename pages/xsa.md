---
lang: en
layout: doc
permalink: /security/xsa/
ref: 214
title: Xen security advisory (XSA) tracker
---

Qubes OS uses the [Xen
hypervisor](https://wiki.xenproject.org/wiki/Xen_Project_Software_Overview) as
part of its [architecture](/doc/architecture/). When the [Xen
Project](https://xenproject.org/) publicly discloses a vulnerability in the Xen
hypervisor, they issue a notice called a [Xen security advisory
(XSA)](https://xenproject.org/developers/security-policy/). Vulnerabilities in
the Xen hypervisor sometimes have security implications for Qubes OS. When they
do, we issue a notice called a [Qubes security bulletin (QSB)](/security/qsb/).
(QSBs are also issued for non-Xen vulnerabilities.) However, QSBs can provide
only *positive* confirmation that certain XSAs *do* affect the security of
Qubes OS. QSBs cannot provide *negative* confirmation that other XSAs do *not*
affect the security of Qubes OS. Therefore, we also maintain this XSA tracker,
which is a comprehensive list of all XSAs publicly disclosed to date, including
whether each one affects the security of Qubes OS. Shortly after a new XSA is
published, we will add a new row to this tracker. If that XSA affects the
security of Qubes OS, its row will also include a link to the associated [Qubes
security bulletin (QSB)](/security/qsb/).

Under the "Is Qubes Affected?" column, there are two possible values: **Yes**
or **No**.

* **Yes** means that the *security* of Qubes OS *is* affected.
* **No** means that the *security* of Qubes OS is *not* affected.

## Important notes

* For the purpose of this tracker, we do *not* classify mere [denial-of-service
  (DoS) attacks](https://en.wikipedia.org/wiki/Denial-of-service_attack) as
  affecting the *security* of Qubes OS. Therefore, if an XSA pertains *only* to
  DoS attacks against Qubes, the value in the "Is Qubes Affected?" column will
  be **No**.
* For simplicity, we use the present tense ("is affected") throughout this
  page, but this does **not** necessarily mean that up-to-date Qubes
  installations are *currently* affected by any particular XSA. In fact, it is
  extremely unlikely that any up-to-date Qubes installations are vulnerable to
  any XSAs on this page, since patches are almost always published concurrently
  with QSBs. Please read the QSB (if any) for each XSA for patching details.
* Embargoed XSAs are excluded from this tracker until they are publicly
  released, since the [Xen security
  policy](https://www.xenproject.org/security-policy.html) does not permit us
  to state whether Qubes is affected prior to the embargo date.
* Unused and withdrawn XSA numbers are included in the tracker for the sake of
  completeness, but they are excluded from the [statistics](#statistics)
  section for the sake of accuracy.
* All dates are in UTC.
