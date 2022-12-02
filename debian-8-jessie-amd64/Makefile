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

HDD = debian-8-jessie-x86_64.img
ISO = https://cdimage.debian.org/cdimage/archive/8.11.1/amd64/iso-cd/debian-8.11.1-amd64-CD-1.iso
SSH = 2222

CPUS = 4
RAMSIZE_MB = 8192

QEMU = qemu-system-x86_64 
QEMU_FLAGS = $(MACHINE_FLAGS) $(HDD_FLAGS) $(NETWORK_FLAGS) $(EXTRA_QEMU_FLAGS)
MACHINE_FLAGS = -enable-kvm -smp $(CPUS) -m $(RAMSIZE_MB) 
HDD_FLAGS = -drive if=virtio,file=$(HDD)
NETWORK_FLAGS = -nic user,model=virtio,hostfwd=tcp::$(SSH)-:22

boot headless install: $(HDD)
	$(QEMU) $(QEMU_FLAGS)

headless: EXTRA_QEMU_FLAGS = -nographic
install: EXTRA_QEMU_FLAGS = -cdrom $(notdir $(ISO))
install : $(notdir $(ISO)) warning

warning :
	@echo
	@echo "WARNING: jessie is obsolete and the installer will be unable to automatically"
	@echo "         find the apt mirrors. At the *Configure the package manager* stage"
	@echo "         you must *enter information manually*. Set hostname to"
	@echo "         archive.debian.org and choose the default mirror directory (/debian/)."
	@echo "         Additionally you make see problems with several expired certificates"
	@echo "         (both GPG and CA certs are outdated)."
	@echo
        

clean :
	$(RM) $(HDD) $(notdir $(ISO))

$(HDD):
	qemu-img create -f qcow2 $(HDD) 128G

$(notdir $(ISO)):
	wget $(ISO)
