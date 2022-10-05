precursor_gw:
  qvm.template_installed:
    - name: whonix-gw-16

precursor:
  qvm.template_installed:
    - name: whonix-ws-16

monerod-ws:
  qvm.present:
    - name: monerod-ws
    - template: whonix-ws-16
    - label: red

monerod-ws_prefs:
  qvm.prefs:
    - name: monerod-ws
    - netvm: sys-whonix
    - memory: 400
    - maxmem: 4000
    - vcpus: 2
    - template_for_dispvms: False
    - include_in_backups: True

'qvm-volume extend monerod-ws:private 100G' :
  cmd.run

monerod-ws_features:
  qvm.features:
    - name: monerod-ws
    - enable:
      - service.user.monerod

monero-wallet:
  qvm.present:
    - name: monero-wallet-ws
    - template: whonix-ws-16
    - class: AppVM
    - netvm: none
    - label: green

monero-wallet_prefs:
  qvm.prefs:
    - name: monero-wallet-ws
    - autostart: false
    - include_in_backups: True
    - netvm: none


monero-wallet-ws_features:
  qvm.features:
    - name: monero-wallet-ws
    - set:
      - menu-items: "monero-gui.desktop xfce4-terminal.desktop"


update_monero_policy:
  file.prepend:
    - name: /etc/qubes/policy.d/30-user.policy
    - text: 'user.monerod  *  monero-wallet-ws  monerod-ws  allow'
