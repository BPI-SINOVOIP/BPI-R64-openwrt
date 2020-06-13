#
# Copyright (C) 2012-2015 OpenWrt.org
# Copyright (C) 2016-2017 LEDE project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

# for arm
KERNEL_LOADADDR := 0x80008000

# for arm64
ifeq ($(SUBTARGET),mt7622)
#KERNEL_LOADADDR = 0x41080000
KERNEL_LOADADDR = 0x48080000    ## bpi-r64
endif

ifeq ($(SUBTARGET),mt7629)
KERNEL_LOADADDR = 0x40008000
endif

ifeq ($(SUBTARGET),mt7622)
define Image/Build/SDImage
	./make_bundle_image.sh $(KDIR)/mtk-bpi-r64-SD.img \
			       $(STAGING_DIR_IMAGE)/GPT_SD \
			       $(STAGING_DIR_IMAGE)/mtk-bpi-r64-preloader-sd.bin \
			       $(STAGING_DIR_IMAGE)/bpi-r64-atf.img \
			       $(STAGING_DIR_IMAGE)/mtk-bpi-r64-uboot-sd.bin \
			       $(STAGING_DIR_IMAGE)/MT7622_WMAC_EEPROM.bin \
			       $(KDIR)/BPI-R64-SD-kernel.bin \
			       $(KDIR)/root.squashfs
endef

define Image/Build/EMMCImage
	./make_bundle_image.sh $(KDIR)/mtk-bpi-r64-EMMC.img \
			       $(STAGING_DIR_IMAGE)/GPT_EMMC \
			       $(STAGING_DIR_IMAGE)/mtk-bpi-r64-preloader-emmc.bin \
			       $(STAGING_DIR_IMAGE)/bpi-r64-atf.img \
			       $(STAGING_DIR_IMAGE)/mtk-bpi-r64-uboot-emmc.bin \
			       $(STAGING_DIR_IMAGE)/MT7622_WMAC_EEPROM.bin \
			       $(KDIR)/BPI-R64-EMMC-kernel.bin \
			       $(KDIR)/root.squashfs
endef
endif

define Build/sysupgrade-emmc
	rm -f $@.recovery
	mkfs.fat -C $@.recovery 3070

	./gen_mt7623_emmc_img.sh $@ \
		$(IMAGE_KERNEL) \
		$@.recovery \
		$(IMAGE_ROOTFS)
endef

# default all platform image(fit) build 
define Device/Default
  PROFILES = Default $$(DEVICE_NAME)
  KERNEL_NAME := zImage
  FILESYSTEMS := squashfs
  DEVICE_DTS_DIR := $(DTS_DIR)
  IMAGES := sysupgrade.bin
##IMAGE/sysupgrade.bin := append-kernel | append-rootfs | pad-rootfs | append-metadata
  IMAGE/sysupgrade.bin = sysupgrade-tar | append-metadata
  SUPPORTED_DEVICES := $(subst _,$(comma),$(1))
ifeq ($(SUBTARGET),mt7623)
  KERNEL_NAME := zImage
  KERNEL := kernel-bin | append-dtb | uImage none
  KERNEL_INITRAMFS := kernel-bin | append-dtb | uImage none
else
  KERNEL_NAME := Image
  KERNEL = kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
  KERNEL_INITRAMFS = kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
endif
endef

ifeq ($(SUBTARGET),mt7622)
include mt7622.mk
endif

ifeq ($(SUBTARGET),mt7623)
include mt7623.mk
endif

ifeq ($(SUBTARGET),mt7629)
include mt7629.mk
endif

define Image/Build
	$(call Image/Build/$(1),$(1))
	$(call Image/Build/SDImage,$(1))
	$(call Image/Build/EMMCImage,$(1))
endef

$(eval $(call BuildImage))

