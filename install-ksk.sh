#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

if [ -d ~/ksk ]; then
 echo "ERROR: ~/ksk exists"
 exit 1
fi

git clone ${DIR}/.git ~/ksk