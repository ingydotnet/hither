#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

assert-booktown-db

export HITHER_DJANGO_ROOT="$(
  ls -1drt /tmp/hither-django-* 2>/dev/null | head -n1
)"

output="$(
  hither \
    --in=pg://$USER:h1th3r@localhost:5432/booktown \
    --to=django 2>/dev/null
)"

like "$output" 'class AlternateStock' \
  'Generated Django model text'

done_testing

# vim: set ft=sh lisp sw=2:
