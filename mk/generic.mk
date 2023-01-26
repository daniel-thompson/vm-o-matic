#
# generic.mk
#

boot headless install: $(HDD)
	$(QEMU) $(QEMU_FLAGS)

install: EXTRA_QEMU_FLAGS = -drive if=virtio,format=raw,file=$(notdir $(ISO))
install : $(notdir $(ISO))

clean :
	$(RM) $(HDD) $(notdir $(ISO)) $(ARCH_CLEAN_FILES)

$(HDD):
	qemu-img create -f qcow2 $(HDD) 128G

$(notdir $(ISO)):
	curl --fail --location --output $@ $(ISO)

# Permit local overrides
-include $(TOPDIR)/local.mk
-include local.mk
