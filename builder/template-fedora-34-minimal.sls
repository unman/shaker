# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-fedora-34-minimal
# ======================
#
# Installs 'fedora-34-minimal' template.
#
# Execute:
#   qubesctl state.sls qvm.template-fedora-34-minimal dom0
##

template-fedora-34-minimal:
  qvm.template_installed:
    - name:     qubes-template-fedora-34-minimal
    - fromrepo: qubes-templates-itl
