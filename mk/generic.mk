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

# If HDD is not set then derive it from MAKEFILE_LIST. Note that substituting
# '/' for ' ' is safe even for paths containing a space (because there are
# no such paths inside vm-o-matic
HDD ?= $(lastword $(filter-out Makefile,$(subst /, ,$(realpath $(firstword $(MAKEFILE_LIST)))))).img

CURL = curl --fail --location

boot headless install: $(HDD)
	$(QEMU) $(QEMU_FLAGS)

boot : ## Launch a VM

headless : EXTRA_QEMU_FLAGS = $(HEADLESS_FLAGS) ## Launch a VM using a serial console

tpm2: ## Launch a VM and TPM2 simulator
	mkdir -p tpm2
	(swtpm socket --tpmstate dir=tpm2 --ctrl type=unixio,path=tpm2/swtpm-sock --log level=20 --tpm2 & sleep 1; $(QEMU) $(QEMU_FLAGS) -chardev socket,id=chrtpm,path=tpm2/swtpm-sock   -tpmdev emulator,id=tpm0,chardev=chrtpm   -device tpm-tis,tpmdev=tpm0; wait)

install: EXTRA_QEMU_FLAGS = -drive if=virtio,format=raw,file=$(notdir $(ISO))
install : $(notdir $(ISO)) ## Download ISO image and boot VM using it

clean : ## Tidy up HDD and ISO images
	$(RM) -r $(HDD) $(notdir $(ISO)) tpm2/ $(ARCH_CLEAN_FILES)

# Can be hooked from Makefiles that have custom downloads
pristine : clean

ifndef DISABLE_HDD_RULE
$(HDD):
	qemu-img create -f qcow2 $(HDD) 128G
endif

$(notdir $(ISO)):
	$(CURL) --output $@ $(ISO)

help :
	@eval $$(sed -E -n 's/^([a-zA-Z0-9_-]+) *:.*?## (.*)$$/printf " %-20s %s\\n" " \1" "\2" ;/; ta; b; :a p' $(MAKEFILE_LIST) | sort)

.PHONY: boot headless help install clean pristine tpm2

# Permit local overrides
-include $(TOPDIR)/local.mk
-include local.mk
