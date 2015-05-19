#!/usr/bin/env bash

source "$(dirname $0)/../setup"
source "$(dirname $0)/setup"
use Test::More

assert-booktown-db

run() {
  hither --in=pg://$USER:h1th3r@localhost:5432/booktown --to=hsd
}; RUN

ok "$retval" "Make HSD from pg was successful"
(exit $retval) || diag "$stdout$stderr"

like "$stdout" "name: booktown" "HSD has table name"

done_testing

# vim: set lisp sw=2:
