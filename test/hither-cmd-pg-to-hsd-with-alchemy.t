#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

assert-booktown-db

  pass
  done_testing
  exit

RUN hither \
  --in=pg://$USER:h1th3r@localhost:5432/booktown \
  --to=hsd \
  --with=alchemy

ok "$retval" "Make HSD from pg with Django was successful"

like "$stdout" "name: booktown" "HSD has table name"

done_testing

# vim: set lisp sw=2:
