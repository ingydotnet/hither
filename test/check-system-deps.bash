#!/usr/bin/env bash

set -e

PATH="\
$PWD/ext/bashplus/bin:\
$PATH
" source ext/bashplus/bin/bash+ :std

OK=true

coffee_install='npm install -g coffee-script'
node_install='https://github.com/creationix/nvm#manual-install'
nvm_install='https://github.com/creationix/nvm#manual-install'
pg_buildext_install='sudo apt-get install postgresql-server-dev-all'
plenv_install='https://github.com/tokuhirom/plenv#installation'
psql_install='sudo apt-get install postgresql'
psql_user_install='./eg/create-test-user-pg'
Python_h_install='sudo apt-get install python2.7-dev'
virtualenv_install='sudo apt-get install python-virtualenv'

YAML__XS_install='cpanm YAML::XS'

missing() {
  echo "Missing dependency: '$dep'."
  local var="$dep"
  local var="${var##*/}"
  local var="${var//:/_}"
  local var="${var//./_}"
  local var="${var// /_}"
  install_var="${var}_install"
  if [ -n "${!install_var}" ]; then
    echo "    try: ${!install_var}"
  fi
  OK=false
}

# XXX nvm not working with type
for dep in node coffee plenv psql pg_buildext virtualenv; do
  if ! ( type $dep &>/dev/null ); then
    missing
  fi
done

if ( type psql &>/dev/null ); then
  if ! (psql -c '\l' &>/dev/null ); then
    dep='psql user'
    missing
  fi
fi

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

for dep in /usr/include/python2.7/Python.h; do
  if [ ! -e "$dep" ]; then
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
