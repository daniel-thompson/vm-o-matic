#
# riscv64.mk
#

# Look up the TOPDIR using our location in the tree as a reference
TOPDIR = $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

QEMU = qemu-system-riscv64
MACHINE_FLAGS = -cpu rv64 -M virt -smp $(VM_CPUS) -m $(VM_RAMSIZE_MB) -nographic

ifndef KERNEL
BIOS_FLAGS = -bios $(OPENSBI) -kernel $(UBOOT)
endif
NETWORK_FLAGS = -device virtio-net-device,netdev=net \
		-netdev user,id=net,hostfwd=tcp:$(VM_HOST_ADDRESS):$(VM_SSH)-$(VM_GUEST_ADDRESS):22
HEADLESS_FLAGS =

OPENSBI = /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.bin
UBOOT = /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf

include $(TOPDIR)/mk/generic.mk
