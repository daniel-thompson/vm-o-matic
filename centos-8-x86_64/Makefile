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

HDD = CentOS-8-x86_64.img
ISO = http://mirror.ox.ac.uk/sites/mirror.centos.org/8.3.2011/isos/x86_64/CentOS-8.3.2011-x86_64-dvd1.iso
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
install : $(notdir $(ISO))

$(HDD):
	qemu-img create -f qcow2 $(HDD) 128G

$(notdir $(ISO)):
	wget $(ISO)
