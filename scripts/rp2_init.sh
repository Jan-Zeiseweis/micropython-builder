#!/bin/bash

#  This file is part of the micropython-builder project,
#  https://github.com/v923z/micropython-builder
#  The MIT License (MIT)
#  Copyright (c) 2022 Zoltán Vörös

#  Exports the micropython version and submodule flags for RP2350 (Pico 2) builds.
#  Source this file before sourcing rp2.sh to override the defaults in init.sh.
#  Contributed by: Jayanth Damodaran    Last Modified: 9/6/25

export MICROPYTHON_VERSION=v1.26.0
export RP2_SUBMODULES_ONLY=1
