#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

source "${DIR}"/ksk.conf

gpg  --batch --import "${DIR}"/"$KSK_ID".public.gpg-key
gpg  --batch --import "${DIR}"/"$KSK_ID".sub-private.gpg-key
gpg  --import-ownertrust "${DIR}"/ownertrust.txt




