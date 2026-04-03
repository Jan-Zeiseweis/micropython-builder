#!/bin/bash

#  This file is part of the micropython-builder project,
#  https://github.com/v923z/micropython-builder
#  The MIT License (MIT)
#  Copyright (c) 2022 Zoltán Vörös
#  File Author: Jayanth Damodaran    Last Modified: Sept. 6, 2025

source ./scripts/rp2_init.sh
source ./scripts/rp2/rp2.sh

build_rp2 "RPI_PICO2"
