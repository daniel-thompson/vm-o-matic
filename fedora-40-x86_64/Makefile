# SPDX-License-Identifier: GPL-3.0-or-later

ISO = https://download.fedoraproject.org/pub/fedora/linux/releases/40/Server/x86_64/iso/Fedora-Server-netinst-x86_64-40-1.14.iso

include ../mk/amd64.mk


#
# Cloud image bootstrap
#
# Currently we are using virt-customize to secure initial login (because it
# is easier than standing up proper cloud-init infrastructure).
#

CLOUD_IMG = https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-UEFI-UKI.x86_64-40-1.14.qcow2

cloud : $(notdir $(CLOUD_IMG)) ## Generate HDD image using cloud images
	qemu-img create -o backing_file=$<,backing_fmt=qcow2 -f qcow2 $(HDD) 128G
	virt-customize --add $(HDD) \
		--firstboot-command "passwd -d root" \
		--firstboot-command "growpart /dev/vda 5" \
		--firstboot-command "btrfs filesystem resize max /" \

$(notdir $(CLOUD_IMG)):
	$(CURL) --output $@ $(CLOUD_IMG)

pristine :
	$(RM) $(notdir $(CLOUD_IMG))
