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

HDD = fedora-36-x86_64.img
ISO = https://download.fedoraproject.org/pub/fedora/linux/releases/36/Server/x86_64/iso/Fedora-Server-netinst-x86_64-36-1.5.iso
SSH = 2222

CPUS = 8
RAMSIZE_MB = 12288

# This works on at least Debian and Fedora (both requiring a package called
# ovmf).
FIRMWARE = /usr/share/OVMF/OVMF_CODE.fd

QEMU = qemu-system-x86_64
QEMU_FLAGS = $(MACHINE_FLAGS) $(FIRMWARE_FLAGS) $(HDD_FLAGS) $(NETWORK_FLAGS) $(EXTRA_QEMU_FLAGS)
MACHINE_FLAGS = -enable-kvm -smp $(CPUS) -m $(RAMSIZE_MB)
ifdef FIRMWARE
FIRMWARE_FLAGS = -bios $(FIRMWARE)
endif
HDD_FLAGS = -drive if=virtio,file=$(HDD)
NETWORK_FLAGS = -nic user,model=virtio,hostfwd=tcp::$(SSH)-:22

boot headless install: $(HDD)
	$(QEMU) $(QEMU_FLAGS)

tpm2:
	mkdir -p tpm2
	(swtpm socket --tpmstate dir=tpm2 --ctrl type=unixio,path=tpm2/swtpm-sock --log level=20 --tpm2 & sleep 1; $(QEMU) $(QEMU_FLAGS) -chardev socket,id=chrtpm,path=tpm2/swtpm-sock   -tpmdev emulator,id=tpm0,chardev=chrtpm   -device tpm-tis,tpmdev=tpm0; wait)

headless: EXTRA_QEMU_FLAGS = -nographic
install: EXTRA_QEMU_FLAGS = -cdrom $(notdir $(ISO))
install : $(notdir $(ISO))

clean :
	$(RM) $(HDD) $(notdir $(ISO))

$(HDD):
	qemu-img create -f qcow2 $(HDD) 128G

$(notdir $(ISO)):
	curl --location --output $@ $(ISO)

.PHONY: tpm2
