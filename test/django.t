#!/usr/bin/env bash

source "$(dirname $0)/setup"
source "$(dirname $0)/setup.d/django" # -R
use Test::More

# We are cd'd into to django virtualenv directory:

#------------------------------------------------------------------------------
# Create a starter model:
(
  cp src/share/models-1.py data_viewer/models.py
  ./manage.py makemigrations
  ./manage.py migrate
) &> /dev/null

# Dump sqlite3 db and test output:
{
  output="$(
    sqlite3 -line db.sqlite3 '.dump data_viewer_trafficcams'
  )"
  is `echo "$output" | wc -l` 4 \
    'New db dump is 4 lines'
  like "$output" 'CREATE TABLE' \
    'New db creates table'
  like "$output" 'data_viewer_trafficcams' \
    'New db creates data_viewer_trafficcams table'
  unlike "$output" 'camera_labels' \
    'Column is not yet called "camera_labels"'
}

#------------------------------------------------------------------------------
# Import the fixture data into the database:
(
  ./manage.py loaddata data_viewer/fixtures/Seattle-Traffic-Cams.yaml
) &> /dev/null

# Dump sqlite3 db and test output:
{
  output="$(
    sqlite3 -line db.sqlite3 '.dump data_viewer_trafficcams'
  )"
  is `echo "$output" | wc -l` 139 \
    'New db dump is 139 lines'
  is `echo "$output" | grep INSERT | wc -l` 135 \
    '135 INSERT lines'
}

#------------------------------------------------------------------------------
# Change a column name in table:
(
  cp src/share/models-2.py data_viewer/models.py
  echo yes | ./manage.py makemigrations
  ./manage.py migrate
) &> /dev/null

# Dump sqlite3 db and test output:
{
  output="$(
    sqlite3 -line db.sqlite3 '.dump data_viewer_trafficcams' |
    grep -v INSERT
  )"
  like "$output" 'CREATE TABLE' \
    'New db creates table'
  like "$output" 'data_viewer_trafficcams' \
    'New db creates data_viewer_trafficcams table'
  like "$output" 'camera_labels' \
    'Column is called "camera_labels"'
}

done_testing

# vim: set ft=sh:
