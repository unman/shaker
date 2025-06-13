include:
  - share.clone

qvm-present-id:
  qvm.present:
    - name: share
    - template: template-share
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: share
    - netvm: none
    - memory: 400
    - maxmem: 800
    - vcpus: 2

qvm-features-id:
  qvm.features:
    - name: share
    - disable:
      - service.cups
      - service.cups-browsed

'qvm-volume extend share:private 40G' :
  cmd.run

update_file:
  file.prepend:
    - name: '/etc/qubes/policy.d/10-sshfs.policy'
    - text: 'qubes-sshfs  *  @anyvm  @anyvm  ask  default_target=share'

