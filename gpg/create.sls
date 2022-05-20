include:
  - gpg.clone

qvm-present-id:
  qvm.present:
    - name: sys-gpg
    - template: template-gpg
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: sys-gpg
    - netvm: none
    - memory: 400
    - maxmem: 800
    - vcpus: 2

qvm-features-id:
  qvm.features:
    - name: sys-gpg
    - disable:
      - service.cups
      - service.cups-browsed

'qvm-volume extend sys-gpg:private 10G' :
  cmd.run

update_file:
  file.prepend:
    - name: '/etc/qubes/policy.d/30-user.policy'
    - text: 'qubes.Gpg  *  @anyvm  @anyvm ask default_target=sys-gpg'
