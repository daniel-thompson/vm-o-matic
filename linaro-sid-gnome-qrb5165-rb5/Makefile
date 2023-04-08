# SPDX-License-Identifier: GPL-3.0-or-later

URL = https://releases.linaro.org/96boards/rb5/linaro/debian/21.12/linaro-sid-gnome-qrb5165-rb5-146.img.gz

# Tested with a v6.2.x kernel
KERNEL = Image
VM_CMDLINE = rw
VM_ROOTFS = /dev/vda

# Set core count and RAM size to match the RB5
VM_CPUS ?= 8
#VM_RAMSIZE_MB ?= 16384
VM_RAMSIZE_MB = 8192

DISABLE_HDD_RULE = y
include ../mk/arm64.mk

# HDD download and prep
$(notdir $(URL)) :
	$(CURL) --output $@ $(URL)
$(notdir $(URL:%.img.gz=%.sparse)) : $(notdir $(URL))
	gunzip -c $< > $@
$(notdir $(URL:%.img.gz=%.raw)) : $(notdir $(URL:%.img.gz=%.sparse))
	simg2img $< $@
$(HDD) : $(notdir $(URL:%.img.gz=%.raw))
	qemu-img create -o backing_file=$<,backing_fmt=raw -f qcow2 $@ 128G

# User friendly error reporting
ifeq ($(wildcard $(KERNEL)),)
$(error Please provide a kernel suitable for qemu. arm64 defconfig is fine but does not enable many virtio peripherals.)
endif
install : ISO = $(error Installing from an ISO is not supported for this OS)
