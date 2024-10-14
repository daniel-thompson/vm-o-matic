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
ifeq ($(VM_SIZE),big)
# Get total number of cores, ignoring hyperthreaded partners
VM_CPUS ?= $(shell lscpu --parse=core | grep -v '^#' | sort -u | wc -l)
VM_RAMSIZE_MB ?= $(shell awk '/^MemTotal:/ { print int($$2 / 1024) - 3072 }' /proc/meminfo)
endif
VM_CPUS ?= 4
VM_RAMSIZE_MB ?= 8192
VM_ROOTFS ?= $(error Cannot run custom kernel: Makefile did not set VM_ROOTFS)
VM_SSH ?= 2222

# If HDD is not set then derive it from MAKEFILE_LIST. Note that substituting
# '/' for ' ' is safe even for paths containing a space (because there are
# no such paths inside vm-o-matic
HDD ?= $(lastword $(filter-out Makefile,$(subst /, ,$(realpath $(firstword $(MAKEFILE_LIST)))))).img

CURL = curl --fail --location

QEMU ?= $(error QEMU is not set)
QEMU_FLAGS = $(KVM_FLAGS) $(MACHINE_FLAGS) $(BIOS_FLAGS) $(HDD_FLAGS) $(NETWORK_FLAGS) $(MISC_FLAGS) $(KERNEL_FLAGS) $(BOOT_MODE_FLAGS) $(EXTRA_QEMU_FLAGS)
HDD_FLAGS ?= -drive if=virtio,file=$(HDD)
NETWORK_FLAGS ?= -nic user,model=virtio,hostfwd=tcp::$(VM_SSH)-:22

ifdef KERNEL
KERNEL_FLAGS = -kernel $(KERNEL) -append root="$(VM_ROOTFS) $(VM_CMDLINE)"
endif

ifdef BRIDGE
# This won't work on PCIe-less virtual systems... but we need to override
# everything because we want to set an explicit MAC address
MACADDR = $(shell echo "52:54:00:$$(echo $(HOSTNAME) $(BRIDGE) $(PWD) | sha256sum | sed -E 's/^(..)(..)(..).*$$/\1:\2:\3/')")
NETWORK_FLAGS = -device virtio-net-pci,netdev=eth0,mac=$(MACADDR) -netdev bridge,id=eth0,br=$(BRIDGE)
endif

boot headless install vnc: $(HDD)
	$(QEMU) $(QEMU_FLAGS)

boot : ## Launch a VM

headless : BOOT_MODE_FLAGS = $(HEADLESS_FLAGS) ## Launch a VM using a serial console

tpm2: ## Launch a VM and TPM2 simulator
	mkdir -p tpm2
	(swtpm socket --tpmstate dir=tpm2 --ctrl type=unixio,path=tpm2/swtpm-sock --log level=20 --tpm2 & sleep 1; $(QEMU) $(QEMU_FLAGS) -chardev socket,id=chrtpm,path=tpm2/swtpm-sock   -tpmdev emulator,id=tpm0,chardev=chrtpm   -device tpm-tis,tpmdev=tpm0; wait)

install: BOOT_MODE_FLAGS = -drive if=virtio,format=raw,file=$(notdir $(ISO))
install : $(notdir $(ISO)) ## Download ISO image and boot VM using it

# This has crap-all security at all (unless the host firewall blocks port
# 5901 when it will be elevated merely has crap security). Connect using:
# vnc://<hostname>:5901
vnc : BOOT_MODE_FLAGS = -vnc :1,power-control=on,$(EXTRA_VNC_FLAGS)

clean : ## Tidy up HDD and ISO images
	$(RM) -r $(HDD) $(notdir $(ISO)) tpm2/ $(ARCH_CLEAN_FILES)

# Can be hooked from Makefiles that have custom downloads
pristine : clean

ifndef DISABLE_HDD_RULE
$(HDD):
	qemu-img create -f qcow2 $(HDD) 128G
endif

ifndef DISABLE_ISO_RULE
$(notdir $(ISO)):
	$(CURL) --output $@ $(ISO)
endif

help :
	@eval $$(sed -E -n 's/^([a-zA-Z0-9_-]+) *:.*?## (.*)$$/printf " %-20s %s\\n" " \1" "\2" ;/; ta; b; :a p' $(MAKEFILE_LIST) | sort)

.PHONY: boot headless help install clean pristine tpm2

# Permit local overrides
-include $(TOPDIR)/local.mk
-include local.mk
