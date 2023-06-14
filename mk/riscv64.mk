#
# riscv64.mk
#

# Look up the TOPDIR using our location in the tree as a reference
TOPDIR = $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# This assumes a Debian-derived host OS with qemu-efi-aarch64 installed.
# It will not work out-of-the-box on other systems. If your distro
# doesn't have this package, or equivalent, then it is possible to
# extract the file from the raw .deb package.
# See: https://packages.debian.org/testing/qemu-efi-arm .
FIRMWARE = file:///usr/share/AAVMF/AAVMF_CODE.fd

QEMU = qemu-system-riscv64
MACHINE_FLAGS = -cpu rv64 -M virt -smp $(VM_CPUS) -m $(VM_RAMSIZE_MB) -nographic
BIOS_FLAGS = -bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \
	     -kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf
HDD_FLAGS = -drive if=virtio,file=$(HDD)
NETWORK_FLAGS = -device virtio-net-device,netdev=net \
		-netdev user,id=net,hostfwd=tcp::$(VM_SSH)-:22
HEADLESS_FLAGS =

include $(TOPDIR)/mk/generic.mk
