#!/usr/bin/env bash

source "$(dirname $0)/setup"
source "$(dirname $0)/setup.d/django"
use Test::More

output="$(
  cd "$django_dir"
  sqlite3 -line db.sqlite3 '.dump data_viewer_trafficcams'
)"
is `echo "$output" | wc -l` 4 \
  'New db dump is 4 lines'

done_testing 1

# vim: set ft=sh:
