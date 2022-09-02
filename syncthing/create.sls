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

'qvm-volume extend syncthing:private 30G' :
  cmd.run
