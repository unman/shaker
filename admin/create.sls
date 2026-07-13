include:
  - admin.clone

sys-admin-present-id:
  qvm.present:
    - name: sys-admin
    - template: template-admin
    - label: gray

sys-admin-prefs-id:
  qvm.prefs:
    - name: sys-admin
    - memory: 400
    - maxmem: 4000
    - netvm: none
    - vcpus: 2

sys-admin-features-id:
  qvm.features:
    - name: sys-admin
    - disable:
      - service.cups

set_admin_policy:
  file.managed:
    - name: /etc/qubes/policy.d/10-admin.policy
    - source:
      - salt://admin/10-admin.policy
