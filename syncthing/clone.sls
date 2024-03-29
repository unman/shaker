syncthing_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

syncthing_clone:
  qvm.clone:
    - name: template-syncthing
    - source: debian-12-minimal

echo -e 'syncthing-start.desktop\nsyncthing-ui.desktop\nxterm.desktop' | qvm-appmenus --set-whitelist=- --update template-syncthing:
  cmd.run:
    - runas: user
    - require:
      - qvm: template-syncthing
