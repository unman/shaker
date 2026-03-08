# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#

{% set current_release = grains['osrelease'] %}

update_uptodate:
  pkg.uptodate:
    - refresh: True

{% if grains['os_family']|lower == 'debian' %}
{% set new_release = {
  '11': '12',
  '12': '13',
  '13': '14',
  '14': '15'
} %}

{% set codename = {
  '11': 'bullseye',
  '12': 'bookworm',
  '13': 'trixie',
  '14': 'forky',
  '15': 'tbd'
} %}

{% set ext = [ 'list', 'sources' ] %}

{% for extension in ext %}
{% set repo_definitions = salt['file.find']('/etc/apt/sources.list.d/', type='f', name='*.'+extension ) %}
{% for repo in repo_definitions  %}
{{ extension }}_{{ repo }}_update_list:
  file.replace:
    - name: {{ repo }}
    - pattern: '{{ codename[current_release] }}'
    - repl: '{{ codename[new_release[current_release]] }}'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: .bak

{% endfor %}

{% set main_repo_definitions = salt['file.find']('/etc/apt/sources.list.d/', type='f', name='*.'+extension ) %}
{% for repo in main_repo_definitions  %}
/etc/apt/sources.{{ extension }}:
  file.replace:
    - name: /etc/apt/sources.{{ extension }}
    - pattern: '{{ codename[current_release] }}'
    - repl: '{{ codename[new_release[current_release]] }}'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: .bak
{% endfor %}

{% endfor %}

{% elif grains['os_family']|lower == 'redhat' %}

update_fed:
  pkg.uptodate:
    - refresh: True

update_qubes_gpg:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-qubes-4.3-primary
    - source: salt://upgrade_template/RPM-GPG-KEY-qubes-4.3-primary

update_import_gpg:
  cmd.run:
    - name: 'rpmkeys --import /etc/pki/rpm-gpg/RPM-GPG-KEY-qubes-4.3-primary'

{% endif %}
