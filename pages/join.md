---
layout: default
title: Join
permalink: /join/
---

Join the Qubes OS Team!
=======================

The Qubes OS Project is currently seeking individuals for the following
positions:

Debian template maintainer
--------------------------

### General tasks ###

 * Working on proper packaging of Qubes-specific components for Debian
   * https://github.com/QubesOS/qubes-issues/issues/1567
   * https://github.com/QubesOS/qubes-issues/issues/1416
 * Debugging Debian specific issues (Debian template configuration,
   Qubes-specific code)
   * https://github.com/QubesOS/qubes-issues/issues/1514
   * https://github.com/QubesOS/qubes-issues/issues/1438
 * Testing and handling user feedback

See [some of the issues related to this role](https://github.com/QubesOS/qubes-issues/issues?q=is%3Aopen+is%3Aissue+label%3A%22C%3A+Debian%22).

Stable release manager
----------------------

### General tasks ###

 * Deciding what will be fixed in each stable release and what will be fixed
   only in new major releases
 * Backporting fixes to stable releases (and requesting core dev input when it
   isn't trivial)
 * Releasing packages for stable release (deciding when the package should be
   released to the `current-testing` repository and when it should be moved to
   the `current` repository)

Core developer
--------------

### General tasks ###

 * Actual debugging of issues
 * Writing new features
 * Writing tests
 * Writing developer documentation (API, etc)
 * Providing input for community contributors when requested

### Required and optional skills ###

 * Python
 * Shell scripting
 * System configuration (basic services, startup scripts etc)
 * Git, make
 * (Optional) networking, firewalling
 * (Optional) X11 protocol (raw)
 * (Optional) GUI frameworks (Gtk, Qt)
 * (Optional) kernel and/or hypervisor debugging skills
 * (Optional) low level stuff (UEFI, PCI communication,
   including IOMMU, networking down to ethernet layer, Xen
   backend/frontend interfaces)
 * (Optional) libvirt internals
 * (Optional) salt stack
 * (Optional) advanced desktop environment configuration, including
   writing plugins (KDE, Gnome)

The more "optional" the better :)

### Example features for implementation ###

#### Smaller ####

 * https://github.com/QubesOS/qubes-issues/issues/1499
 * https://github.com/QubesOS/qubes-issues/issues/1454
 * https://github.com/QubesOS/qubes-issues/issues/1363
 * https://github.com/QubesOS/qubes-issues/issues/1329
 * https://github.com/QubesOS/qubes-issues/issues/979

#### Larger ####

 * https://github.com/QubesOS/qubes-issues/issues/1455
 * https://github.com/QubesOS/qubes-issues/issues/1426
 * https://github.com/QubesOS/qubes-issues/issues/971
 * https://github.com/QubesOS/qubes-issues/issues/889
 * https://github.com/QubesOS/qubes-issues/issues/866
 * https://github.com/QubesOS/qubes-issues/issues/830

Qubes Live USB Maintainer
-------------------------

### Required Skills ###

 * Shell
 * Python
 * Bootloaders (`grub2`, `isolinux`)
 * `initrd` creation (`dracut`)
 * Kickstart (automated installation -- basics are enough)
 * A general understanding of Qubes OS ;)

GNOME Desktop Environment Implementer
-------------------------------------

### Required Skills ###

 * GNOME
 * GTK
 * Whatever is needed to customize GNOME

### Tasks ###

 * Custom window decorations (colored frames)
 * Configuration for Qubes OS dom0
   * Disable uneeded things (e.g., file manager)
   * Configure menu to ease navigation through multiple VMs (similar to [what is
     configured in KDE](https://github.com/QubesOS/qubes-issues/issues/1784#issuecomment-216868265))

### Example Tasks ###

 Listed here: https://github.com/QubesOS/qubes-issues/issues/1806


