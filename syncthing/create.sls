include:
  - syncthing.clone

qvm-present-id:
  qvm.present:
    - name: syncthing
    - template: template-syncthing
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: syncthing
    - memory: 300
    - maxmem: 800
    - vcpus: 2

'qvm-volume extend syncthing:private 50G' :
  cmd.run

syncthing_policy:
  file.prepend:
    - name: /etc/qubes/policy.d/30-user.policy
    - text: 'qubes.Syncthing  *  @anyvm  @anyvm  deny'
    - makedirs: True
