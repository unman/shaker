qubes-doc_requisite:
  qvm.template_installed:
    - name: fedora-42

qvm-qubes-doc-clone-id:
  qvm.clone:
    - name: template-qubes-doc
    - source: fedora-42
