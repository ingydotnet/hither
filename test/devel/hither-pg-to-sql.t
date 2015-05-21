#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

assert-booktown-db

run() {
  hither --in=pg://localhost/booktown --to=sql
}; RUN

ok "$retval" "Make Django model from HSD was successful"
(exit $retval) || diag "$stdout$stderr"

like "$stdout" "PostgreSQL database dump" "Database dump worked"
unlike "$stdout" "COPY" "Dump is schema only"

done_testing

# vim: set lisp sw=2:
