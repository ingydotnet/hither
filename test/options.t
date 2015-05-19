#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

source bin/hither

test1() {
  reset-test-vars
  IN=pg://bob:pw55@127.0.0.1/dataplace FROM=pg IN_TYPE=pg
  IN_USER=bob IN_PASSWORD=pw55 IN_HOST=127.0.0.1 IN_DBNAME=dataplace
  OUT=dataplace1.hsd TO=hsd
  run-test-vars cmd --in="$IN" --out="$OUT"
}

test2() {
  reset-test-vars
  IN=dump.hsd FROM=hsd
  OUT=path/to/django/models.py TO=django
  run-test-vars cmd --in="$IN" --out="$OUT" --to=django
}

test_vars=(
  IN FROM IN_URL IN_TYPE
  IN_USER IN_PASSWORD
  IN_HOST IN_PORT IN_DBNAME
  OUT TO OUT_URL OUT_TYPE
  OUT_USER OUT_PASSWORD
  OUT_HOST OUT_PORT OUT_DBNAME
)

run-test-vars() {
  reset-env
  get-opts "$@"
  note "Testing 'hither $*'"
  for var in ${test_vars[@]}; do
    local hvar="HITHER_$var" label=
    local val="${!var}" hval="${!hvar}"
    # echo "$hvar=$hval"
    if [ -n "$val" ]; then
      if [ -n "$hval" ]; then
        printf -v label "%-18s => '%s'" "$hvar" "$val"
        is "$hval" "$val" "$label"
      else
        fail "$hvar not set. Expected '$val'."
      fi
    else
      if [ -n "$hval" ]; then
        fail "Unexpected $hvar='$hval'."
      fi
    fi
  done
}

reset-test-vars() {
  for var in ${test_vars[@]}; do
    unset $var
  done
}

{
  i=1
  while true; do
    can "test$i" || break
    "test$((i++))"
  done
}


done_testing

# vim: set ft=sh lisp:
