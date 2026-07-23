# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if salt['pillar.get']('update_proxy:caching') %}

{% for repo in salt['file.find']('/etc/yum.repos.d/', name='*repo*') %}
{{ repo }}_baseurl:
    file.replace:
      - name: {{ repo }}
      - pattern: 'baseurl.*=.*https://'
      - repl: 'baseurl=http://HTTPS///'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False
{{ repo }}_metalink:
    file.replace:
      - name: {{ repo }}
      - pattern: 'metalink.*=.*https://(.*)basearch'
      - repl: 'metalink=http://HTTPS///\1basearch&protocol=http'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False

{% endfor %}


{% endif %}

executor_install:
  pkg.installed:
    - pkgs:
      - createrepo_c 
      - debootstrap 
      - devscripts 
      - dnf-plugins-core
      - dpkg-dev
      - git 
      - mock 
      - pbuilder 
      - perl-Digest-MD5 
      - perl-Digest-SHA 
      - python3-debian 
      - python3-pyyaml 
      - python3-sh 
      - reprepro 
      - rpm-build 
      - rpmdevtools 
      - systemd-udev
      - wget1 
      - which 
      - tftp-server
      - lighttpd
      - tigervnc
