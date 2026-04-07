#!/bin/bash

#  This file is part of the micropython-builder project,
#  https://github.com/v923z/micropython-builder
#  The MIT License (MIT)
#  Copyright (c) 2022 Zoltán Vörös


# set-up and housekeeping utilities

# get the number of processors, so that this might be passed to make
if which nproc > /dev/null; then
    MAKEOPTS="-j$(nproc)"
else
    MAKEOPTS="-j$(sysctl -n hw.ncpu)"
fi


# only check out st7789_mpy, if it is not available locally, otherwise, pull
git clone https://github.com/Jan-Zeiseweis/st7789_mpy st7789_mpy || git -C st7789_mpy pull


# only check out micropython, if it is not available locally, otherwise, pull
git clone https://github.com/micropython/micropython micropython || git -C micropython pull
# MICROPYTHON_VERSION can be overridden by the caller (e.g. rp2_init.sh sets v1.26.0 for Pico 2)
: ${MICROPYTHON_VERSION:=v1.28.0}
git -C micropython checkout ${MICROPYTHON_VERSION}

cd micropython
# RP2_SUBMODULES_ONLY=1 selects a targeted init for RP2350 (Pico 2) builds; default is full init
if [ -n "${RP2_SUBMODULES_ONLY}" ]; then
    git submodule update --init lib/tinyusb
    git submodule update --init lib/pico-sdk
    cd lib/pico-sdk
    git submodule update --init lib/tinyusb
    cd ../..
else
    git submodule update --init
fi
cd ..


# only check out micropython-lib, if it is not available locally, otherwise, pull
git clone https://github.com/micropython/micropython-lib || git -C micropython-lib pull


# create hashes, which will be appended to the output file names
st7789_hash=`cd st7789_mpy; git describe --abbrev=8 --always; cd ..`
upython_hash=`cd micropython; git describe --abbrev=8 --always; cd ..`

# the cross-compiler is required for each build, so we might as well get it over with
make ${MAKEOPTS} -C micropython/mpy-cross

# choose a delimiter that is not probable to turn up in the description of the file
write_platforms_list() {
    if [ -f "platforms.md" ]; then
        echo $1"| "$1-$upython_hash-$st7789_hash$ext"| " $2 >> ./platforms.list
    echo
    fi
}

# helper function to move the binary file from the build directory a temporary folder (./artifacts)
copy_files() {
    if [ -d "./artifacts" ]; then
        echo "copying firmware"
        stem=`basename $1`
        ext=$([[ "$stem" = *.* ]] && echo ".${stem##*.}" || echo '')
        mv micropython/ports/$1 ./artifacts/$2$ext
    fi
}

# clean up the build directory, in case another piece of firmware is produced for the same port
# note that the clean-up routine is run only, if the ./artifacts directory exists
clean_up() {
    # only remove the artifacts, if they can be saved in the ./artifacts folder
    if [ -d "./artifacts" ]; then
        echo "running make clean"
        make clean -C ./micropython/ports/$1

        # remove the directory explicitly, if make clean didn't get rid of it
        echo "removing compilation folder"
        rm ./micropython/ports/$1/$2 -rf
    fi
}
