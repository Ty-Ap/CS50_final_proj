#!/bin/bash

#Made by ty

source $(dirname $0)/../scripts/initTool.sh "Usage $0 <domain>" $@ 


out=$(node $BASE_PATH/tools/techSnoop.js "$@")
echo $out

$BASE_PATH/scripts/queries.py --ip "$(dig +short "$1" | head -n 1)" --domain "$1" --build "$out"

