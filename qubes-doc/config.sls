/home/user/.gitconfig:
  file.managed:
    - source:
      - salt://qubes-doc/doc-gitconfig
    - user: user
    - group: user

/rw/config/gpg-split-domain:
  file.managed:
    - source:
      - salt://qubes-doc/split-gpg-config
    - user: root
    - group: root

'gem update --system':
  cmd.run:
    - user: root

'gem install jekyll bundler':
  cmd.run:
    - user: user

'gem install sass --force':
  cmd.run:
    - user: user

'gem install github-pages':
  cmd.run:
    - user: user

/home/user/install-poetry.py:
  file.managed:
    - source:
      - salt://qubes-doc/install-poetry.py
    - user: user
    - group: user

/home/user/build_docs:
  file.managed:
    - source:
      - salt://qubes-doc/build_docs
    - user:  user
    - group: user
    - mode:  744

/home/user/build_site:
  file.managed:
    - source:
      - salt://qubes-doc/build_site
    - user:  user
    - group: user
    - mode:  744

https://github.com/QubesOS/qubesos.github.io.git:
  git.latest:
    - name:   https://github.com/QubesOS/qubesos.github.io.git
    - target: /home/user/qubesos.github.io
    - user:   'user'
    - submodules: True

https://github.com/QubesOS/qubes-doc:
  git.latest:
    - name:   https://github.com/QubesOS/qubes-doc
    - target: /home/user/qubes-doc
    - user:   user
    - submodules: True

add_webrick:
  file.append:
    - name: /home/user/qubesos.github.io/Gemfile
    - text: gem 'webrick'

install_poetry:
  cmd.script:
    - source: '/home/user/install-poetry.py'
    - runas: user

'poetry install':
  cmd.run:
    - cwd: '/home/user/qubes-doc'
    - runas: 'user'
