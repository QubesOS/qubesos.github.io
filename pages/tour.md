---
layout: default
title: Tour
permalink: /tour/
---

<div id="tour">
  <div class="row">
    <div class="col-lg-8 col-md-12 col-xs-12">
      <h2 class="add-bottom">Video Tour of Qubes</h2>
      <div id="player"></div>
      <p>Are you completely new to Qubes OS? We suggest watching the full 33 minute video to get an overview of how to better protect your privacy and make you more secure. Alternatively, you can also browse to specific chapter by using the menu on the right to learn about just that feature.</p>
      <p class="remove-bottom"><em>The video was made by a passionate community member. Thanks, <a href="http://mattwilson.org">Matthew Wilson</a>.</em></p>
    </div>
    <div class="col-lg-4 col-md-12 col-xs-12">
      <h2 class="add-bottom">&nbsp;</h2>
      <ul id="player-menu" class="list-unstyled remove-bottom">
        <li><a href="00:00" class="player-seek">An Overview of Qubes OS</a></li>
        <li><a href="01:47" class="player-seek">Web browsing with multiple identities</a></li>
        <li><a href="05:26" class="player-seek">Isolating files in different Qubes</a></li>
        <li><a href="07:28" class="player-seek">Moving files between Qubes</a></li>
        <li><a href="09:21" class="player-seek">Using the secure clipboard</a></li>
        <li><a href="11:13" class="player-seek">Web browsing securely in a Disposable Qube</a></li>
        <li><a href="13:51" class="player-seek">Handling untrusted files in a Disposable Qube</a></li>
        <li><a href="16:50" class="player-seek">Exploring the Qubes Manager</a></li>
        <li><a href="18:54" class="player-seek">Templates and App Qubes</a></li>
        <li><a href="20:04" class="player-seek">Installing temporary applications</a></li>
        <li><a href="21:57" class="player-seek">Installing persistent applications</a></li>
        <li><a href="24:20" class="player-seek">Managing the applications menu</a></li>
        <li><a href="25:09" class="player-seek">Creating & using a Standalone Qube</a></li>
        <li><a href="26:38" class="player-seek">Editing settings of a Qube</a></li>
        <li><a href="28:40" class="player-seek">Creating a Qube for added security & privacy</a></li>
        <li><a href="29:42" class="player-seek">Whonix and Tor for privacy & anonymity</a></li>
      </ul>
    </div>
  </div>
  <hr class="add-top more-bottom">
  <div class="row">
    <div class="col-lg-4 col-md-4 col-xs-12">
      <h2>Screenshots</h2>
      <p>See what using Qubes actually looks like with these screenshots of various applications running in Qubes.</p>
      <a href="/screenshots/" class="btn btn-primary">
        <i class="fa fa-picture-o"></i> See Screenshots
      </a>
    </div>
    <div class="col-lg-4 col-md-4 col-xs-12">
      <h2>Research</h2>
      <p>Are you a security researcher, computer scientist, or low-level hacker? Read the research papers of the Qubes team arrived at our radical approach to security and OS design.</p>
      <a href="/research/" class="btn btn-primary">
        <i class="fa fa-file-text"></i> Read Our Research
      </a>
    </div>
    <div class="col-lg-4 col-md-4 col-xs-12">
      <h2>Architecture</h2>
      <p>Interested in understanding the design principles governing Qubes? Start with an overview, then dive into the full architecture spec.</p>
      <a href="/doc/architecture/" class="btn btn-primary">
        <i class="fa fa-cubes"></i> Architecture Overview
      </a>
    </div>
  </div>
</div>
<hr class="more-top more-bottom">


What is Qubes OS?
-----------------

Qubes OS is a security-oriented operating system (OS). The OS is the software
that runs all the other programs on a computer. Some examples of popular
OSes are Microsoft Windows, Mac OS X, Android, and iOS. Qubes is free and
open-source software (FOSS). This means that everyone is free to use, copy,
and change the software in any way. It also means that the source code is
openly available so others can contribute to and audit it.


Why is OS security important?
-----------------------------

Most people use an operating system like Windows or OS X on their desktop
and laptop computers. These OSes are popular because they tend to be easy
to use and usually come pre-installed on the computers people buy. However,
they present problems when it comes to security. For example, you might
open an innocent-looking email attachment or website, not realizing that
you're actually allowing malware (malicious software) to run on your
computer. Depending on what kind of malware it is, it might do anything
from showing you unwanted advertisements to logging your keystrokes to
taking over your entire computer. This could jeopardize all the information
stored on or accessed by this computer, such as health records, confidential
communications, or thoughts written in a private journal. Malware can also
interfere with the activities you perform with your computer. For example,
if you use your computer to conduct financial transactions, the malware
might allow its creator to make fraudulent transactions in your name.


Aren't antivirus programs and firewalls enough?
-----------------------------------------------

Unfortunately, conventional security approaches like antivirus programs
and (software and/or hardware) firewalls are no longer enough to keep out
sophisticated attackers. For example, nowadays it's common for malware
creators to check to see if their malware is recognized by any popular
antivirus programs. If it's recognized, they scramble their code until it's
no longer recognizable by the antivirus programs, then send it out. The
best antivirus programs will subsequently get updated once the antivirus
programmers discover the new threat, but this usually occurs at least a
few days after the new attacks start to appear in the wild. By then, it's
typically too late for those who have already been compromised. In addition,
bugs are inevitably discovered in the common software we all use (such as
our web browsers), and no antivirus program or firewall can prevent all of
these bugs from being exploited.


How does Qubes OS provide security?
-----------------------------------

Qubes takes an approach called **security by compartmentalization**, which
allows you to compartmentalize the various parts of your digital life into
securely isolated compartments called *qubes*.

This approach allows you to keep the different things you do on your computer
securely separated from each other in isolated qubes so that one qube getting
compromised won't affect the others. For example, you might have one qube for
visiting untrusted websites and a different qube for doing online banking. This
way, if your untrusted browsing qube gets compromised by a malware-laden
website, your online banking activities won't be at risk. Similarly, if
you're concerned about malicious email attachments, Qubes can make it so
that every attachment gets opened in its own single-use [disposable
qube]. In this way, Qubes allows you to do everything on the same physical
computer without having to worry about a single successful cyberattack taking
down your entire digital life in one fell swoop.

Moreover, all of these isolated qubes are integrated into a single, usable
system. Programs are isolated in their own separate qubes, but all windows are
displayed in a single, unified desktop environment with [unforgeable colored
window borders][getting started] so that you can easily identify windows from
different security levels. Common attack vectors like network cards and USB
controllers are isolated in their own hardware qubes while their functionality
is preserved through secure [networking], [firewalls], and [USB device
management][USB]. Integrated [file] and [clipboard] copy and paste operations
make it easy to work across various qubes without compromising security. The
innovative [Template] system separates software installation from software use,
allowing qubes to share a root filesystem without sacrificing security (and
saving disk space, to boot). Qubes even allows you to sanitize PDFs and images
in a few clicks. Users concerned about privacy will appreciate the
[integration][Qubes-Whonix] of [Whonix] with Qubes, which makes it easy to use
[Tor] securely, while those concerned about physical hardware attacks will
benefit from [Anti Evil Maid].


How does Qubes OS compare to using a "live CD" OS?
--------------------------------------------------

Booting your computer from a live CD (or DVD) when you need to perform
sensitive activities can certainly be more secure than simply using your main
OS, but this method still preserves many of the risks of conventional OSes. For
example, popular live OSes (such as [Tails] and other Linux distributions)
are still **monolithic** in the sense that all software is still running in
the same OS. This means, once again, that if your session is compromised,
then all the data and activities performed within that same session are also
potentially compromised.


How does Qubes OS compare to running VMs in a conventional OS?
--------------------------------------------------------------

