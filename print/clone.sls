print_precursor:
  qvm.template_installed:
    - name: debian-11-minimal

qvm-clone-id:
  qvm.clone:
    - name: template-print
    - source: debian-11-minimal
