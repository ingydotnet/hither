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

RUN() {
  local tmp=$(mktemp)
  retval=0
  stdout=$(run 2>$tmp) || retval=$?
  stderr=$(< $tmp)
  rm "$tmp"
}
