#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

if [ ! -d ~/ksk ]; then
 echo "ERROR: ~/ksk missing"
 exit 1
fi

git -C ~/ksk pull ${DIR}/.git
git -C ~/ksk push ${DIR}/.git