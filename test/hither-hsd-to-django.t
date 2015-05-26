#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

assert-booktown-db

run() {
  hither --in=test/dataset/hsd/booktown.hsd --to=django
}; RUN

ok "$retval" "Make Django model from HSD was successful"
(exit $retval) || diag "$stdout$stderr"

# like "$stdout" "name: booktown" "HSD has table name"
# die ">>>>$stdout<<<<"

done_testing

# vim: set lisp sw=2:
