#!/bin/bash


if [ -z "$1" ]; then
    echo "Usage $0 <domain>"
    exit 1
fi

domain=$1

node scripts/techSnoop.js "$@"