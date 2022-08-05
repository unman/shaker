builder_requisite:
  qvm.template_installed:
    - name: fedora-36-minimal

qvm-clone-id:
  qvm.clone:
    - name: template-builder
    - source: fedora-36-minimal
