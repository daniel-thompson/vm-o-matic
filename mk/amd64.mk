#
# amd64.mk
#

# Look up the TOPDIR using our location in the tree as a reference
TOPDIR = $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# This assumes a Debian-derived host OS with qemu-efi-aarch64 installed.
# It will not work out-of-the-box on other systems. If your distro
# doesn't have this package, or equivalent, then it is possible to
# extract the file from the raw .deb package.
# See: https://packages.debian.org/testing/ovmf .
FIRMWARE = file:///usr/share/OVMF/OVMF_CODE_4M.fd


QEMU = qemu-system-x86_64
MACHINE_FLAGS = -smp $(VM_CPUS) -m $(VM_RAMSIZE_MB)
BIOS_FLAGS = -drive if=pflash,file=qemu_efi.img,readonly=on \
	     -drive if=pflash,file=varstore.img
HEADLESS_FLAGS = -nographic

# Use KVM acceleration if we are running on x86_64
ifeq ($(shell uname -m),x86_64)
MACHINE_FLAGS += -enable-kvm
endif

boot headless install: qemu_efi.img varstore.img

qemu_efi.img : $(notdir $(FIRMWARE))
	qemu-img convert -c -f raw -O qcow2 $^ $@

$(notdir $(FIRMWARE)):
	curl --fail --location --output $@ $(FIRMWARE)

varstore.img :
	qemu-img create -f qcow2 varstore.img 4M

# We avoid cleaning qemu_efi.img since, if we are not running on something
# derived from Debian, then we'd like to keep a copy of the firmware around.
ARCH_CLEAN_FILES = $(notdir $(FIRMWARE)) varstore.img

include $(TOPDIR)/mk/generic.mk
