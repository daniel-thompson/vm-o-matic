#
# i686.mk
#

# Look up the TOPDIR using our location in the tree as a reference
TOPDIR = $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

QEMU = qemu-system-i386
MACHINE_FLAGS = -smp $(VM_CPUS) -m $(VM_RAMSIZE_MB)
HEADLESS_FLAGS = -nographic

# Use KVM acceleration if we are running on x86_64
ifeq ($(shell uname -m),x86_64)
MACHINE_FLAGS += -enable-kvm
endif

ifdef VM_BIOS
# BIOS_FLAGS is not set
CDROM_FLAGS = -cdrom $(ISO)
HDD_FLAGS = -hda $(HDD)
else
# The OVMF firmware for i686 is avaiabe in Debian (apt install ovmf-ia32)
# and Fedora (apt install edk2-ovmf-ia32)
FIRMWARE = /usr/share/edk2/ovmf-ia32/OVMF_CODE.fd
BIOS_FLAGS = -bios $(FIRMWARE)
endif

include $(TOPDIR)/mk/generic.mk
