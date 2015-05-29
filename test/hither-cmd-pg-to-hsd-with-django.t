#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

assert-booktown-db

export HITHER_DJANGO_ROOT="$(
  ls -1drt /tmp/hither-django-* 2>/dev/null | head -n1
)"

RUN hither \
  --in=pg://$USER:h1th3r@localhost:5432/booktown \
  --to=hsd \
  --with=django

ok "$retval" "Make HSD from pg with Django was successful"

like "$stdout" "name: booktown" "HSD has table name"

done_testing

# vim: set lisp sw=2:
