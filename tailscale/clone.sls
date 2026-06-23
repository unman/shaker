tailscale_precursor:
  qvm.template_installed:
    - name: debian-13-minimal

tailscale_clone:
  qvm.clone:
    - name: template-tailscale
    - source: debian-13-minimal
