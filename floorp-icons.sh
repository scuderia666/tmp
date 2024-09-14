#!/bin/sh

for i in 16 32 48 64 128; do
	install -Dm644 /home/satou/programs/floorp/browser/chrome/icons/default/default$i.png \
		"/home/satou/.local/share/icons/hicolor/${i}x${i}/apps/floorp.png"
done
