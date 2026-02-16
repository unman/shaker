multimedia_precursor:
  qvm.template_installed:
    - name: debian-13-minimal

qvm-clone-id:
  qvm.clone:
    - name: template-salt
    - source: debian-13-minimal
