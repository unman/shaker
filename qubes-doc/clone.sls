qubes-doc_requisite:
  qvm.template_installed:
    - name: fedora-40

qvm-qubes-doc-clone-id:
  qvm.clone:
    - name: template-qubes-doc
    - source: fedora-40
