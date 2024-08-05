#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

TARGET=$1

# Export primary

gpg --homedir $KSK_WORKDIR/gpg-primary --armor --export $KSK_ID > $TARGET/$KSK_ID.public.gpg-key
gpg --homedir $KSK_WORKDIR/gpg-primary --armor --export-secret-keys $KSK_ID > $TARGET/$KSK_ID.private.gpg-key
gpg --homedir $KSK_WORKDIR/gpg-primary --armor --export-secret-subkeys $KSK_ID > $TARGET/$KSK_ID.sub-private.gpg-key
gpg --homedir $KSK_WORKDIR/gpg-primary --export-ownertrust > $TARGET/ownertrust.txt


