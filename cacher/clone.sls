clone_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

qvm-clone-id:
  qvm.clone:
    - name: template-cacher
    - source: debian-12-minimal
