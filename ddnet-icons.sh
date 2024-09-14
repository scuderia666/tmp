#!/bin/sh

for i in 16 32 48 256; do
	install -Dm644 ddnet_icons/DDNet_${i}x${i}.png \
		"/home/satou/.local/share/icons/hicolor/${i}x${i}/apps/ddnet.png"
done
