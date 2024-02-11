/etc/skel/Downloads/mullvad_browser-linux-x86_64-13.0.9.tar.xz:
  file.managed:
    - source: 
      - salt://mullvad/mullvad-browser-linux-x86_64-13.0.9.tar.xz
    - user: root
    - group: root
    - makedirs: True

mullvad-browser-linux-x86_64-13.0.9.tar.xz:
  module.run:
    - name: archive.tar
    - tarfile: /etc/skel/Downloads/mullvad_browser-linux-x86_64-13.0.9.tar.xz
    - options: -x -f
    - runas: root
    - dest: /etc/skel


