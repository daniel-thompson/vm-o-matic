#
# This Makefile provides sane defaults for basic install and boot
# scenarios using qemu-system-aarch64.
#
# `make install` will create the HDD disc image (if needed), download
# the ISO and boot into the installer.
#
# `make boot` will boot the system.
#
# In *all* the above cases the system will be operating with a NAT-like
# networking configuration where the `SSH=` port is forwarded on the
# host machine will be forwarded to port 22 on the emulated device.
# To connect using ssh try:
#
#     ssh -p 2222 localhost
#

HDD = alpine-3-arm64.img
ISO = https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/aarch64/alpine-standard-3.17.1-aarch64.iso

include ../mk/arm64.mk
