#!/usr/bin/env bash

source "$(dirname $0)/devel/setup"
use Test::More

source bin/hither

test1() {
  IN=pg://bob:pw55@127.0.0.1/dataplace FROM=pg IN_TYPE=pg
  IN_USER=bob IN_PASSWORD=pw55 IN_HOST=127.0.0.1 IN_DBNAME=dataplace
  run-test-vars cmd --in="$IN"
}

hither_vars=(
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
  for var in ${hither_vars[@]}; do
    local hvar="HITHER_$var" label=
    local val="${!var}" hval="${!hvar}"
    if [ -n "$val" ]; then
      if [ -n "$hval" ]; then
        printf -v label "%-14s => '%s'" "$hvar" "$val"
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

{
  for i in {1..1}; do
    "test$i"
  done
}


done_testing

# vim: set ft=sh:
