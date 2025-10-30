pihole_depends:
  qvm.template_installed:
    - name: debian-13-minimal

pihole-present-id:
  qvm.present:
    - name: sys-pihole
    - template: debian-13-minimal
    - label: green
    - class: StandaloneVM

pihole-prefs-id:
  qvm.prefs:
    - name: sys-pihole
    - memory: 300
    - maxmem: 800
    - vcpus: 2
    - netvm: sys-net
    - provides-network: true

pihole-features-id:
  qvm.features:
    - name: sys-pihole
    - disable:
      - service.cups
      - service.cups-browsed

'qvm-volume extend sys-pihole:private 20G':
  cmd.run
