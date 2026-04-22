#!/bin/bash

#  This file is part of the micropython-builder project,
#  https://github.com/v923z/micropython-builder
#  The MIT License (MIT)
#  Copyright (c) 2022-2023 Zoltán Vörös

source ./scripts/init.sh

cp st7789_mpy/fonts/bitmap/vga* micropython/ports/rp2/modules
./micropython/mpy-cross/build/mpy-cross ./scripts/rp2/tft_config.py -o ./micropython/ports/rp2/modules/tft_config.mpy

PICOTOOL_FETCH_DIR="${HOME}/.picotool"
mkdir -p "${PICOTOOL_FETCH_DIR}"

build_rp2() {
    make ${MAKEOPTS} -C micropython/ports/rp2 BOARD=$1 submodules
    make ${MAKEOPTS} -C micropython/ports/rp2 BOARD=$1 CMAKE_ARGS="-DPICOTOOL_FETCH_FROM_GIT_PATH=${PICOTOOL_FETCH_DIR}" USER_C_MODULES=../../../st7789_mpy/micropython.cmake FROZEN_MANIFEST="" FROZEN_MPY_DIR=modules

    copy_files rp2/build-$1/firmware.uf2 $1
    clean_up rp2 build-$1
}

build_rp2_uart_vfat() {
    # hot-patch the config file here
    cp ./scripts/rp2/mpconfigport.h.patch.uart_vfat ./micropython/ports/rp2/boards/RPI_PICO/mpconfigport.h
    make ${MAKEOPTS} -C micropython/ports/rp2 BOARD=$1 submodules
    make ${MAKEOPTS} -C micropython/ports/rp2 BOARD=$1 USER_C_MODULES=../../../st7789_mpy/micropython.cmake
    copy_files rp2/build-$1/firmware.uf2 "$1"-UART-VFAT
    clean_up rp2 build-$1
}
