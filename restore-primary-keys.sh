#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

source ${DIR}/ksk.conf

PRIMARY_DIR=/dev/shm/ksk/gpg-primary
KSK_SECURE_DIR=/dev/shm/ksk/ksk-secure

if [ -d ~/gpg-primary ]; then
  echo "ERROR: ${PRIMARY_DIR} exists.  you must delete the directory to create a new primary key"
  exit 1
fi

mkdir -p ${PRIMARY_DIR}
chmod 700 ${PRIMARY_DIR}
rm -rf ${KSK_SECURE_DIR}
mkdir -p ${KSK_SECURE_DIR}
chmod 700 ${KSK_SECURE_DIR}

git clone ${DIR}/.git ${KSK_SECURE_DIR}

cp /${KSK_SECURE_DIR}/gpg.conf ${PRIMARY_DIR}
gpgconf --homedir ${PRIMARY_DIR} --kill gpg-agent
gpg --homedir ${PRIMARY_DIR} --batch --import ${DIR}/$KSK_ID.public.gpg-key
gpg --homedir ${PRIMARY_DIR} --batch --import ${DIR}/$KSK_ID.private.gpg-key
gpg --homedir ${PRIMARY_DIR} --import-ownertrust ${KSK_SECURE_DIR}/ownertrust.txt




