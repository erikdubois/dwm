#!/bin/bash

make clean
make
sudo make install
make clean
rm config.h