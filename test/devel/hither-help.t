#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

h_output="$(hither -h)"
help_output="$(hither --help)"

is `echo "$h_output" | wc -l` 14 \
  '-h output is 14 lines'
is "$h_output" "$help_output" \
  '-h is same output as --help'
like "$h_output" 'Usage:' \
  '-h contains Usage:'
like "$h_output" 'Hither Options:' \
  '-h contains Hither Options:'

done_testing 4

# vim: set ft=sh:
