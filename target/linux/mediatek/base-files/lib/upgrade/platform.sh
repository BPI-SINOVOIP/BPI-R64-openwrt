platform_do_upgrade() {                 
	local board=$(board_name)
	case "$board" in
	"bananapi,bpi-r64"*)
		echo "platform_do_upgrade file: $1"

		emmc_num=`tar -tvf "$1" | grep EMMC | wc -l`
		if [ $emmc_num != 0 ]; then
			echo "EMMC Kernel partion upgrade by platform_do_upgrade"
			tar -xOf "$1"  sysupgrade-BPI-R64-EMMC/kernel | mtd -e Kernel write - Kernel
			echo "EMMC rootfs partion upgrade by platform_do_upgrade"
			tar -xOf "$1"  sysupgrade-BPI-R64-EMMC/root | mtd -e rootfs write - rootfs
		fi
		
		sd_num=`tar -tvf "$1" | grep SD | wc -l`
		if [ $sd_num != 0 ]; then
			echo "SD Kernel partion upgrade by platform_do_upgrade"
			tar -xOf "$1"  sysupgrade-BPI-R64-SD/kernel | mtd -e Kernel write - Kernel
			echo "SD rootfs partion upgrade by platform_do_upgrade"
			tar -xOf "$1"  sysupgrade-BPI-R64-SD/root | mtd -e rootfs write - rootfs
		fi
		;;
	*)
		default_do_upgrade "$1"
		;;
	esac
}

PART_NAME=firmware

platform_check_image() {
	emmc_num=`tar -tvf "$1" | grep EMMC | wc -l`
	if [ $emmc_num != 0 ]; then
		tar -xvf "$1" sysupgrade-BPI-R64-EMMC/kernel -C /tmp
		file="/tmp/sysupgrade-BPI-R64-EMMC/kernel"
	else
		tar -xvf "$1" sysupgrade-BPI-R64-SD/kernel -C /tmp
		file="/tmp/sysupgrade-BPI-R64-SD/kernel"
	fi

	local board=$(board_name)
	local magic="$(get_magic_long "$file")"
	rm /tmp/sysupgrade-BPI-R64-* -rf

	[ "$#" -gt 1 ] && return 1                                               

	case "$board" in                                                       
	"bananapi,bpi-r64"*)
		[ "$magic" != "d00dfeed" ] && {   
			echo "Invalid image type."
			return 1
		}                                                    
		return 0                                             
		;;                                                   

	*)                                                           
		echo "Sysupgrade is not supported on your board yet."
		return 1                                             
		;;                                
	esac                                      

	return 0                                                                                         
}

platform_copy_config_emmc() {
#	mkdir -p /recovery
#	mount -o rw,noatime /dev/mmcblk0p1 /recovery
#	cp -af "$UPGRADE_BACKUP" "/recovery/$BACKUP_FILE"
	sync
#	umount /recovery
}

platform_copy_config() {
	case "$(board_name)" in
	"bananapi,bpi-r64"*)
		platform_copy_config_emmc
		;;
	esac
}

platform_pre_upgrade() {
	case "$(board_name)" in
	"bananapi,bpi-r64"*)
		echo "Umount Overlayfs and Partition here by platform_pre_upgrade"
                umount /overlay/
		rootfs_type=""
		;;
        esac
}

