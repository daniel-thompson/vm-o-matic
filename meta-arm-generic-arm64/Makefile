#
# This Makefile provides sane defaults for basic boot scenarios using
# qemu-system-aarch64.
#
# `make boot` will boot the system.
#
# The system will be operating with a NAT-like networking configuration where
# the `SSH=` port is forwarded on the host machine will be forwarded to port 22
# on the emulated device.  To connect using ssh try:
#
#     ssh -p 2222 localhost
#

# Auto-discover the image
HDD := $(shell ls core-image-*.rootfs.wic | tail -n1)
SSH = 2222

include ../mk/arm64.mk

# Override the HDD flags (wic images need format=raw)
HDD_FLAGS = -drive if=virtio,format=raw,file=$(HDD)

# User friendly error reporting
ifeq ($(HDD),)
boot headless : HDD = $(error OS image is missing or badly named)
endif
install : ISO = $(error Installing from an ISO is not supported for this OS)
