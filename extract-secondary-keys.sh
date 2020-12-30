#!/bin/bash


DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

if [ ! -d ~/gpg-primary ]; then
  echo "ERROR: ~/gpg-primary does not exist exists. "
  echo "Create or restore primary keys first"
  exit 1
fi

if [ ! -d ~/ksk-secure/ ]; then
  echo "ERROR: ~/ksk-secure does not exist exists. "
  echo "Create or restore primary keys first"
  exit 1
fi

source ~/ksk-secure/ksk.conf

if [ ! -d ~/secondary-secure ]; then
  mkdir ~/secondary-secure
  chmod 700 ~/secondary-secure
  git -C ~/secondary-secure init
fi

rm -rf ~/gpg-secondary
mkdir ~/gpg-secondary
chmod 700 ~/gpg-secondary


# get latest  version of the import script

cp ~/ksk/import-secondary-keys.sh ~/secondary-secure
git -C ~/secondary-secure add import-secondary-keys.sh
git -C ~/secondary-secure commit import-secondary-keys.sh -m"Copy latest version of import script"

gpg --homedir ~/gpg-secondary/ --import ~/ksk-secure/$KSK_ID.public.gpg-key
gpg --homedir ~/gpg-secondary/ --import ~/ksk-secure/$KSK_ID.sub-private.gpg-key
gpg --homedir ~/gpg-secondary/ --import-ownertrust  ~/ksk-secure/ownertrust.txt

gpg --homedir ~/gpg-secondary/ --change-passphrase $KSK_ID

gpg --homedir ~/gpg-secondary/ \
    --armor --export-secret-subkeys $KSK_ID \
    > ~/secondary-secure/$KSK_ID.sub-private.gpg-key


cp ~/ksk-secure/$KSK_ID.public.gpg-key ~/secondary-secure
cp ~/ksk-secure/ownertrust.txt ~/secondary-secure
git -C ~/secondary-secure add $KSK_ID.public.gpg-key $KSK_ID.sub-private.gpg-key ownertrust.txt
git -C ~/secondary-secure commit -m"Export of the secondary keys for for ${KSK_NAME} <${KSK_EMAIL}>"





