#!/bin/bash


DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"
TARGET=$1


if [ ! -d ${KSK_WORKDIR}/secondary-secure ]; then
  echo "ERROR: ${KSK_WORKDIR}/secondary-secure does not exists."
  echo "Extract secondary keys first"
  exit 1
fi

# get latest  version of the restore script

cp ~/ksk/import-secondary-keys.sh ${KSK_WORKDIR}/secondary-secure/

git -C ${KSK_WORKDIR}/secondary-secure add import-secondary-keys.sh
git -C ${KSK_WORKDIR}/secondary-secure commit import-secondary-keys.sh -m"Copy latest version of import script"

if [ ! -d ${TARGET}/.git/ ]; then
  mkdir -p ${TARGET}
  git clone ${KSK_WORKDIR}/secondary-secure/.git/ ${TARGET}
fi

git -C ${TARGET} pull ${KSK_WORKDIR}/secondary-secure/.git/
