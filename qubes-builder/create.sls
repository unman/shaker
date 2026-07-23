include:
  - qubes-builder.clone

qubes-builder-present-id:
  qvm.present:
    - name: qubes-builder
    - template: template-qubes-builder
    - label: gray

qubes-builder-prefs-id:
  qvm.prefs:
    - name: qubes-builder
    - memory: 800
    - maxmem: 8000
    - vcpus: 4

qubes-builder-features-id:
  qvm.features:
    - name: qubes-builder
    - disable:
      - service.cups

'qvm-volume extend qubes-builder:private 50G' :
  cmd.run

qubes-builder_update_policy_file:
  file.prepend:
    - name: /etc/qubes/policy.d/50-config-splitgpg.policy
    - text: qubes.Gpg * qubes-builder sys-gpg allow
    - makedirs: True
