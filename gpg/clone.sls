gpg_precursor:
  - qvm.template_installed:
    - name: template-debian-11-minimal

qvm-clone-id:
  qvm.clone:
    - name: template-gpg
    - source: debian-11-minimal

'sudo qubes-dom0-update qubes-gpg-split-dom0':
  cmd.run
