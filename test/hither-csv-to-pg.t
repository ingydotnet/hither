#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

if `pg-db-exists csv`; then
  psql -c "drop database csv" &>/dev/null || true
fi

ok "`! pg-db-exists csv`" "csv db doesn't exist"

# run() {
#   hither \
#       --in=test/dataset/csv/Seattle-Traffic-Cams.csv \
#       --out=pg://$USER:h1th3r@localhost:5432/csv?table=seattle_traffic_cams
# }; RUN
# (exit $retval) || die "$stdout$stderr"
# 
# ok "$retval" "'hither' return code is 0"
# 
# ok "`pg-db-exists csv`" "csv db exists"
# 
# run() {
#   psql -d csv -c 'select * from seattle_traffic_cams'
# }; RUN
# 
# like "$stdout" "(15 rows)" "csv/seattle_traffic_cams table has 15 rows"

done_testing

# vim: set sw=2:
