#
# amd64.mk
#

# Look up the TOPDIR using our location in the tree as a reference
TOPDIR = $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# This works on at least Debian and Fedora (both requiring a package called
# ovmf).
FIRMWARE = /usr/share/OVMF/OVMF_CODE.fd

QEMU = qemu-system-x86_64
MACHINE_FLAGS = -smp $(VM_CPUS) -m $(VM_RAMSIZE_MB)
BIOS_FLAGS = -bios $(FIRMWARE)
HDD_FLAGS = -drive if=virtio,file=$(HDD)
NETWORK_FLAGS = -nic user,model=virtio,hostfwd=tcp::$(VM_SSH)-:22
HEADLESS_FLAGS = -nographic

# Use KVM acceleration if we are running on x86_64
ifeq ($(shell uname -m),x86_64)
MACHINE_FLAGS += -enable-kvm
endif

include $(TOPDIR)/mk/generic.mk
