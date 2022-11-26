clone_precursor:
  qvm.template_installed:
    - name: debian-11

qvm-clone-id:
  qvm.clone:
    - name: template-reader
    - source: debian-11

'qubes-prefs default_template  template-reader':
  cmd.run

'qvm-prefs debian-11-dvm template template-reader':
  cmd.run
