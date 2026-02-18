salt_precursor:
  qvm.template_installed:
    - name: debian-13-minimal

qvm-clone-salt:
  qvm.clone:
    - name: template-salt
    - source: debian-13-minimal

