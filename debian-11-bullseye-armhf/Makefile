#
# This Makefile provides sane defaults for basic install and boot
# scenarios using qemu-system-arm.
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

HDD = debian-11-bullseye-armhf.img
ISO = https://cdimage.debian.org/debian-cd/current/armhf/iso-cd/debian-11.2.0-armhf-netinst.iso
SSH = 2222

CPUS = 4
RAMSIZE_MB = 8192

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

# Try to use KVM acceleration if we are running on arm64
ifeq ($(shell uname -m),aarch64)
QEMU = qemu-system-aarch64
MACHINE_FLAGS = -cpu host,aarch64=off -M virt -smp $(CPUS) -m $(RAMSIZE_MB) \
		-enable-kvm -nographic
endif

boot install: $(HDD) qemu_efi.img varstore.img
	$(QEMU) $(QEMU_FLAGS)

install: EXTRA_QEMU_FLAGS = -drive if=virtio,format=raw,file=$(notdir $(ISO))
install : $(notdir $(ISO))

# We avoid cleaning qemu_efi.img since, if we are not running on something
# derived from Debian, then we'd like to keep a copy of the firmware around.
clean :
	$(RM) $(HDD) $(notdir $(ISO)) $(notdir $(FIRMWARE)) varstore.img

$(HDD):
	qemu-img create -f qcow2 $(HDD) 128G

$(notdir $(ISO)):
	curl --location --output $@ $(ISO)

qemu_efi.img : $(notdir $(FIRMWARE))
	qemu-img convert -c -f raw -O qcow2 $^ $@

$(notdir $(FIRMWARE)):
	curl --location --output $@ $(FIRMWARE)

varstore.img :
	qemu-img create -f qcow2 varstore.img 64M

