#
# armhf.mk
#
# WARNING: EDK2 does something funny with the varstore on the first
#          boot. It the CD is not present at first boot the varstore
#          will be updated and *subsequent* boots will fail to find
#          the CD drive (e.g. `make install` will fall back to
#          work boot). To fix just delete varstore.img and try again.
#

# Look up the TOPDIR using our location in the tree as a reference
TOPDIR = $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# Default machine specifications (override this from local.mk)
CPUS = 4
RAMSIZE_MB = 2048

# This assumes a Debian-derived host OS with qemu-efi-arm installed.
# It will not work out-of-the-box on other systems. If your distro
# doesn't have this package, or equivalent, then it is possible to
# extract the file from the raw .deb package.
# See: https://packages.debian.org/testing/qemu-efi-arm .
FIRMWARE = file:///usr/share/AAVMF/AAVMF32_CODE.fd

QEMU = qemu-system-arm
QEMU_FLAGS = $(MACHINE_FLAGS) $(BIOS_FLAGS) $(HDD_FLAGS) $(NETWORK_FLAGS) $(EXTRA_QEMU_FLAGS)
MACHINE_FLAGS = -cpu cortex-a15 -M virt -smp $(CPUS) -m $(RAMSIZE_MB) -nographic
BIOS_FLAGS = -drive if=pflash,file=qemu_efi.img \
	     -drive if=pflash,file=varstore.img
HDD_FLAGS = -drive if=virtio,file=$(HDD)
NETWORK_FLAGS = -nic user,model=virtio,hostfwd=tcp::$(SSH)-:22
HEADLESS_FLAGS =

# Try to use KVM acceleration if we are running on arm64
ifeq ($(shell uname -m),aarch64)
QEMU = qemu-system-aarch64
MACHINE_FLAGS = -cpu host,aarch64=off -M virt -smp $(CPUS) -m $(RAMSIZE_MB) \
		-enable-kvm -nographic
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
