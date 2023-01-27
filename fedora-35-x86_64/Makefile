#
# This Makefile provides sane defaults for basic install and boot
# scenarios using qemu-system-x86_64 and KVM.
#
# `make install` will create the HDD disc image (if needed), download
# the ISO and boot into the installer.
#
# `make boot` will boot the system with a GUI
#
# `make headless` will boot the system without a GUI (you may need to
# add `console=ttyS0,115200` to the kernel command line in order to
# use the machine.
#
# In *all* the above cases the system will be operating with a NAT-like
# networking configuration where the `SSH=` port is forwarded on the
# host machine will be forwarded to port 22 on the emulated device.
# To connect using ssh try:
#
#     ssh -p 2222 localhost
#

HDD = fedora-35-x86_64.img
ISO = https://download.fedoraproject.org/pub/fedora/linux/releases/35/Server/x86_64/iso/Fedora-Server-netinst-x86_64-35-1.2.iso

include ../mk/amd64.mk
