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

HDD = fedora-37-x86_64.img
ISO = https://download.fedoraproject.org/pub/fedora/linux/releases/37/Server/x86_64/iso/Fedora-Server-netinst-x86_64-37-1.7.iso

include ../mk/amd64.mk


#
# Cloud image bootstrap
#
# Currently we are using virt-customize to secure initial login (because it
# is easier than standing up proper cloud-init infrastructure).
#

CLOUD_IMG = https://download.fedoraproject.org/pub/fedora/linux/releases/37/Cloud/x86_64/images/Fedora-Cloud-Base-37-1.7.x86_64.qcow2

cloud : $(notdir $(CLOUD_IMG))
	qemu-img create -o backing_file=$<,backing_fmt=qcow2 -f qcow2 $(HDD) 128G
	virt-customize --add $(HDD) \
		--firstboot-command "passwd -d root" \
		--firstboot-command "growpart /dev/vda 5" \
		--firstboot-command "btrfs filesystem resize max /" \

$(notdir $(CLOUD_IMG)):
	$(CURL) --output $@ $(CLOUD_IMG)

pristine :
	$(RM) $(notdir $(CLOUD_IMG))
