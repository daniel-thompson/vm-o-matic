#
# This Makefile provides sane defaults for downloading a basic image
# for qemu-system-riscv64.
#
# `make boot` will boot the system.
#
# Default credentials are:
#   root/root
#   debian/debian
#
# In *all* the above cases the system will be operating with a NAT-like
# networking configuration where the `SSH=` port is forwarded on the
# host machine will be forwarded to port 22 on the emulated device.
# To connect using ssh try:
#
#     ssh -p 2222 localhost
#
# Thanks to https://colatkinson.site/linux/riscv/2021/01/27/riscv-qemu/
# for sharing the recipe to get Debian booted on qemu-system-riscv64!
#

HDD = debian-unstable-sid-riscv64.img

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
