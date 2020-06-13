#!/usr/bin/env bash
#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

set -ex
[ $# -eq 8 ] || {
    echo "SYNTAX: $0 <file> <GPT image> <preloader image> <atf image> <uboot image> <wmac image> <kernel image> <rootfs system>"
    exit 1
}

OUTPUT_FILE="$1"
GPT_FILE="$2"
PRELOADER_FILE="$3"
ATF_FILE="$4"
UBOOT_FILE="$5"
WMAC_FILE="$6"
KERNEL_FILE="$7"
ROOTFS_FILE="$8"

BS=512
GPT_OFFSET=0	      # 0KB
PRELOADER_OFFSET=256  # 128KB
ATF_OFFSET=1024	      # 512KB
UBOOT_OFFSET=1536     # 768KB
WMAC_OFFSET=3584      # 1792KB
KERNEL_OFFSET=4096    # 2048KB
ROOTFS_OFFSET=135168  # 67584KB

dd bs="$BS" if="$GPT_FILE"            of="$OUTPUT_FILE"    seek="$GPT_OFFSET"
dd bs="$BS" if="$PRELOADER_FILE"      of="$OUTPUT_FILE"    seek="$PRELOADER_OFFSET"
dd bs="$BS" if="$ATF_FILE"            of="$OUTPUT_FILE"    seek="$ATF_OFFSET"
dd bs="$BS" if="$UBOOT_FILE"          of="$OUTPUT_FILE"    seek="$UBOOT_OFFSET"
dd bs="$BS" if="$WMAC_FILE"          of="$OUTPUT_FILE"    seek="$WMAC_OFFSET"
dd bs="$BS" if="$KERNEL_FILE"         of="$OUTPUT_FILE"    seek="$KERNEL_OFFSET" 
dd bs="$BS" if="$ROOTFS_FILE"         of="$OUTPUT_FILE"    seek="$ROOTFS_OFFSET" 
