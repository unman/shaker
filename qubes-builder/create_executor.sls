include:
  - qubes-builder.clone_executor

qvm-present-id:
  qvm.present:
    - name: qubes-builder-dvm
    - template: template-executor
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: qubes-builder-dvm
    - memory: 800
    - maxmem: 8000
    - template_for_dispvms: True
    - vcpus: 4

qvm-features-id:
  qvm.features:
    - name: qubes-builder-dvm
    - disable:
      - service.cups

'qvm-volume extend qubes-builder-dvm:private 50G' :
  cmd.run

update_file:
  file.prepend:
    - name: /etc/qubes/policy.d/50-config-splitgpg.policy
    - text: qubes.Gpg * qubes-builder-dvm sys-gpg allow
    - makedirs: True

/etc/qubes/policy.d/50-qubesbuilder.policy:
  file.managed:
    - source:
      - salt://qubes-builder/50-qubesbuilder.policy
    - user: root
    - group: qubes
    - makedirs: True
    - mode: 664

