# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-fedora-32-minimal
# ======================
#
# Installs 'fedora-32-minimal' template.
#
# Execute:
#   qubesctl state.sls qvm.template-fedora-32-minimal dom0
##

template-fedora-32-minimal:
  pkg.installed:
    - name:     qubes-template-fedora-32-minimal
    - fromrepo: qubes-templates-itl
