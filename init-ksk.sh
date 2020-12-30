#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

if [ -d ~/gpg-primary ]; then
  echo "ERROR: ~/gpg-primary exists.  you must delete the directory to create a new primary key"
  exit 1
fi

mkdir ~/gpg-primary
chmod 700 ~/gpg-primary
rm -rf ~/ksk-secure
mkdir ~/ksk-secure
chmod 700 ~/ksk-secure

echo "GnuPG needs to construct a user ID to identify your key."
read -p "Enter your real name (ex John Smith): " NAME
read -p "Enter your email address (ex john@smith.com)" EMAIL

cat >~/ksk-secure/ksk.conf <<EOL
export KSK_NAME="${NAME}"
export KSK_EMAIL="${EMAIL}"
EOL

cp ${DIR}/gpg.conf ~/gpg-primary/

gpg --homedir ~/gpg-primary/ \
  --quick-generate-key "${NAME} <${EMAIL}>" default

KEY_ID=$(gpg --homedir ~/gpg-primary --with-colons --list-key "${EMAIL}" | grep -m 1 pub | cut -d: -f 5)
FGPR=$(gpg --homedir ~/gpg-primary --with-colons --list-key "${EMAIL}" | grep -m 1 fpr | cut -d : -f 10)

cat >>~/ksk-secure/ksk.conf <<EOL
export KSK_ID=0x${KEY_ID}
export KSK_FGPR=${FGPR}
EOL
