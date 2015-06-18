#!/usr/bin/env bash

set -e

PATH="\
$PWD/ext/bashplus/bin:\
$PATH
" source ext/bashplus/bin/bash+ :std

OK=true

coffee_install='npm install -g coffee-script'
node_install='https://github.com/creationix/nvm#usage'
nvm_install='https://github.com/creationix/nvm#manual-install'
plenv_install='https://github.com/tokuhirom/plenv#installation'
psql_install='sudo apt-get install postgresql'
virtualenv_install='sudo apt-get install python-virtualenv'

YAML__XS_install='cpanm YAML::XS'

missing() {
  echo "Missing dependency: '$dep'."
  local var="${dep//:/_}"
  install_var="${var}_install"
  if [ -n "${!install_var}" ]; then
    echo "    try: ${!install_var}"
  fi
  OK=false
}

# XXX nvm not working with type
for dep in node coffee plenv psql virtualenv; do
  if ! ( type $dep &>/dev/null ); then
    die
    missing
  fi
done

if ( type node &>/dev/null ); then
  for dep in js-yaml pg-json-schema-export; do
    if ! ( node -e 'require("'"$dep"'");' &>/dev/null ); then
      missing
    fi
  done
fi

for dep in YAML::XS; do
  if ! ( perl -M$dep -e1 &>/dev/null ); then
    missing
  fi
done

if $OK; then
  exit 0
else
  echo
  echo "Fix the missing dependencies."
  echo
  exit 1
fi
