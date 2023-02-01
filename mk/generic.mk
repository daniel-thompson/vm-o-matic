#
# generic.mk
#

# Default settings.
#
# These can be overridden in multiple ways:
#
#   - on a per-arch basis simply by conditionally setting them,
#   - locally by adding something to local.mk
#   - from the environment or make command line
#
VM_CPUS ?= 4
VM_RAMSIZE_MB ?= 8192
VM_ROOTFS ?= $(error Cannot run custom kernel: Makefile did not set VM_ROOTFS)
VM_SSH ?= 2222

CURL = curl --fail --location

boot headless install: $(HDD)
	$(QEMU) $(QEMU_FLAGS)

headless : EXTRA_QEMU_FLAGS = $(HEADLESS_FLAGS)

tpm2:
	mkdir -p tpm2
	(swtpm socket --tpmstate dir=tpm2 --ctrl type=unixio,path=tpm2/swtpm-sock --log level=20 --tpm2 & sleep 1; $(QEMU) $(QEMU_FLAGS) -chardev socket,id=chrtpm,path=tpm2/swtpm-sock   -tpmdev emulator,id=tpm0,chardev=chrtpm   -device tpm-tis,tpmdev=tpm0; wait)

install: EXTRA_QEMU_FLAGS = -drive if=virtio,format=raw,file=$(notdir $(ISO))
install : $(notdir $(ISO))

clean :
	$(RM) -r $(HDD) $(notdir $(ISO)) tpm2/ $(ARCH_CLEAN_FILES)

# Can be hooked from Makefiles that have custom downloads
pristine : clean

ifndef DISABLE_HDD_RULE
$(HDD):
	qemu-img create -f qcow2 $(HDD) 128G
endif

$(notdir $(ISO)):
	$(CURL) --output $@ $(ISO)

.PHONY: boot headless install clean pristine tpm2

# Permit local overrides
-include $(TOPDIR)/local.mk
-include local.mk
