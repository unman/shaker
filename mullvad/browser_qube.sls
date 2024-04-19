extract_mullvad-browser:
  archive.extracted:
    - name: /home/user/
    - source: /etc/skel/Downloads/mullvad_browser-linux-x86_64-13.0.13.tar.xz
    - user: user

/home/user/.local/share/applications/start-mullvad-browser.desktop:
  file.managed:
    - source: salt://mullvad/start-mullvad-browser.desktop
    - makedirs: True
    - user: user

#################################
cp mullvad-browser/Data/profiles.ini ~
cp -rv mullvad-browser/Data/*-release .
rm -rf mullvad-browser/
tar xf QubesIncoming/unman/mullvad-browser-linux-x86_64-13.0.13.tar.xz 
mkdir mullvad-browser/Data
cp profiles.ini mullvad-browser/Data
mv  *default-release mullvad-browser/Data/

