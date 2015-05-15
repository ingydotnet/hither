#!/usr/bin/env bash

source "$(dirname $0)/../setup"
use Test::More

h_output="$(hither -h || true)"
help_output="$(hither --help || true)"

is `echo "$h_output" | wc -l` 22 \
  '-h output is 14 lines'
is "$h_output" "$help_output" \
  '-h is same output as --help'
like "$h_output" 'usage:' \
  '-h contains usage:'
like "$h_output" 'Options:' \
  '-h contains Options:'

done_testing 4

# vim: set ft=sh:
