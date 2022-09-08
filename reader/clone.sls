clone_precursor:
  qvm.template_installed:
    - name: debian-11

qvm-clone-id:
  qvm.clone:
    - name: template-reader
    - source: debian-11

change_default:
  'qubes-prefs default_template  template-reader':
    cmd.run

change_template:
  'qvm-prefs debian-11-dvm template template-reader':
    cmd.run
