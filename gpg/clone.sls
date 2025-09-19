gpg_precursor:
  qvm.template_installed:
    - name: debian-13-minimal

qvm-clone-id:
  qvm.clone:
    - name: template-gpg
    - source: debian-13-minimal

'sudo qubes-dom0-update qubes-gpg-split-dom0':
  cmd.run
