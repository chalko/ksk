#!/bin/bash

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
key=$1


echo ${key}
tar -acf ${key}.tar.gz ~/.gnupg/${key}/*
~/src/key-backup/enarmor.sh "${key}.tar.gz"

