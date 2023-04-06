#
# arm64.mk
#
# WARNING: EDK2 does something funny with the varstore on the first
#          boot. It the CD is not present at first boot the varstore
#          will be updated and *subsequent* boots will fail to find
#          the CD drive (e.g. `make install` will fall back to
#          work boot). To fix just delete varstore.img and try again.
#

# Look up the TOPDIR using our location in the tree as a reference
TOPDIR = $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

VM_CPU ?= cortex-a57
VM_MACHINE ?= virt

# This assumes a Debian-derived host OS with qemu-efi-aarch64 installed.
# It will not work out-of-the-box on other systems. If your distro
# doesn't have this package, or equivalent, then it is possible to
# extract the file from the raw .deb package.
# See: https://packages.debian.org/testing/qemu-efi-arm .
FIRMWARE = file:///usr/share/AAVMF/AAVMF_CODE.fd

QEMU = qemu-system-aarch64
QEMU_FLAGS = $(MACHINE_FLAGS) $(BIOS_FLAGS) $(HDD_FLAGS) $(NETWORK_FLAGS) $(KERNEL_FLAGS) $(EXTRA_QEMU_FLAGS)
MACHINE_FLAGS = -cpu $(VM_CPU) -M $(VM_MACHINE) -smp $(VM_CPUS) -m $(VM_RAMSIZE_MB) -nographic
BIOS_FLAGS = -drive if=pflash,file=qemu_efi.img \
	     -drive if=pflash,file=varstore.img
HDD_FLAGS = -drive if=virtio,file=$(HDD)
NETWORK_FLAGS = -nic user,model=virtio,hostfwd=tcp::$(VM_SSH)-:22
HEADLESS_FLAGS =

# Try to use KVM acceleration if we are running on arm64 (and it's not a
# Windows-on-Snapdragon laptop :-( )
ifeq ($(shell uname -m),aarch64)
ifeq ($(wildcard /dev/kvm),/dev/kvm)
MACHINE_FLAGS = -cpu host -M virt -smp $(VM_CPUS) -m $(VM_RAMSIZE_MB) -enable-kvm -nographic
endif
endif

ifdef KERNEL
KERNEL_FLAGS = -kernel $(KERNEL) -append root="$(VM_ROOTFS) $(VM_CMDLINE)"
endif

# arm64 requires additional firmware files to be created
boot headless install: qemu_efi.img varstore.img

qemu_efi.img : $(notdir $(FIRMWARE))
	qemu-img convert -c -f raw -O qcow2 $^ $@

$(notdir $(FIRMWARE)):
	curl --fail --location --output $@ $(FIRMWARE)

varstore.img :
	qemu-img create -f qcow2 varstore.img 64M

# We avoid cleaning qemu_efi.img since, if we are not running on something
# derived from Debian, then we'd like to keep a copy of the firmware around.
ARCH_CLEAN_FILES = $(notdir $(FIRMWARE)) varstore.img

include $(TOPDIR)/mk/generic.mk
