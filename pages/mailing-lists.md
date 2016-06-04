---
layout: default
title: Mailing Lists
permalink: /mailing-lists/
redirect_from:
- /doc/mailing-lists/
- /en/doc/mailing-lists/
- /en/doc/qubes-lists/
- /doc/qubes-lists/
- /doc/QubesLists/
- /wiki/QubesLists/
---

Qubes Mailing Lists
===================

Qubes discussions take place on two mailing lists: `qubes-users` and
`qubes-devel`, both of which are explained below. Please send all questions
regarding Qubes to one of these two lists. **Please do not send questions to
individual Qubes developers.** By sending a message to the appropriate mailing
list, you are not only giving others a chance to help you, but you may also be
helping others by starting a public discussion about a shared problem or
interest.


Mailing list guidelines
-----------------------

 * Send your message to the correct list. Read the sections below to determine
   which list is correct for your message.

 * Do not [top-post].

 * Include a precise and informative subject line. This will allow others to
   easily find your thread in the future and use it as a reference.
   * Bad: "Help! Qubes problems!"
   * Good: "R2B2 Installation problem: Apple keyboard not working in installer."

 * Be concise. Do not write an essay. Include only essential information. Please
   think about how many messages come to the list every day and whether people
   will want to read through your lengthy message (hint: they won't!).

 * Do not apologize for your poor English. This is a waste of everyone's time,
   including your own. If we can't understand you, we will ask you to clarify
   (or ignore your message if it's a total mess ;).

 * While we're generally open to hearing suggestions for new features, please
   note that we already have a pretty well defined [roadmap], and it's rather
   unlikely that we will change our schedule in order to accommodate your
   request. If there's a particular feature you'd like to see in Qubes, a much
   more effective way to make it happen is to... contribute code to Qubes which
   implements it! We happily accept such contributions, provided they meet our
   standards. Please note, however, that it's always a good idea to field a
   discussion of your idea on the `qubes-devel` list before putting in a lot of
   hard work on something that we may not be able or willing to accept.

 * If it seems like your messages to the mailing lists are consistently being
   ignored, then take the time to learn [how to ask questions the smart way].
   (If you're already asking questions the smart way but still not getting any
   replies, then it's probably just that no one else knows the answer either.)


The **qubes-users** list
------------------------

### How to use this list

This list is for helping users solve various daily problems with Qubes OS.
Examples of topics or questions suitable for this list include:

 * [HCL] reports
 * Installation problems
 * Hardware compatibility problems
 * Questions of the form: "How do I...?"

### Read these first

Please try searching both the Qubes website and the archives of the mailing
lists before sending a question. In addition, please make sure that you have
read and understood the following basic documentation prior to posting to the
list:

 * The [Installation Guide], [System Requirements], and [HCL] (for problems
   related to installing Qubes OS)
 * The [User FAQ]
 * The [documentation] (for questions about how to use Qubes OS)

### How to subscribe and post

#### Google Groups

You don't have to subscribe in order to post to this list. However, subscribing
might nonetheless be desirable, as it ensures that your messages will not be
eaten by the Google Groups spam filter and allows you to receive messages which
were sent directly to the list.

 * To subscribe to the list, send a blank email to
   `qubes-users+subscribe@googlegroups.com`.
   * Note: A Gmail account is *not* required. Any email address will work.
 * To post a message to the list, address your email to
   `qubes-users@googlegroups.com`.
   * Note: You don't have to be subscribed in order to post.
 * To unsubscribe, send a blank email to
   `qubes-users+unsubscribe@googlegroups.com`.
 * This list also has a [Google Groups web interface][qubes-users-web].
   * Some users prefer to interact with the mailing list through the web
     interface. This has the advantage that it allows you to search and reply to
     messages which were sent prior to your subscription to the list. However, a
     Google account is required in order to post through this interface.

#### Gmane

The mailing list is also available via Gmane, a service that provides mailing
lists in the form of newsgroups. This makes it possible for you to subscribe
and read all mails sent to the list without having them all sent to your normal
mail account.  To use Gmane, you need a newsreader such as Mozilla Thunderbird
(or Icedove in Debian).

To add Gmane's server to Thunderbird, follow the instructions in
[Mozilla Thunderbird's documentation for how to add
newsgroups][thunderbird-newsgroup].
In the fourth step replace `news.mozilla.org` with `news.gmane.org`.

  * To subscribe to the list, click on **Subscribe...** and search for the
    newsgroup `gmane.os.qubes.user`. Click on the checkbox besides the name and
    **OK**.
  * You send and reply to mails the same way you would normally.
  * To unsubscribe from the list, click on **Subscribe...**
    search for the newsgroup `gmane.os.qubes.user`, uncheck the checkbox, and
    click on **OK**. Thunderbrid will automatically remove the newsgroup.


The **qubes-devel** list
------------------------

### How to use this list

This list is primarily intended for people who are interested in contributing to
Qubes or who are willing to learn more about its architecture and
implementation. Examples of topics and questions suitable for this list include:

 * Questions about why we made certain architecture or implementation decisions.
   * For example: "Why did you implement XYZ this way and not the other way?"
 * Questions about code layout and where code is for certain functionality.
 * Discussions about proposed new features, patches, etc.
   * For example: "I would like to implement feature XYZ."
 * Contributed code and patches.
 * Security discussions which are relevant to Qubes in some way.

### How to subscribe and post

#### Google Groups

You must be subscribed in order to post to this list.

 * To subscribe to the list, send a blank email to
   `qubes-devel+subscribe@googlegroups.com`.
   * Note: A Gmail account is *not* required. Any email address will work.
 * To post a message to the list, address your email to
   `qubes-devel@googlegroups.com`.
   * Note: You must be subscribed in order to post. If your post does not
     appear, please allow time for moderation to occur.
 * To unsubscribe, send a blank email to
   `qubes-devel+unsubscribe@googlegroups.com`.
 * This list has a [Google Groups web interface][qubes-devel-web].
   * Some users prefer to interact with the mailing list through the web
     interface. This has the advantage that it allows you to search and reply to
     messages which were sent prior to your subscription to the list. However, a
     Google account is required in order to post through this interface.

#### Gmane

The mailing list is also available via Gmane, a service that provides mailing
lists in the form of newsgroups. This makes it possible for you to subscribe
and read all mails sent to the list without having them all sent to your normal
mail account.  To use Gmane, you need a newsreader such as Mozilla Thunderbird
(or Icedove in Debian).

To add Gmane's server to Thunderbird, follow the instructions in
[Mozilla Thunderbird's documentation for how to add
newsgroups][thunderbird-newsgroup].
In the fourth step replace `news.mozilla.org` with `news.gmane.org`.

  * To subscribe to the list, click on **Subscribe...** and search for the
    newsgroup `gmane.os.qubes.devel`. Click on the checkbox besides the name and
    **OK**.
  * You send and reply to mails the same way you would normally.
  * To unsubscribe from the list, click on **Subscribe...**
    search for the newsgroup `gmane.os.qubes.devel`, uncheck the checkbox, and
    click on **OK**. Thunderbrid will automatically remove the newsgroup.


[top-post]: https://en.wikipedia.org/wiki/Posting_style
[roadmap]: https://github.com/QubesOS/qubes-issues/milestones
[how to ask questions the smart way]: http://www.catb.org/esr/faqs/smart-questions.html
[HCL]: /doc/hcl/
[Installation Guide]: /doc/installation-guide/
[System Requirements]: /doc/system-requirements/
[User FAQ]: /doc/user-faq/
[documentation]: /doc/
[thunderbird-newsgroup]: https://support.mozilla.org/en-US/kb/creating-newsgroup-account
[qubes-users-web]: https://groups.google.com/group/qubes-users
[qubes-devel-web]: https://groups.google.com/group/qubes-devel


