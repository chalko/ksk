#!/bin/bash


DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

if [ ! -d ${KSK_WORKDIR}/gpg-primary ]; then
  echo "ERROR: ${KSK_WORKDIR}/gpg-primary does not exist exists. "
  echo "Create or restore primary keys first"
  exit 1
fi

if [ ! -d ${KSK_WORKDIR}/ksk-secure/ ]; then
  echo "ERROR: ${KSK_WORKDIR}/ksk-secure does not exist exists. "
  echo "Create or restore primary keys first"
  exit 1
fi

source ${KSK_WORKDIR}/ksk-secure/ksk.conf

if [ ! -d ${KSK_WORKDIR}/secondary-secure ]; then
  mkdir ${KSK_WORKDIR}/secondary-secure
  chmod 700 ${KSK_WORKDIR}/secondary-secure
  git -C ${KSK_WORKDIR}/secondary-secure init
fi

rm -rf ${KSK_WORKDIR}/gpg-secondary
mkdir ${KSK_WORKDIR}/gpg-secondary
chmod 700 ${KSK_WORKDIR}/gpg-secondary


# get latest  version of the import script

cp ~/ksk/import-secondary-keys.sh ${KSK_WORKDIR}/secondary-secure
git -C ${KSK_WORKDIR}/secondary-secure add import-secondary-keys.sh
git -C ${KSK_WORKDIR}/secondary-secure commit import-secondary-keys.sh -m"Copy latest version of import script"

gpg --homedir ${KSK_WORKDIR}/gpg-secondary/ --import ${KSK_WORKDIR}/ksk-secure/$KSK_ID.public.gpg-key
gpg --homedir ${KSK_WORKDIR}/gpg-secondary/ --import ${KSK_WORKDIR}/ksk-secure/$KSK_ID.sub-private.gpg-key
gpg --homedir ${KSK_WORKDIR}/gpg-secondary/ --import-ownertrust  ${KSK_WORKDIR}/ksk-secure/ownertrust.txt

gpg --homedir ${KSK_WORKDIR}/gpg-secondary/ --change-passphrase $KSK_ID

gpg --homedir ${KSK_WORKDIR}/gpg-secondary/ \
    --armor --export-secret-subkeys $KSK_ID \
    > ${KSK_WORKDIR}/secondary-secure/$KSK_ID.sub-private.gpg-key


cp ${KSK_WORKDIR}/ksk-secure/$KSK_ID.public.gpg-key ${KSK_WORKDIR}/secondary-secure
cp ${KSK_WORKDIR}/ksk-secure/ksk.conf ${KSK_WORKDIR}/secondary-secure
cp ${KSK_WORKDIR}/ksk-secure/ownertrust.txt ${KSK_WORKDIR}/secondary-secure
git -C ${KSK_WORKDIR}/secondary-secure add ksk.conf $KSK_ID.public.gpg-key $KSK_ID.sub-private.gpg-key ownertrust.txt
git -C ${KSK_WORKDIR}/secondary-secure commit -m"Export of the secondary keys for for ${KSK_NAME} <${KSK_EMAIL}>"





