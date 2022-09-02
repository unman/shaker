syncthing_precursor:
  qvm.template_installed:
    - name: debian-11-minimal

syncthing_clone:
  qvm.clone:
    - name: template-syncthing
    - source: debian-11-minimal
