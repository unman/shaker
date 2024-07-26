include:
  - monitor.clone

qvm-present-monitor:
  qvm.present:
    - name: sys-monitor
    - template: template-monitor
    - label: green

qvm-prefs-monitor:
  qvm.prefs:
    - name: sys-monitor
    - netvm: sys-net
    - memory: 400
    - maxmem: 1500
    - vcpus: 2
    - provides-network: True

qvm-features-monitor:
  qvm.features:
    - name: sys-monitor
    - ipv6: ''
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
    - set:
      - menu-items: "org.wireshark.Wireshark.desktop debian-uxterm.desktop"

'qvm-volume extend sys-monitor:private 40G' :
  cmd.run
