qvm-present-id:
  qvm.present:
    - name: printer
    - template: debian-10
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: printer
    - netvm: sys-firewall

qvm-features-id:
  qvm.features:
    - name: printer
    - disable:
      - service.cups-browsed
    - enable:
      - service.cups

update_file:
  file.prepend:
    - name: '/etc/qubes-rpc/policy/qubes.Print'
    - text: '@anyvm @anyvm ask,default_target=printer'
