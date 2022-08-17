include:
  - builder.clone

qvm-present-id:
  qvm.present:
    - name: builder
    - template: template-builder
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: builder
    - memory: 800
    - maxmem: 8000
    - vcpus: 4

qvm-features-id:
  qvm.features:
    - name: builder
    - disable:
      - service.cups

'qvm-volume extend builder:private 20G' :
  cmd.run

update_file:
  file.prepend:
    - name: /etc/qubes/policy.d/30-user.policy
    - text: qubes.Gpg * builder sys-gpg allow
    - makedirs: True
