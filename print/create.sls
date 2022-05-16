qvm-present-id:
  qvm.present:
    - name: sys-printer
    - template: debian-11
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: sys-printer
    - netvm: sys-firewall

qvm-features-id:
  qvm.features:
    - name: sys-printer
    - disable:
      - service.cups-browsed
    - enable:
      - service.cups

update_file:
  file.prepend:
    - name: '/etc/qubes/policy.d/30-user.policy'
    - text: 'qubes.Print  *  @anyvm @anyvm ask default_target=sys-printer'
