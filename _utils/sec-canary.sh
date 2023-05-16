#!/bin/bash

# Canary text file location
CANARY_LOC=${HOME}/repo/qubes/qubes-secpack/canaries
# Canary website data location
CANARY_DATA=${HOME}/repo/qubes/qubesos.github.io/_data/sec-canary.yml
# Secpack instructions location
SECPACK=${HOME}/repo/qubes/qubesos.github.io/_includes/secpack-instructions.md

# Update the qubes-secpack repo
cd $CANARY_LOC && git pl

# Get user input
read -p 'Canary number (e.g., 034): ' CANARY
read -p 'Canary date (e.g., 2023-03-02): ' CANARY_DATE
read -p 'Post date: ' POST_DATE

# Get the year (assumes post year and canary year are the same)
YEAR=`echo $POST_DATE | cut -c1-4`

# Get the input canary and signatures files
CANARY_FILE=${CANARY_LOC}/canary-${CANARY}-${YEAR}.txt
SIG_MAREK=${CANARY_LOC}/canary-${CANARY}-${YEAR}.txt.sig.marmarek
SIG_SIMON=${CANARY_LOC}/canary-${CANARY}-${YEAR}.txt.sig.simon

# Get the input canary file
CANARY_FILE=${CANARY_LOC}/canary-${CANARY}-${YEAR}.txt

# Update canary website data
printf -- "
- canary: \"${CANARY}\"
  date: $CANARY_DATE
" >> $CANARY_DATA

# Output post file
POST=${HOME}/repo/qubes/qubesos.github.io/_posts/${POST_DATE}-canary-${CANARY}.md

# Generate the post
printf -- "---
layout: post
title: \"Qubes canary ${CANARY}\"
categories: security
---

