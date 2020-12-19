#!/bin/bash

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
key=$1


echo ${key}
tar -acf ${key}.tar.gz ~/.gnupg/${key}/*
gpg --comment "${key}.tar.gz " --enarmor <${key}.tar.gz > ${key}.tar.gz.asc