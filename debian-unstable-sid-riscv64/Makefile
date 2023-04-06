# SPDX-License-Identifier: GPL-3.0-or-later

DISABLE_HDD_RULE = y
include ../mk/riscv64.mk

prep-debian:
	sudo apt install qemu-system-riscv64 u-boot-qemu opensbi

clean : rv64_clean
rv64_clean :
	$(RM) -r artifacts/

pristine : clean
	$(RM) artifacts.zip

$(HDD): artifacts/image.qcow2
	qemu-img create -o backing_file=$<,backing_fmt=qcow2 -f qcow2 $@ 128G
	@echo ">>>>>>   DON'T FORGET TO resize2fs /dev/vda1 AFTER FIRST BOOT            <<<<<<"

artifacts/image.qcow2: artifacts.zip
	unzip artifacts.zip
	touch $@

artifacts.zip:
	curl --fail --location --output artifacts.zip "https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt"
