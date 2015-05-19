set -e
source "$(cd -P `dirname $BASH_SOURCE` && pwd -P)/../lib/bash+.bash"

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
  unset out err ret
  eval "$(
    run > >(out=$(cat); typeset -p out) \
      2> >(err=$(cat); typeset -p err);
    ret=$?; typeset -p ret
  )"
  stdout=$out
  stderr=$err
  retval=$ret
}
