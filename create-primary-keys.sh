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
read -e -p "Enter your real name (ex John Smith): " NAME
read -e -p "Enter your email address (ex john@smith.com)" EMAIL

cat >~/ksk-secure/ksk.conf <<EOL
export KSK_NAME="${NAME}"
export KSK_EMAIL="${EMAIL}"
EOL

cp ${DIR}/gpg.conf ~/gpg-primary/
cp ${DIR}/gpg.conf ~/ksk-secure/

gpg --homedir ~/gpg-primary/ \
  --quick-generate-key "${NAME} <${EMAIL}>" default

KSK_ID=$(gpg --homedir ~/gpg-primary --with-colons --list-key "${EMAIL}" | grep -m 1 pub | cut -d: -f 5)
KSK_FGPR=$(gpg --homedir ~/gpg-primary --with-colons --list-key "${EMAIL}" | grep -m 1 fpr | cut -d : -f 10)

cat >>~/ksk-secure/ksk.conf <<EOL
export KSK_ID=0x${KSK_ID}
export KSK_FGPR=${KSK_FGPR}
EOL

cp ~/gpg-primary/openpgp-revocs.d/${KSK_FGPR}.rev \
  ~/ksk-secure/${KSK_FGPR}.rev

# Create subkeys
gpg --homedir ~/gpg-primary --quick-add-key $KSK_FGPR default sign
gpg --homedir ~/gpg-primary --quick-add-key $KSK_FGPR default auth


# Export primary

gpg --homedir ~/gpg-primary --armor --export $KSK_ID > ~/ksk-secure/0x$KSK_ID.public.gpg-key
gpg --homedir ~/gpg-primary --armor --export-secret-keys $KSK_ID > ~/ksk-secure/0x$KSK_ID.private.gpg-key
gpg --homedir ~/gpg-primary --export-ownertrust > ~/ksk-secure/ownertrust.txt


cd  ~/ksk-secure
git init
git add *
git commit -a -m"Initial creation for primary keys for ${NAME} <${EMAIL}>"
cd ${CWD}
