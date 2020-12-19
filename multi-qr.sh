#!/bin/bash

name=$1

split -d -l20 ${name} ${name}.



for f in ${name}.*; do
 ~/src/key-backup/enarmor.sh $f
 qrencode -o $f.asc.png < $f.asc
 rm $f $f.asc
done

convert ${name}.*.png ${name}.pdf
rm ${name}.*.png

