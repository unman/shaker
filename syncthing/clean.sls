# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

syncthing_down:
  qvm.shutdown:
    - name: syncthing
    - flags: 
      - force

syncthing_revert_policy:
  file.replace:
    - name: /etc/qubes/policy.d/30-user.policy
    - pattern: 'qubes.Syncthing.*'
    - repl: ''

syncthing_default_policy:
  file.prepend:
    - name: /etc/qubes/policy.d/30-user.policy
    - text: 'qubes.Syncthing  *  @anyvm  @anyvm  deny'
    - makedirs: True
