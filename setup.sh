#!/bin/bash

set -e

export PATH=/usr/local/bin:$PATH

if [[ ! -x /usr/bin/gcc ]]; then
  echo "Info | Install | xcode cli tools"
  xcode-select --install
fi

if [[ ! -x /usr/local/bin/brew ]]; then
  echo "Info | Install | homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [[ -z `brew list --versions python` ]]; then
  echo "Info | Install | python"
  brew install python
  echo "Info | Install | pywinrm"
  pip install "pywinrm>=0.3.0"
fi

if [[ ! -x /usr/local/bin/ansible ]]; then
  echo "Info | Install | ansible"
  brew install ansible
fi

# OBJC_DISABLE_INITIALIZE_FORK_SAFETY needs to be set due to an 
# known issue. see https://github.com/ansible/ansible/issues/32499
# for further information.
echo "Info | Bug-Qickfix | export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

echo "Running ansible-playbook script..."
ansible-playbook -i hosts playbook.yml