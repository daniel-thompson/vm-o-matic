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
HDD = $(shell ls core-image-*.rootfs.wic | tail -n1)
SSH = 2222

CPUS = 4
RAMSIZE_MB = 8192

# This assumes a Debian-derived host OS with qemu-efi-aarch64 installed.
# It will not work out-of-the-box on other systems. If your distro
# doesn't have this package, or equivalent, then it is possible to
# extract the file from the raw .deb package.
# See: https://packages.debian.org/testing/qemu-efi-arm .
FIRMWARE = file:///usr/share/AAVMF/AAVMF_CODE.fd

QEMU = qemu-system-aarch64
QEMU_FLAGS = $(MACHINE_FLAGS) $(BIOS_FLAGS) $(HDD_FLAGS) $(NETWORK_FLAGS) $(EXTRA_QEMU_FLAGS)
MACHINE_FLAGS = -cpu cortex-a57 -M virt -smp $(CPUS) -m $(RAMSIZE_MB) -nographic
BIOS_FLAGS = -drive if=pflash,file=qemu_efi.img \
	     -drive if=pflash,file=varstore.img
HDD_FLAGS = -drive if=virtio,format=raw,file=$(HDD)
NETWORK_FLAGS = -nic user,model=virtio,hostfwd=tcp::$(SSH)-:22

# Try to use KVM acceleration if we are running on arm64
ifeq ($(shell uname -m),aarch64)
MACHINE_FLAGS = -cpu host -M virt -smp $(CPUS) -m $(RAMSIZE_MB) -enable-kvm -nographic
endif

boot: qemu_efi.img varstore.img
	$(QEMU) $(QEMU_FLAGS)

# We avoid cleaning qemu_efi.img since, if we are not running on something
# that provides $(FIRMWARE), then we'd like to keep a copy of the firmware
# around. In this case we also avoid cleaning up $(HDD) since vm-o-matic
# contains no logic to redownload or regenerate it.
clean :
	$(RM) $(HDD) varstore.img

qemu_efi.img :
	qemu-img convert -c -f raw -O qcow2 $(FIRMWARE) $@

varstore.img :
	qemu-img create -f qcow2 varstore.img 64M
