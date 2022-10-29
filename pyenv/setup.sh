#!/bin/bash
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /home/user/.bashrc
echo 'export PYENV_ROOT=/home/user/.pyenv' >> /home/user/.bashrc
echo 'command -v pyenv >/dev/null|| export PATH="$HOME/.pyenv/bin:$PATH" '>> /home/user/.bashrc
echo 'eval "$(pyenv init -)" '>> /home/user/.bashrc
echo 'eval "$(pyenv virtualenv-init -)" '>> /home/user/.bashrc


