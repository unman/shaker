qubes-admin_requisite:
  qvm.template_installed:
    - name: debian-13-minimal

qvm-qubes-admin-clone-id:
  qvm.clone:
    - name: template-admin
    - source: debian-13-minimal