Not all virtual machine software is equal when it comes to security. You may
have used or heard of VMs in relation to software like VirtualBox or VMware
Workstation. These are known as "Type 2" or "hosted" hypervisors. (The
**hypervisor** is the software, firmware, or hardware that creates and
runs virtual machines.) These programs are popular because they're designed
primarily to be easy to use and run under popular OSes like Windows (which
is called the **host** OS, since it "hosts" the VMs). However, the fact
that Type 2 hypervisors run under the host OS means that they're really
only as secure as the host OS itself. If the host OS is ever compromised,
then any VMs it hosts are also effectively compromised.

By contrast, Qubes uses a "Type 1" or "bare metal" hypervisor called
[Xen]. Instead of running inside an OS, Type 1 hypervisors run directly on the
"bare metal" of the hardware. This means that an attacker must be capable of
subverting the hypervisor itself in order to compromise the entire system,
which is vastly more difficult.

Qubes makes it so that multiple VMs running under a Type 1 hypervisor can be
securely used as an integrated OS. For example, it puts all of your application
windows on the same desktop with special colored borders indicating the
trust levels of their respective VMs. It also allows for things like secure
copy/paste operations between VMs, securely copying and transferring files
between VMs, and secure networking between VMs and the Internet.


How does Qubes OS compare to using a separate physical machine?
---------------------------------------------------------------

Using a separate physical computer for sensitive activities can certainly be
more secure than using one computer with a conventional OS for everything,
but there are still risks to consider. Briefly, here are some of the main
pros and cons of this approach relative to Qubes:

<div class="focus">
  <i class="fa fa-check"></i> <strong>Pros</strong>
</div>

 * Physical separation doesn't rely on a hypervisor. (It's very unlikely
   that an attacker will break out of Qubes' hypervisor, but if one were to
   manage to do so, one could potentially gain control over the entire system.)
 * Physical separation can be a natural complement to physical security. (For
   example, you might find it natural to lock your secure laptop in a safe
   when you take your unsecure laptop out with you.)

<div class="focus">
    <i class="fa fa-times"></i> <strong>Cons</strong>
</div>

 * Physical separation can be cumbersome and expensive, since we may have to
   obtain and set up a separate physical machine for each security level we
   need.
 * There's generally no secure way to transfer data between physically
   separate computers running conventional OSes. (Qubes has a secure inter-VM
   file transfer system to handle this.)
 * Physically separate computers running conventional OSes are still
   independently vulnerable to most conventional attacks due to their monolithic
   nature.
 * Malware which can bridge air gaps has existed for several years now and
   is becoming increasingly common.

(For more on this topic, please see the paper
[Software compartmentalization vs. physical separation][paper-compart].)


More information
----------------

This page is just a brief sketch of what Qubes is all about, and many
technical details have been omitted here for the sake of presentation.

 * If you're a current or potential Qubes user, you may want to check out the
   [documentation][doc] and the [FAQ][user-faq].
 * If you're a developer, there's dedicated [documentation][system-doc]
   and an [FAQ][devel-faq] just for you.
 * Ready to give Qubes a try? Head on over to the [downloads] page.
 * Once you've installed Qubes, here's a guide on [getting started].


[disposable qube]: /doc/dispvm/
[networking]: /doc/networking/
[firewalls]: /doc/qubes-firewall/
[USB]: /doc/usb/
[file]: /doc/copying-files/
[clipboard]: /doc/copy-paste/
[Template]: /doc/templates/
[Qubes-Whonix]: /doc/whonix/
[Whonix]: https://www.whonix.org/
[Tor]: https://torproject.org/
[Anti Evil Maid]: /doc/anti-evil-maid/
[Tails]: https://tails.boum.org/
[Xen]: http://www.xenproject.org
[paper-compart]: http://www.invisiblethingslab.com/resources/2014/Software_compartmentalization_vs_physical_separation.pdf
[doc]: /doc/
[user-faq]: /doc/user-faq/
[system-doc]: /doc/system-doc/
[devel-faq]: /doc/devel-faq/
[downloads]: /downloads/
[getting started]: /getting-started/

