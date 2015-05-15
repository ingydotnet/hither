#!/usr/bin/env bash

source "$(dirname $0)/../setup"
use Test::More

if `pg-db-exists booktown`; then
  psql -c "drop database booktown" &>/dev/null || true
fi

ok "`! pg-db-exists booktown`" "booktown db doesn't exist"

run() {
  hither \
      --in=test/devel/booktown.sql \
      --out=pg://localhost:5432/booktown
}; RUN

ok "$retval" "'hither load' return code is 0"
(exit $retval) || echo "$stdout$stderr"

ok "`pg-db-exists booktown`" "booktown db exists"

run() {
  psql -d booktown -c 'select * from books'
}; RUN

like "$stdout" "(15 rows)" "booktown/books table has 15 rows"

done_testing

# vim: set sw=2:
