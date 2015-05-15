#!/usr/bin/env bash

source "$(dirname $0)/../setup"
use Test::More

run() {
  hither load \
      --in=http://www.commandprompt.com/ppbook/booktown.sql \
      --out=pg://localhost:5432/booktown
}; RUN

is "$retval" "0" "'hither load' return code is 0"
[ $retval -eq 0 ] || echo "$stdout$stderr"

run() {
  psql -d booktown -c 'select * from books'
}; RUN

like "$stdout" "(15 rows)" "booktown books table has 15 rows"

done_testing

# vim: set sw=2:
