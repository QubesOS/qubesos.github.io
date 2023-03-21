#!/bin/bash

# QSB text file location
QSB_LOC=${HOME}/repo/qubes/qubes-secpack/QSBs
# QSB website data location
QSB_DATA=${HOME}/repo/qubes/qubesos.github.io/_data/sec-qsb.yml
# XSA website data location
XSA_DATA=${HOME}/repo/qubes/qubesos.github.io/_data/sec-xsa.yml
# Secpack instructions location
SECPACK=${HOME}/repo/qubes/qubesos.github.io/_includes/secpack-instructions.md

# Update the qubes-secpack repo
cd $QSB_LOC && git pl

# Get user input
read -p 'QSB number (e.g., 049): ' QSB
read -p 'Post date: ' POST_DATE
#read -p 'XSA Number (e.g., 123; leave blank if N/A): ' XSA
#read -p 'XSA Date (leave blank if N/A): ' XSA_DATE

# Get the year (assumes post year and QSB year are the same)
YEAR=`echo $POST_DATE | cut -c1-4`

# Get the input QSB and signatures files
QSB_FILE=${QSB_LOC}/qsb-${QSB}-${YEAR}.txt
SIG_MAREK=${QSB_LOC}/qsb-${QSB}-${YEAR}.txt.sig.marmarek
SIG_SIMON=${QSB_LOC}/qsb-${QSB}-${YEAR}.txt.sig.simon

# Get the QSB title
TITLE=`sed -n '6p' $QSB_FILE | sed -e 's/^[ \t]*//'`
# Get the QSB date
QSB_DATE=`sed -n '4p' $QSB_FILE | sed -e 's/^[ \t]*//'`

# Update QSB website data
printf -- "
- qsb: \"${QSB}\"
  title: \"${TITLE}\"
  date: $QSB_DATE
" >> $QSB_DATA

# Update XSA website data (if applicable)
#@TODO: Create a loop to handle multiple XSAs
#if [ -n "$XSA" ]
#    then
#        printf -- "- xsa: $XSA
#  date: $XSA_DATE
#  affected: yes
#  qsb: ${QSB}-${YEAR}
#  mitigation:
#\n" >> $XSA_DATA
#fi

# Output post file
POST=${HOME}/repo/qubes/qubesos.github.io/_posts/${POST_DATE}-qsb-${QSB}.md

# Generate the post
printf -- "---
layout: post
title: \"QSB-${QSB}: ${TITLE}\"
categories: security
---

We have published [Qubes Security Bulletin (QSB) ${QSB}: ${TITLE}](https://github.com/QubesOS/qubes-secpack/blob/master/QSBs/qsb-${QSB}-${YEAR}.txt). The text of this QSB and its accompanying cryptographic signatures are reproduced below. For an explanation of this announcement and instructions for authenticating this QSB, please see the end of this announcement.

## Qubes Security Bulletin $QSB

\`\`\`
" >> $POST
cat $QSB_FILE >> $POST
printf "
\`\`\`

**Source:** <https://github.com/QubesOS/qubes-secpack/blob/master/QSBs/qsb-${QSB}-${YEAR}.txt>

## [Marek Marczykowski-Górecki](/team/#marek-marczykowski-górecki)'s PGP signature

\`\`\`
" >> $POST
cat $SIG_MAREK >> $POST
printf "\`\`\`

**Source:** <https://github.com/QubesOS/qubes-secpack/blob/master/QSBs/qsb-${QSB}-${YEAR}.txt.sig.marmarek>

## [Simon Gaiser (aka HW42)](/team/#simon-gaiser-aka-hw42)'s PGP signature

\`\`\`
" >> $POST
cat $SIG_SIMON >> $POST
printf "\`\`\`

**Source:** <https://github.com/QubesOS/qubes-secpack/blob/master/QSBs/qsb-${QSB}-${YEAR}.txt.sig.simon>

## What is the purpose of this announcement?

The purpose of this announcement is to inform the Qubes community that a new Qubes Security Bulletin (QSB) has been published.

## What is a Qubes Security Bulletin (QSB)?

A Qubes security bulletin (QSB) is a security announcement issued by the [Qubes security team](/security/#qubes-security-team). A QSB typically provides a summary and impact analysis of one or more recently-discovered software vulnerabilities, including details about patching to address them. A list of all QSBs is available [here](/security/qsb/).

## Why should I care about QSBs?

QSBs tell you what actions you must take in order to protect yourself from recently-discovered security vulnerabilities. In most cases, security vulnerabilities are addressed by [updating normally](/doc/how-to-update/). However, in some cases, special user action is required. In all cases, the required actions are detailed in QSBs.

## What are the PGP signatures that accompany QSBs?

A [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) signature is a cryptographic [digital signature](https://en.wikipedia.org/wiki/Digital_signature) made in accordance with the [OpenPGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy#OpenPGP) standard. PGP signatures can be cryptographically verified with programs like [GNU Privacy Guard (GPG)](https://gnupg.org/). The Qubes security team cryptographically signs all QSBs so that Qubes users have a reliable way to check whether QSBs are genuine. The only way to be certain that a QSB is authentic is by verifying its PGP signatures.

## Why should I care whether a QSB is authentic?

A forged QSB could deceive you into taking actions that adversely affect the security of your Qubes OS system, such as installing malware or making configuration changes that render your system vulnerable to attack. Falsified QSBs could sow fear, uncertainty, and doubt about the security of Qubes OS or the status of the Qubes OS Project.

## How do I verify the PGP signatures on a QSB?

" >> $POST
cat $SECPACK >> $POST
printf "

For this announcement (QSB-$QSB), the commands are:

\`\`\`
$ gpg --verify qsb-${QSB}-${YEAR}.txt.sig.marmarek qsb-${QSB}-${YEAR}.txt
$ gpg --verify qsb-${QSB}-${YEAR}.txt.sig.simon qsb-${QSB}-${YEAR}.txt
\`\`\`

You can also verify the signatures directly from this announcement in addition to or instead of verifying the files from the qubes-secpack. Simply copy and paste the QSB-$QSB text into a plain text file and do the same for both signature files. Then, perform the same authentication steps as listed above, substituting the filenames above with the names of the files you just created." >> $POST

exit
