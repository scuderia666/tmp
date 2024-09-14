#!/bin/bash
for var in $1; do
	var="${var//\'/}"
	extension=".${var#*.}"
	path="$(dirname "$var")"
	filename="$(uuidgen)${extension}"
	mv "$var" "${path}/${filename}"
done
