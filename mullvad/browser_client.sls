{% for archive in salt['file.find']('/home/user/Downloads/', name='mullvad_browser*') %}
{{ archive }}_remove:
  file.absent:
    - name: {{ archive }}
{% endfor %}

/home/user/Downloads/mullvad_browser-linux-x86_64-13.0.16.tar.xz:
  file.managed:
    - source:
      - salt://mullvad/mullvad-browser-linux-x86_64-13.0.16.tar.xz
    - user: root
    - group: root
    - makedirs: True

remove_mullvad_browser:
  file.absent:
    - name: /home/user/mullvad-browser

mullvad-browser-linux-x86_64-13.0.16.tar.xz:
  archive.extracted:
    - name: /home/user
    - source: /home/user/Downloads/mullvad_browser-linux-x86_64-13.0.16.tar.xz
    - user: user
