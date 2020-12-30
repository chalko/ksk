#!/bin/bash


DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"
TARGET=$1


if [ ! -d ~/ksk-secure ]; then
  echo "ERROR: ~/ksk-secure does not exists."
  echo "Create or restore primary keys first"
  exit 1
fi

# get latest  version of the restore script

cp ~/ksk/restore-primary-keys.sh ~/ksk-secure/

git -C ~/ksk-secure add restore-primary-keys.sh
git -C ~/ksk-secure commit restore-primary-keys.sh -m"Copy latest version of restore script"

if [ ! -d ${TARGET} ]; then
  mkdir -p ${TARGET}
  git clone ~/ksk-secure/.git/ ${TARGET}
fi

git -C ${TARGET} pull ~/ksk-secure/.git/
