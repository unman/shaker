gpg_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

qvm-clone-id:
  qvm.clone:
    - name: template-gpg
    - source: debian-12-minimal

'sudo qubes-dom0-update qubes-gpg-split-dom0':
  cmd.run
