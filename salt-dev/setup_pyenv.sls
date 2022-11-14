# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

cmd-run:
  - name: |
      pyenv install 3.7.0
      pyenv virtualenv 3.7.0 salt
      pyenv activate salt

{% endif %}
