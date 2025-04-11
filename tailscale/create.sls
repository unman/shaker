qvm-present-tailscale:
  qvm.present:
    - name: sys-tailscale
    - class: AppVM
    - template: template-tailscale
    - label: green

qvm-prefs-tailscale:
  qvm.prefs:
    - name: sys-tailscale
    - memory: 400
    - maxmem: 4000
    - vcpus: 2
    - provides-network: True

qvm-features-tailscale:
  qvm.features:
    - name: sys-tailscale
    - disable:
      - service.tinyproxy
