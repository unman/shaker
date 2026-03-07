# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#

include:
  - upgrade_template.update

{% set current_release = grains['osrelease'] %}

{% if grains['os_family']|lower == 'debian' %}

upgrade_deb_new_uptodate:
  pkg.uptodate:
    - refresh: True
    - require: 
        sls: update

upgrade_deb_full_upgrade:
  cmd.run:
    - name: 'apt-get dist-upgrade -y'

{% elif grains['os_family']|lower == 'redhat' %}
{% set current_release = grains['osrelease'] %}
{% set new_release = {
  '41': '42',
  '42': '43',
  '43': '44',
  '44': '45'
} %}

{% set rpmfusion_repositories = salt['file.find']('/etc/apt/sources.list.d/', type='f', name='rpmfusion*' ) %}
{% for repo in rpmfusion_repositories %}
  pkgrepo.managed:
    - name: {{ repo }}
    - enabled: False
{% endfor %}

upgrade_purge_rpmfusion:
  cmd.run:
    - names:
      - 'dnf list | grep rpmfusion |xargs dnf remove'
    - require: 
        - sls: update
    - require_in:
        - cmd: upgrade_fed_full
#  pkg.purged:
#    - pkgs:
#      - rpmfusion-free-release
#      - rpmfusion-nonfree-release

#upgrade_fed_uptodate:
#  pkg.uptodate:
#    - refresh: True
#    - require:
#        - sls: upgrade.update

upgrade_fed_full:
  cmd.run:
    - names:
      - 'dnf upgrade -y'
      - 'dnf clean all'
      - 'dnf -y --releasever={{ new_release[current_release] }} --setopt=deltarpm=false distro-sync'

{% endif %}