We have published [Qubes canary ${CANARY}](https://github.com/QubesOS/qubes-secpack/blob/main/canaries/canary-${CANARY}-${YEAR}.txt). The text of this canary and its accompanying cryptographic signatures are reproduced below. For an explanation of this announcement and instructions for authenticating this canary, please see the end of this announcement.

## Qubes canary $CANARY

\`\`\`
" >> $POST
cat $CANARY_FILE >> $POST
printf "
\`\`\`

Source: <https://github.com/QubesOS/qubes-secpack/blob/main/canaries/canary-${CANARY}-${YEAR}.txt>

## [Marek Marczykowski-Górecki](/team/#marek-marczykowski-górecki)'s PGP signature

\`\`\`
" >> $POST
cat $SIG_MAREK >> $POST
printf "\`\`\`

Source: <https://github.com/QubesOS/qubes-secpack/blob/main/canaries/canary-${CANARY}-${YEAR}.txt.sig.marmarek>

## [Simon Gaiser (aka HW42)](/team/#simon-gaiser-aka-hw42)'s PGP signature

\`\`\`
" >> $POST
cat $SIG_SIMON >> $POST
printf "\`\`\`

Source: <https://github.com/QubesOS/qubes-secpack/blob/main/canaries/canary-${CANARY}-${YEAR}.txt.sig.simon>

## What is the purpose of this announcement?

The purpose of this announcement is to inform the Qubes community that a new Qubes canary has been published.

## What is a Qubes canary?

A Qubes canary is a security announcement periodically issued by the [Qubes security team](/security/#qubes-security-team) consisting of several statements to the effect that the signers of the canary have not been compromised. The idea is that, as long as signed canaries including such statements continue to be published, all is well. However, if the canaries should suddenly cease, if one or more signers begin declining to sign them, or if the included statements change significantly without plausible explanation, then this may indicate that something has gone wrong. A list of all canaries is available [here](/security/canary/).

The name originates from the practice in which miners would bring caged canaries into coal mines. If the level of methane gas in the mine reached a dangerous level, the canary would die, indicating to miners that they should evacuate. (See the [Wikipedia article on warrant canaries](https://en.wikipedia.org/wiki/Warrant_canary) for more information, but bear in mind that Qubes Canaries are not strictly limited to legal warrants.)

## Why should I care about canaries?

Canaries provide an important indication about the security status of the project. If the canary is healthy, it's a strong sign that things are running normally. However, if the canary is unhealthy, it could mean that the project or its members are being coerced in some way.

## What are some signs of an unhealthy canary?

Here is a non-exhaustive list of examples:

- **Dead canary.** In each canary, we state a window of time during which you should expect the next canary to be published. If no canary is published within that window of time and no good explanation is provided for missing the deadline, then the canary has died.
- **Missing statement(s).** Every canary contains the same set of statements (sometimes along with special announcements, which are not the same in every canary). If an important statement was present in older canaries but suddenly goes missing from new canaries with no correction or explanation, then this may be an indication that the signers can no longer truthfully make that statement.
- **Missing signature(s).** Qubes canaries are signed by the members of the [Qubes security team](/security/#qubes-security-team) (see below). If one of them has been signing all canaries but suddenly and permanently stops signing new canaries without any explanation, then this may indicate that this person is under duress or can no longer truthfully sign the statements contained in the canary.

## Does every unexpected or unusual occurrence related to a canary indicate something bad?

No, there are many canary-related possibilities that should *not* worry you. Here is a non-exhaustive list of examples:

- **Unusual reposts.** The only canaries that matter are the ones that are validly signed in the [Qubes security pack (qubes-secpack)](/security/pack/). Reposts of canaries (like the one in this announcement) do not have any authority (except insofar as they reproduce validly-signed text from the qubes-secpack). If the actual canary in the qubes-secpack is healthy, but reposts are late, absent, or modified on the website, mailing lists, forum, or social media platforms, you should not be concerned about the canary.
- **Last-minute signature(s).** If the canary is signed at the last minute but before the deadline, that's okay. (People get busy and procrastinate sometimes.)
- **Signatures at different times.** If one signature is earlier or later than the other, but both are present within a reasonable period of time, that's okay. (For example, sometimes one signer is out of town, but we try to plan the deadlines around this.)
- **Permitted changes.** If something about a canary changes without violating any of statements in prior canaries, that's okay. (For example, canaries are usually scheduled for the first fourteen days of a given month, but there's no rule that says they have to be.)
- **Unusual but planned changes.** If something unusual happens, but it was announced in advance, and the appropriate statements are signed, that's okay (e.g., when Joanna left the security team and Simon joined it).

In general, it would not be realistic for an organization to exist that never changed, had zero turnover, and never made mistakes. Therefore, it would be reasonable to expect such events to occur periodically, and it would be unreasonable to regard *every* unusual or unexpected canary-related event as a sign of compromise. For example, if something usual happens with a canary, and we say it was a mistake and correct it, you will have to decide for yourself whether it's more likely that it really was just a mistake or that something is wrong and that this is how we chose to send you a subtle signal about it. This will require you to think carefully about which among many possible scenarios is most likely given the evidence available to you. Since this is fundamentally a matter of judgment, canaries are ultimately a *social* scheme, not a technical one.

## What are the PGP signatures that accompany canaries?

A [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) signature is a cryptographic [digital signature](https://en.wikipedia.org/wiki/Digital_signature) made in accordance with the [OpenPGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy#OpenPGP) standard. PGP signatures can be cryptographically verified with programs like [GNU Privacy Guard (GPG)](https://en.wikipedia.org/wiki/GNU_Privacy_Guard). The Qubes security team cryptographically signs all canaries so that Qubes users have a reliable way to check whether canaries are genuine. The only way to be certain that a canary is authentic is by verifying its PGP signatures.

## Why should I care whether a canary is authentic?

If you fail to notice that a canary is unhealthy or has died, you may continue to trust the Qubes security team even after they have signaled via the canary (or lack thereof) that they been compromised or coerced. Falsified canaries could include manipulated text designed to sow fear, uncertainty, and doubt about the security of Qubes OS or the status of the Qubes OS Project.

## How do I verify the PGP signatures on a canary?

" >> $POST
cat $SECPACK >> $POST
printf "

For this announcement (Qubes canary $CANARY), the commands are:

\`\`\`
$ gpg --verify canary-${CANARY}-${YEAR}.txt.sig.marmarek canary-${CANARY}-${YEAR}.txt
$ gpg --verify canary-${CANARY}-${YEAR}.txt.sig.simon canary-${CANARY}-${YEAR}.txt
\`\`\`

You can also verify the signatures directly from this announcement in addition to or instead of verifying the files from the qubes-secpack. Simply copy and paste the Qubes canary $CANARY text into a plain text file and do the same for both signature files. Then, perform the same authentication steps as listed above, substituting the filenames above with the names of the files you just created." >> $POST

exit
