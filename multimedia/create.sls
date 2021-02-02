include:
  - multimedia.clone

qvm-present-id:
  qvm.present:
    - name: multimedia-dvm
    - template: template-multimedia
    - label: purple

qvm-prefs-id:
  qvm.prefs:
    - name: multimedia-dvm
    - netvm: none
    - memory: 300
    - maxmem: 800
    - vcpus: 2
    - template_for_dispvms: True
    - include_in_backups: false

qvm-features-id:
  qvm.features:
    - name: multimedia-dvm
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy


multimedia:
  qvm.present:
    - name: multimedia
    - template: multimedia-dvm
    - class: DispVM
    - netvm: none
    - label: purple

multimedia-prefs:
  qvm.prefs:
    - name: multimedia
    - autostart: false
    - include_in_backups: false

multimedia-features:
  qvm.features:
    - name: multimedia
    - appemenus-dispvm: True
    - disable:
      - service.cups
     
update_policy_file:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.OpenInVM
    - text: media $dispvm allow,target=multimedia
