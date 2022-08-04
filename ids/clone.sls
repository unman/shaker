ids_precursor:
  qvm.template_installed:
    - name: debian-11-minimal

qvm-clone-ids:
  qvm.clone:
    - name: template-ids
    - source: debian-11-minimal
