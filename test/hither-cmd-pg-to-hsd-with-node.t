#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

assert-booktown-db

RUN hither --in=pg://$USER:h1th3r@localhost:5432/booktown --to=hsd

ok "$retval" "Make HSD from pg was successful"

like "$stdout" "name: booktown" "HSD has table name"

done_testing

# vim: set lisp sw=2:
