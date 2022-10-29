# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

pyenv_cloned:
  git.cloned:
    - name: https://github.com/pyenv/pyenv.git 
    - target: /home/user/.pyenv
    - user: user

pyenv-virtual_cloned:
  git.cloned:
    - name: https://github.com/pyenv/pyenv-virtualenv.git 
    - target: /home/user/.pyenv/plugins/pyenv-virtualenv
    - user: user

{% set current_path = salt['environ.get']('PATH', '/usr/local/bin:/usr/bin:/bin') %}

cmd-run:
  cmd.script:
    - source: salt://pyenv/setup.sh
    - cwd: /home/user/
    - runas: user
    - env:
      - PATH: {{ ['/home/user/.pyenv/bin', current_path]|join(':') }}

{% endif %}
