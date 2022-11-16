# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}

/home/user/bin:
  file.directory:
    - user: user
    - group: user
    - mode: 755

/home/user/bin/add-remote:
  file.managed:
    - source: 
      - salt://git/add-remote
    - user: user
    - group: user
    - mode: 755

/home/user/bin/git-qrexec:
  file.managed:
    - source: 
      - salt://git/git-qrexec
    - user: user
    - group: user
    - mode: 755

update_PATH:
  file.append:
    - name: '/home/user/.bashrc'
    - text: "[[ \":$PATH:\" != *\":/home/user/bin:\"* ]] && export PATH=/home/user/bin:${PATH}"

update_git_config:
  file.append:
    - name: '/home/user/.gitconfig'
    - text: |
        [protocol "ext"]
            allow = always



  
{% endif %}
