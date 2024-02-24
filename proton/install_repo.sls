{% if salt['pillar.get']('update_proxy:caching') %}
/etc/apt/sources.list.d/protonvpn-stable.list:
  file.managed:
    - source:
      - salt://proton/protonvpn-stable.list  
{% endif %}

/tmp/protonvpn-stable-release_1.0.3-2_all.deb:
  file.managed:
    - source:
      - salt://proton/protonvpn-stable-release_1.0.3-2_all.deb

'dpkg -i --force-confold /tmp/protonvpn-stable-release_1.0.3-2_all.deb ':
  cmd.run
