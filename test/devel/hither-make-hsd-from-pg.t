#!/usr/bin/env bash

source "$(dirname $0)/setup"
use Test::More

hither load \
    --in=http://www.commandprompt.com/ppbook/booktown.sql \
    --out=pg://ingy:qwerty@localhost:5432/booktown #?table=books

pass OK

done_testing

# vim: set sw=2:
