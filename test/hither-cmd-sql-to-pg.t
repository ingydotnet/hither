#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

if `pg-db-exists booktown`; then
  psql -c "drop database booktown" &>/dev/null || true
fi

ok "`! pg-db-exists booktown`" "booktown db doesn't exist"

RUN hither \
  --in=test/dataset/pg/booktown-schema-dump.sql \
  --out=pg://$USER:h1th3r@localhost:5432/booktown

ok "$retval" "'hither' return code is 0"

{
  cat test/dataset/pg/booktown-data-dump.sql |
    psql booktown &>/dev/null
}

ok "`pg-db-exists booktown`" "booktown db exists"

RUN psql -d booktown -c 'select * from books'

like "$stdout" "(15 rows)" "booktown/books table has 15 rows"

done_testing

# vim: set sw=2:
