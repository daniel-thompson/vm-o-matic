# SPDX-License-Identifier: GPL-3.0-or-later

WIC = https://github.com/ARM-software/arm-systemready/raw/main/IR/prebuilt_images/v24.03_2.1.1/ir-acs-live-image-generic-arm64.wic.xz
ISO = ir-acs-live-image-generic-arm64.wic

DISABLE_ISO_RULE=y
$(ISO) :
	$(CURL) --output $(notdir $(WIC)) $(WIC)
	unxz $(ISO).xz

include ../mk/arm64.mk
