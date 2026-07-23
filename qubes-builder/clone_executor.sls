qubes-builder_requisite:
  qvm.template_installed:
    - name: fedora-43

qvm-executor-clone-id:
  qvm.clone:
    - name: template-executor
    - source: fedora-43
