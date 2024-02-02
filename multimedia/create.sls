include:
  - multimedia.clone

media_precursor:
  qvm.template_installed:
    - name: debian-12-xfce

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
    - netvm: none

multimedia-features:
  qvm.features:
    - name: multimedia
    - appemenus-dispvm: True
    - disable:
      - service.cups
    - enable:
      - service.shutdown-idle


media-present-id:
  qvm.present:
    - name: media
    - template: debian-12-xfce
    - label: purple

media-prefs:
  qvm.prefs:
    - name: media
    - autostart: false
    - include_in_backups: true
    - netvm: none

'qvm-volume extend media:private 40G' :
  cmd.run
     

update_policy_file:
  file.prepend:
    - name: /etc/qubes/policy.d/30-user.policy
    - text: qubes.OpenInVM  *  media @dispvm allow target=multimedia
