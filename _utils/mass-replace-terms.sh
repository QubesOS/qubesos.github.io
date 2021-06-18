#!/bin/bash
# Used for https://github.com/QubesOS/qubes-issues/issues/1015

find . -type f -name "*.md" | xargs -i@ sed -i 's/AppVM/app qube/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/--class app qube/--class AppVM/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/TemplateBasedVM/app qube/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/#templatebasedvm/#app-qube/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/# app/# App/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/a app/an app/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/a \[app/an \[app/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\. app/\. App/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\.  app/\.  App/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\. \[app/\. \[App/g' @

find . -type f -name "*.md" | xargs -i@ sed -i 's/DisposableVM/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Disposable VM/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/disposable VM/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Disposable vm/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/disposable vm/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/disposableVM/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/disposablevm/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Disposablevm/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/DisposableVM Template/disposable template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Disposable VM Template/disposable template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Disposable VM template/disposable template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Disposable vm template/disposable template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/DVM Template/disposable template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/DVM template/disposable template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/DVM/disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/# disposable/# Disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\. disposable/\. Disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\. \[disposable/\. \[Disposable/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/disposable Template/disposable template/g' @

find . -type f -name "*.md" | xargs -i@ sed -i 's/TemplateVM/template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Template VM/template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/template VM/template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Template vm/template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/template vm/template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/templatevm/template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/templateVM/template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/Templatevm/template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/# template/# Template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\. template/\. Template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\. \[template/\. \[Template/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\[Minimal template\]/\[Minimal Template\]/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\[Fedora template\]/\[Fedora Template\]/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\[Debian template\]/\[Debian Template\]/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\[Whonix template\]/\[Whonix Template\]/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/--class template/--class TemplateVM/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/atemplate\](/a Template\](/g' @

find . -type f -name "*.md" | xargs -i@ sed -i 's/StandaloneVM/standalone/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/# standalone/# Standalone/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\. standalone/\. Standalone/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/\. \[standalone/\. \[Standalone/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/#standalonevm/#standalone/g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/--class standalone/--class StandaloneVM/g' @

find . -type f -name "*.md" | xargs -i@ sed -i 's#/doc/disposables/#/doc/how-to-use-disposables/#g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's#/doc/standalone-and-HVM/#/doc/standalones-and-HVM/#g' @
find . -type f -name "*.md" | xargs -i@ sed -i 's/#updating-software-in-templates/#instructions/g' @
