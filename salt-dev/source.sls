# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

salt_clone:
  git.latest:
    name: https://github.com/saltstack/salt.git
    target: /home/user/salt
    user: user
    depth: 1
    origin: salt

'python -m pip install pre-commit nox':
  cmd.run

pre-commit install:
  cmd.run

{% endif %}
