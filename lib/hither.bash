set -e

source "$(cd -P `dirname $BASH_SOURCE` && pwd -P)/../lib/bash+.bash"

require-var() {
  var="$1"
  [ -n "$var" ] ||
    die "Command requires '$var'"
}

set-env-vars-pg() {
  [ -z "$HITHER_IN_DBNAME" ] ||
    export PGDATABASE="$HITHER_IN_DBNAME"
}

read-input() {
  if [ -n "$HITHER_IN_URL" ]; then
    curl -Ls "$HITHER_IN_URL"
  elif [ -n "$HITHER_IN" ]; then
    cat "$HITHER_IN"
  else
    cat
  fi
}

write-output() {
  if [ -n "$HITHER_OUT" ]; then
    cat > "$HITHER_OUT"
  else
    cat
  fi
}

pg-db-exists() {
  pg_dump -s "${1:-undefined}" &>/dev/null
}

set-hither-vars-from-in-out-vars() {
  for v in DBNAME HOST PORT USER PASSWORD; do
    hv=HITHER_$v iv=HITHER_IN_$v
    if [ -n "${!iv}" ]; then
      printf -v $hv ${!iv}
      export $hv
    fi
  done
}

#------------------------------------------------------------------------------
# Django Support
#------------------------------------------------------------------------------
django-run-command() {
  local temp_dir=
  django-env-setup
  (
    cd $HITHER_DJANGO_ROOT/hither
    "$@"
  )
  django-env-teardown
}

django-env-setup() {
  if [ -n "$HITHER_DJANGO_ROOT" ]; then
    export HITER_DB
    local virtualenv=$HITHER_DJANGO_ROOT
    temp_dir=false
  else
    local virtualenv=$(mktemp -d -t hither-django-XXXXXXXX)
    export HITHER_DJANGO_ROOT="$virtualenv"
    temp_dir=true
  fi

  local django_project=hither
  local django_root=$virtualenv/$django_project/$django_project

  if [ ! -f "$virtualenv/bin/python" ]; then
    virtualenv $virtualenv &>/dev/null
  fi

  source $virtualenv/bin/activate

  django_admin_path=$(which django-admin 2>/dev/null) || true
  if [ -z "$django_admin_path" ] ||
     [[ ! "$django_admin_path" =~ $virtualenv ]]; then
    (
      pip install --upgrade pip
      pip install django
      pip install pyyaml
      pip install psycopg2
    ) &>/tmp/hither-out || django-setup-fail
  fi

  if [ ! -e $django_root ]; then
    (
      cd $virtualenv
      django-admin startproject $django_project
    ) &>/tmp/hither-out || django-setup-fail
  fi

  cp $(dirname $0)/../share/django-settings.py $django_root/settings.py
  cp $HITHER_LIB/hither*.py $HITHER_DJANGO_ROOT/lib/python2.7/site-packages/django/core/management/commands/

  source $HITHER_DJANGO_ROOT/bin/activate
}

django-env-teardown() {
  if $temp_dir; then
    cat <<... >&2
This work was done in a Python virtualenv that needed to be set up and
configured. To reuse this environment, enter this line:

  export HITHER_DJANGO_ROOT="$hither_django_root"

...
  fi
}

django-setup-fail() {
  cat /tmp/hither-out
  die "Django env setup failed"
}
