#
# Makefile for qemu-system-x86_64
#
# Sane defaults for basic install and boot scenarios
#

HDD = CentOS-7-x86_64.img
ISO = http://mirror.ox.ac.uk/sites/mirror.centos.org/7.9.2009/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso
SSH = 2222

QEMU = qemu-system-x86_64 
QEMU_FLAGS = $(MACHINE_FLAGS) $(HDD_FLAGS) $(NETWORK_FLAGS) $(EXTRA_QEMU_FLAGS)
MACHINE_FLAGS = -enable-kvm -smp 2 -m 8192 
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
