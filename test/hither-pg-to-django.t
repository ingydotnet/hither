#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

assert-booktown-db

export HITHER_DJANGO_ROOT=/tmp/hither-django

output="$(
  hither \
    --in=pg://$USER:h1th3r@localhost:5432/booktown \
    --to=django
)"

like "$output" 'class AlternateStock' \
  'Generated Django model text'

done_testing

# vim: set ft=sh lisp sw=2:
