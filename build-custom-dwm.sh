#!/bin/bash

sudo rm -r dwm
git clone https://git.suckless.org/dwm
cp rebuild.sh dwm
mkdir dwm/patches
cp get-patches.sh dwm/patches
cd dwm/patches
sh get-patches.sh
cd ..

patch -p1 < patches/dwm-cfacts-vanitygaps-6.4_combo.diff
patch -p1 < patches/dwm-alpha-20230401-348f655.diff
patch -p1 < patches/dwm-autostart-20210120-cb3f58a.diff
patch -p1 < patches/dwm-bartoggle-6.4.diff
