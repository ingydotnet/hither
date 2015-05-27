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

FAIL=true
MERGE=false
SAY=false
CMD=run
RUN() {
  [ $# -gt 0 ] && local cmd=("$@") || local cmd=($CMD)
  if $SAY; then
    echo ">>> $cmd"
  fi
  retval=0
  if $MERGE; then
    stdout=$("${cmd[@]}" 2>&1) || retval=$?
    stderr=
  else
    local tmp=$(mktemp)
    stdout=$("${cmd[@]}" 2>$tmp) || retval=$?
    stderr=$(< $tmp)
    rm "$tmp"
  fi
  if $FAIL && [ $retval -ne 0 ]; then
    die "Command failed:"$'\n'"$stdout$stderr"
  fi
}
