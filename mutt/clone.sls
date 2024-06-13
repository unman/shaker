# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#

mutt_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

qvm-clone-id:
  qvm.clone:
    - name: template-mutt
    - source: debian-12-minimal

mutt_menu:
  qvm.features:
    - name: template-mutt
    - set:
      - menu-items: "mutt.desktop mutt_setup.desktop debian-xterm.desktop"
      - default-menu-items: "mutt.desktop mutt_setup.desktop debian-xterm.desktop"

start-template-mutt:
  qvm.start:
    - name: template-mutt
