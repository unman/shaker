/etc/skel/Downloads/mullvad_browser-linux-x86_64-13.0.10.tar.xz:
  file.absent

/etc/skel/Downloads/mullvad_browser-linux-x86_64-13.0.13.tar.xz:
  file.managed:
    - source: 
      - salt://mullvad/mullvad-browser-linux-x86_64-13.0.13.tar.xz
    - user: root
    - group: root
    - makedirs: True

mullvad-browser-linux-x86_64-13.0.13.tar.xz:
  archive.extracted:
    - name: /etc/skel
    - source: /etc/skel/Downloads/mullvad_browser-linux-x86_64-13.0.13.tar.xz
    - user: user

/etc/skel/.local/share/applications/start-mullvad-browser.desktop:
  file.managed:
    - source: salt://mullvad/start-mullvad-browser.desktop
    - makedirs: True
    - user: user

/etc/skel/.local/share/applications/mimeinfo.cache:
  file.managed:
    - source: salt://mullvad/mimeinfo.cache
    - makedirs: True
    - user: user

/home/user/.local/share/applications/start-mullvad-browser.desktop:
  file.managed:
    - source: salt://mullvad/start-mullvad-browser.desktop
    - makedirs: True
    - user: user

/home/user/.local/share/applications/mimeinfo.cache:
  file.managed:
    - source: salt://mullvad/mimeinfo.cache
    - makedirs: True
    - user: user

browser_dependencies:
  pkg.installed:
    - skip_suggestions: True
    - install_recommends: False
    - pkgs:
      - libdbus-glib-1-2
      - libnss3
      - desktop-file-utils
      - kdialog
