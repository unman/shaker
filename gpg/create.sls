include:
  - gpg.clone

qvm-present-id:
  qvm.present:
    - name: gpg
    - template: template-gpg
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: gpg
    - netvm: none
    - memory: 400
    - maxmem: 800
    - vcpus: 2

qvm-features-id:
  qvm.features:
    - name: gpg
    - disable:
      - service.cups
      - service.cups-browsed

'qvm-volume extend gpg:private 10G' :
  cmd.run

update_file:
  file.prepend:
    - name: '/etc/qubes-rpc/policy/qubes.Gpg'
    - text: '@anyvm @anyvm ask,default_target=gpg'

