qubes-builder_requisite:
  qvm.template_installed:
    - name: fedora-43-minimal

qvm-qubes-builder-clone-id:
  qvm.clone:
    - name: template-qubes-builder
    - source: fedora-43-minimal
