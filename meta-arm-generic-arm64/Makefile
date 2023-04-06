# SPDX-License-Identifier: GPL-3.0-or-later

# Auto-discover the image
HDD := $(shell ls core-image-*.rootfs.wic 2> /dev/null | tail -n1)

include ../mk/arm64.mk

# Override the HDD flags (wic images need format=raw)
HDD_FLAGS = -drive if=virtio,format=raw,file=$(HDD)

# User friendly error reporting
ifeq ($(HDD),)
boot headless : HDD = $(error OS image is missing or badly named)
endif
install : ISO = $(error Installing from an ISO is not supported for this OS)
