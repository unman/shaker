clone_precursor:
  qvm.template_installed:
    - name: debian-13-xfce

qvm-clone-id:
  qvm.clone:
    - name: template-reader
    - source: debian-13-xfce

'qubes-prefs default_template template-reader':
  cmd.run

{% set default_dispvm = salt['cmd.shell']('qubes-prefs default-dispvm') %}
'qvm-prefs {{ default_dispvm }} template template-reader':
  cmd.run
