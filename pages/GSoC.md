---
layout: sidebar
title: Google Summer of Code
permalink: /GSoC/
---

2017 Google Summer of Code
================

## Information for Students

Thank you for your interest in participating in the [Google Summer of Code program][gsoc] with the [Qubes OS team][team]. You can read more about the Google Summer of Code program at the [official website][gsoc] and the [official FAQ][gsoc-faq].

Being accepted as a Google Summer of Code student is quite competitive. Students wishing to participate in the Summer of Code must be aware that you will be required to produce code for Qubes OS for 3 months. Your mentors, Qubes developers, will dedicate a portion of their time towards mentoring you. Therefore, we seek candidates who are committed to helping Qubes long-term and are willing to do quality work and be proactive in communicating with your mentor.

You don't have to be a proven developer -- in fact, this whole program is meant to facilitate joining Qubes and other free and open source communities. The Qubes community maintains information about [contributing to Qubes development][contributing] and [how to send patches][patches]. In order to contribute code to the Qubes project, you must be able to [sign your code][code-signing].

You should start learning the components that you plan on working on before the start date. Qubes developers are available on the [mailing lists][ml-devel] for help. The GSoC timeline reserves a lot of time for bonding with the project -- use that time wisely. Good communication is key, you should plan to communicate with your team daily and formally report progress and plans weekly. Students who neglect active communication will be failed.

### Overview of Steps

- [ ] Join the [qubes-devel list][ml-devel] and introduce yourself, and meet your fellow developers
- [ ] Read [Google's instructions for participating][gsoc-participate] and the [GSoC Student Manual][gsoc-student]
- [ ] Take a look at the list of ideas below
- [ ] Come up with a project that you are interested in
- [ ] Read the Student Proposal guidelines below
- [ ] Write a first draft proposal and send it to the qubes-devel mailing list for review
- [ ] Submit proposal using [Google's web interface][gsoc-submit] ahead of the deadline (this requires a Google Account!)
- [ ] Submit proof of enrollment well ahead of the deadline

Coming up with an interesting idea that you can realistically achieve in the time available to you (one summer) is probably the most difficult part. We strongly recommend getting involved in advance of the beginning of GSoC, and we will look favorably on applications from students who have already started to act like free and open source developers.

### Student proposal guidelines

A project proposal is what you will be judged upon. Write a clear proposal on what you plan to do, the scope of your project, and why we should choose you to do it. Proposals are the basis of the GSoC projects and therefore one of the most important things to do well. The proposal is not only the basis of our decision of which student to choose, it has also an effect on Google's decision as to how many student slots are assigned to Qubes. 

Below is the application template:

```
# Introduction

Every software project should solve a problem. Before offering the solution (your Google Summer of Code project), you should first define the problem. What’s the current state of things? What’s the issue you wish to solve and why? Then you should conclude with a sentence or two about your solution. Include links to discussions, features, or bugs that describe the problem further if necessary.

# Project goals

Be short and to the point, and perhaps format it as a list. Propose a clear list of deliverables, explaining exactly what you promise to do and what you do not plan to do. “Future developments” can be mentioned, but your promise for the Google Summer of Code term is what counts.

# Implementation

Be detailed. Describe what you plan to do as a solution for the problem you defined above. Include technical details, showing that you understand the technology. Illustrate key technical elements of your proposed solution in reasonable detail.

# Timeline

Show that you understand the problem, have a solution, have also broken it down into manageable parts, and that you have a realistic plan on how to accomplish your goal. Here you set expectations, so don’t make promises you can’t keep. A modest, realistic and detailed timeline is better than promising the impossible.

If you have other commitments during GSoC, such as a job, vacation, exams, internship, seminars, or papers to write, disclose them here. GSoC should be treated like a full-time job, and we will expect approximately 40 hours of work per week. If you have conflicts, explain how you will work around them. If you are found to have conflicts which you did not disclose, you may be failed.

Open and clear communication is of utmost importance. Include your plans for communication in your proposal; daily if possible. You will need to initiate weekly formal communications such as a detailed email to the qubes-devel mailing list. Lack of communication will result in you being failed.

# About me

Provide your contact information and write a few sentences about you and why you think you are the best for this job. Prior contributions to Qubes are helpful; list your commits. Name people (other developers, students, professors) who can act as a reference for you. Mention your field of study if necessary. Now is the time to join the relevant mailing lists. We want you to be a part of our community, not just contribute your code.

Tell us if you are submitting proposals to other organizations, and whether or not you would choose Qubes if given the choice.

Other things to think about:
* Are you comfortable working independently under a supervisor or mentor who is several thousand miles away, and perhaps 12 time zones away? How will you work with your mentor to track your work? Have you worked in this style before?
* If your native language is not English, are you comfortable working closely with a supervisor whose native language is English? What is your native language, as that may help us find a mentor who has the same native language?
* After you have written your proposal, you should get it reviewed. Do not rely on the Qubes mentors to do it for you via the web interface, although we will try to comment on every proposal. It is wise to ask a colleague or a developer to critique your proposal. Clarity and completeness are important.
```

## Project Ideas

These project ideas were contributed by our developers and may be incomplete. If you are interested in submitting a proposal based on these ideas, you should contact the [qubes-devel mailing list][ml-devel] and associated GitHub issue to learn more about the idea.

```
### Adding a Proposal

**Project**: Something that you're totally excited about

**Brief explanation**: What is the project, where does the code live?

**Expected results**: What is the expected result in the timeframe given

**Knowledge prerequisite**: Pre-requisites for working on the project. What coding language and knowledge is needed? 
If applicable, links to more information or discussions

**Mentor**: Name and email address.
```

### Android development in Qubes

**Project**: Research running Android in Qubes VM (probably HVM) and connecting it to Android Studio

**Brief explanation**: The goal is to enable Android development (and testing!)
on Qubes OS. Currently it's only possible using qemu-emulated Android for ARM.
Since it's software emulation it's rather slow.
Details, reference: [#2233](https://github.com/QubesOS/qubes-issues/issues/2233)

**Expected results**:

**Knowledge prerequisite**:

**Mentor**:

### GNOME support in dom0

**Project**: GNOME support in dom0

**Brief explanation**: Integrating GNOME into Qubes dom0. This include:

 - patching window manager to add colorful borders
 - removing stuff not needed in dom0 (file manager(s), indexing services etc)
 - adjusting menu for easy navigation (same applications in different VMs and such problems, dom0-related entries in one place)
 - More info: [#1806](https://github.com/QubesOS/qubes-issues/issues/1806)

**Expected results**:

 - Review existing support for other desktop environments (KDE, Xfce4, i3, awesome).
 - Patch window manager to draw colorful borders (we use only server-side
   decorations), there is already very similar patch in
   [Cappsule project](https://github.com/cappsule/cappsule-gui).
 - Configure GNOME to not make use of dom0 user home in visible way (no search
   in files there, no file manager, etc).
 - Configure GNOME to not look into external devices plugged in (no auto
   mounting, device notifications etc).
 - Package above modifications as rpms, preferably as extra configuration files
   and/or plugins than overwriting existing files. Exceptions to this rule may
   apply if no other option.
 - Adjust comps.xml (in installer-qubes-os repo) to define package group with
   all required packages.
 - Document installation procedure.

**Knowledge prerequisite**:

 - GNOME architecture
 - C language (patching metacity)
 - Probably also javascript - for modifying GNOME shell extensions

**Mentor**:

### Qubes MIME handlers

**Project**: Qubes MIME handlers

**Brief explanation**: [#441](https://github.com/QubesOS/qubes-issues/issues/441) (including remembering decision whether some file
should be opened in DispVM or locally)

**Expected results**:

 - Design mechanism for recognising which files should be opened locally and which in Disposable VM. This mechanism should:
   - Respect default action like "by default open files in Disposable VM" (this
     may be about files downloaded from the internet, transferred from
     other VM etc).
   - Allow setting persistent flag for a file that should be opened in specific
     way ("locally"); this flag should local to the VM - it shouldn't be possible
     to preserve (or even fabricate) the flag while transferring the file from/to
     VM.
   - See linked ticket for simple ideas.
 - Implement generic file handler to apply this mechanism; it should work
   regardless of file type, and if file is chosen to be opened locally, normal
   (XDG) rules of choosing application should apply.
 - Setting/unsetting the flag should be easy - like if once file is chosen to
   be opened locally, it should remember that decision.
 - Preferably use generic mechanism to integrate it into file managers (XDG
   standards). If not possible - integrate with Nautilus and Dolphin.
 - Optionally implement the same for Windows.
 - Document the mechanism (how the flag is stored, how mechanism is plugged
   into file managers etc).
 - Write unit tests and integration tests.

**Knowledge prerequisite**:

 - XDG standards
 - Bash or Python scripting
 - Basic knowledge of configuration/extension for file managers

**Mentor**: [Marek Marczykowski-Górecki](/team/)

### Template manager, new template distribution mechanism

**Project**: Template manager, new template distribution mechanism

**Brief explanation**: Template VMs currently are distributed using RPM
packages. There are multiple problems with that, mostly related to static
nature of RPM package (what files belong to the package). This means such
Template VM cannot be renamed, migrated to another storage (like LVM), etc.
Also we don't want RPM to automatically update template package itself (which
would override all the user changes there). More details:
[#2064](https://github.com/QubesOS/qubes-issues/issues/2064),
[#2534](https://github.com/QubesOS/qubes-issues/issues/2534).

**Expected results**:

 - Design new mechanism for distributing templates (possibly including some
   package format - either reuse something already existing, or design
   new one). The mechanism needs to handle:
   - integrity protection (digital signatures), not parsing any data in dom0
     prior to signature verification
   - efficient handling of large sparse files
   - ability to deploy the template into various storage mechanisms (sparse
     files, LVM thin volumes etc).
   - template metadata, templates repository - enable the user to browse
     available templates (probably should be done in dedicated VM, or Disposable VM)
 - Implement the above mechanism:
   - tool to download named template - should perform download operation in
     some VM (as dom0 have no network access), then transfer the data to dom0,
     verify its integrity and then create Template VM and feed it's root
     filesystem image with downloaded data.
   - tool to browse templates repository - both CLI and GUI (preferably in (py)GTK)
   - integrate both tools - user should be able to choose some template to be
     installed from repository browsing tool - see
     [#1705](https://github.com/QubesOS/qubes-issues/issues/1705) for some idea
     (this one lack integrity verification, but similar service could
     be developed with that added)
 - If new "package" format is developed, add support for it into 
   [linux-template-builder](https://github.com/QubesOS/qubes-linux-template-builder).
 - Document the mechanism.
 - Write unit tests and integration tests.

**Knowledge prerequisite**:

 - Large files (disk images) handling (sparse files, archive formats)
 - Bash and Python scripting
 - Data integrity handling - digital signatures (gpg2, gpgv2)
 - PyGTK
 - RPM package format, (yum) repository basics

**Mentor**: [Marek Marczykowski-Górecki](/team/)

### Qubes Live USB

**Project**: Revive Qubes Live USB, integrate it with installer

**Brief explanation**: Qubes Live USB is based on Fedora tools to build live
distributions. But for Qubes we need some adjustments: starting Xen instead of
Linux kernel, smarter copy-on-write handling (we run there multiple VMs, so a
lot more data to save) and few more. Additionally in Qubes 3.2 we have
so many default VMs that default installation does not fit in 16GB image
(default value) - some subset of those VMs should be chosen. Ideally we'd like
to have just one image being both live system and installation image. More
details: [#1552](https://github.com/QubesOS/qubes-issues/issues/1552),
[#1965](https://github.com/QubesOS/qubes-issues/issues/1965).

**Expected results**:

 - Adjust set of VMs and templates included in live edition.
 - Update and fix build scripts for recent Qubes OS version.
 - Update startup script to mount appropriate directories as either
   copy-on-write (device-mapper snapshot), or tmpfs.
 - Optimize memory usage: should be possible to run sys-net, sys-firewall, and
   at least two more VMs on 4GB machine. This include minimizing writes to
   copy-on-write layer and tmpfs (disable logging etc).
 - Research option to install the system from live image. If feasible add
   this option.

**Knowledge prerequisite**:

 - System startup sequence: bootloaders (isolinux, syslinux, grub, UEFI), initramfs, systemd.
 - Python and Bash scripting
 - Filesystems and block devices: loop devices, device-mapper, tmpfs, overlayfs, sparse files.

**Mentor**: [Marek Marczykowski-Górecki](/team/)

### Unikernel-based firewallvm with Qubes firewall settings support

**Project**: Unikernel based firewallvm with Qubes firewall settings support

**Brief explanation**: (can't find a ticket for it)

**Expected results**:

**Knowledge prerequisite**:

**Mentor**:

### IPv6 support
**Project**: IPv6 support

**Brief explanation**: Add support for native IPv6 in Qubes VMs. This should
include IPv6 routing (+NAT...), IPv6-aware firewall, DNS configuration, dealing
with IPv6 being available or not in directly connected network. See
[#718](https://github.com/QubesOS/qubes-issues/issues/718) for more details.

**Expected results**:

 - Add IPv6 handling to network configuration scripts in VMs
 - Add support for IPv6 in Qubes firewall (including CLI/GUI tools to configure it)
 - Design and implement simple mechanism to propagate information about IPv6
   being available at all (if necessary). This should be aware of ProxyVMs
   potentially adding/removing IPv6 support - like VPN, Tor etc.
 - Add unit tests and integration tests for both configuration scripts and UI
   enhancements.
 - Update documentation.

**Knowledge prerequisite**:

 - network protocols, especially IPv6, TCP, DNS, DHCPv6, ICMPv6 (including
   autoconfiguration)
 - ip(6)tables, nftables, NAT
 - Python and Bash scripting
 - network configuration on Linux: ip tool, configuration files on Debian and
   Fedora, NetworkManager

**Mentor**: [Marek Marczykowski-Górecki](/team/)

### Thunderbird, Firefox and Chrome extensions
**Project**: additional Thunderbird, Firefox and Chrome extensions

**Brief explanation**: 

* browser/mail: open link in vm
* browser/mail: open link in dispvm
* browser: save destination to vm
* mail: add whitelisted senders option (address-based and signing key-based) [#845](https://github.com/QubesOS/qubes-issues/issues/845)

**Expected results**:

 - Extend existing Thunderbird extension to decide on action (where to open/save attachments) based on message sender - recognized as email address, or signing key
 - Add Firefox extension to open links in Disposable VM / selected VM (right-click option and a default action for not-whitelisted URLs/domains)
 - The same for Chrome
 - Add tests for above enhancements
 - Update user documentation

**Knowledge prerequisite**:

 - writing Thunderbird/Firefox extensions (XUL, javascript)
 - writing Chrome extensions (javascript)

**Mentor**: [Jean-Philippe Ouellet](mailto:jpo@vt.edu)

### LogVM(s)

**Project**: LogVM(s)

**Brief explanation**: Qubes AppVMs do not have persistent /var (on purpose).
It would be useful to send logs generated by various VMs to a dedicated
log-collecting VM. This way logs will not only survive VM shutdown, but also be
immune to altering past entries. See
[#830](https://github.com/QubesOS/qubes-issues/issues/830) for details.

**Expected results**:

 - Design a _simple_ protocol for transferring logs. The less metadata (parsed
   in log-collecting VM) the better.
 - Implement log collecting service. Besides logs itself, should save
   information about logs origin (VM name) and timestamp. The service should
   _not_ trust sending VM in any of those.
 - Implement log forwarder compatible with systemd-journald and rsyslog. A
   mechanism (service/plugin) fetching logs in real time from those and sending
   to log-collecting VM over qrexec service.
 - Document the protocol.
 - Write unit tests and integration tests.

**Knowledge prerequisite**:

 - syslog
 - systemd
 - Python/Bash scripting

**Mentor**: [Jean-Philippe Ouellet](mailto:jpo@vt.edu)

### GUI improvements

**Project**: GUI improvements

**Brief explanation**:

* GUI for enabling USB keyboard: [#2329](https://github.com/QubesOS/qubes-issues/issues/2329)
* GUI for enabling USB passthrough: [#2328](https://github.com/QubesOS/qubes-issues/issues/2328)
* GUI interface for /etc/qubes/guid.conf: [#2304](https://github.com/QubesOS/qubes-issues/issues/2304)
* Improving inter-VM file copy / move UX master ticket: [#1839](https://github.com/QubesOS/qubes-issues/issues/1839)
* and comprehensive list of GUI issues: [#1117](https://github.com/QubesOS/qubes-issues/issues/1117)

**Expected results**:

 - Add/enhance GUI tools to configure/do things mentioned in description above.
   Reasonable subset of those things is acceptable.
 - Write tests for added elements.

**Knowledge prerequisite**:

 - Python, PyGTK

**Mentor**: [Jean-Philippe Ouellet](mailto:jpo@vt.edu)

### Xen GPU pass-through for Intel integrated GPUs
**Project**: Xen GPU pass-through for Intel integrated GPUs (largely independent of Qubes)

**Brief explanation**: This project is prerequisite to full GUI domain support,
where all desktop environment is running in dedicated VM, isolated from
dom0. There is already some support for GPU passthrough in Xen, but needs to be
integrated in to Qubes and probably really make working, even when using qemu
in stubdomain. GUI domain should be a HVM domain (not PV).
This should be done without compromising Qubes security features, especially:
using VT-d for protection against DMA attacks, using stubdomain for sandboxing
qemu process (if needed) - qemu running in dom0 is not acceptable.  More
details in [#2618](https://github.com/QubesOS/qubes-issues/issues/2618).

**Expected results**:

 - Ability to start a VM with GPU connected. VM should be able to handle video
   output (both laptop internal display, and external monitors if apply). That
   VM also should be able to use hardware acceleration.
 - This project may require patching any/all of Xen hypervisor, Libvirt, Qemu,
   Linux. In such a case, patches should be submitted to appropriate upstream
   project.
 - It's ok to focus on a specific, relatively new Intel-based system with Intel
   integrated GPU.

**Knowledge prerequisite**:

 - C language
 - Kernel/hypervisor debugging
 - Basics of x86_64 architecture, PCIe devices handling (DMA, MMIO, interrupts), IOMMU (aka VT-d)
 - Xen hypervisor architecture

**Mentor**: [Marek Marczykowski-Górecki](/team/)

### Whonix IPv6 and nftables support
**Project**: Whonix IPv6 and nftables support

**Brief explanation**: [T509](https://phabricator.whonix.org/T509)

**Expected results**:

**Knowledge prerequisite**:

**Mentor**: Patrick Schleizer

### Standalone connection wizard for Tor pluggable transports
**Project**: Standalone connection wizard for Tor pluggable transports

**Brief explanation**: [#1938](https://github.com/QubesOS/qubes-issues/issues/1938)

**Expected results**:

**Knowledge prerequisite**:

**Mentor**: Patrick Schleizer

We adapted some of the language here about GSoC from the [KDE GSoC page](https://community.kde.org/GSoC).

[gsoc]: https://summerofcode.withgoogle.com/
[team]: https://www.qubes-os.org/team/
[gsoc-faq]: https://developers.google.com/open-source/gsoc/faq
[contributing]: https://www.qubes-os.org/doc/contributing/#contributing-code
[patches]: https://www.qubes-os.org/doc/source-code/#how-to-send-patches
[code-signing]: https://www.qubes-os.org/doc/code-signing/
[ml-devel]: https://www.qubes-os.org/mailing-lists/#qubes-devel
[gsoc-participate]: https://developers.google.com/open-source/gsoc/
[gsoc-student]: https://developers.google.com/open-source/gsoc/resources/manual#student_manual
[how-to-gsoc]: http://teom.org/blog/kde/how-to-write-a-kick-ass-proposal-for-google-summer-of-code/
[gsoc-submit]: https://summerofcode.withgoogle.com/
[mailing-lists]: https://www.qubes-os.org/mailing-lists/
