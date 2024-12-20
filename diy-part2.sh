#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================


# update ubus git HEAD
cp -f $GITHUB_WORKSPACE/configfiles/ubus_Makefile package/system/ubus/Makefile


# 近期istoreos网站文件服务器不稳定，临时增加一个自定义下载网址
sed -i "s/push @mirrors, 'https:\/\/mirror2.openwrt.org\/sources';/&\\npush @mirrors, 'https:\/\/github.com\/xiaomeng9597\/files\/releases\/download\/iStoreosFile';/g" scripts/download.pl



# 修改内核配置文件
sed -i "/.*CONFIG_ROCKCHIP_RGA2.*/d" target/linux/rockchip/rk35xx/config-5.10
# sed -i "/# CONFIG_ROCKCHIP_RGA2 is not set/d" target/linux/rockchip/rk35xx/config-5.10
# sed -i "/CONFIG_ROCKCHIP_RGA2_DEBUGGER=y/d" target/linux/rockchip/rk35xx/config-5.10
# sed -i "/CONFIG_ROCKCHIP_RGA2_DEBUG_FS=y/d" target/linux/rockchip/rk35xx/config-5.10
# sed -i "/CONFIG_ROCKCHIP_RGA2_PROC_FS=y/d" target/linux/rockchip/rk35xx/config-5.10




# 替换dts文件
cp -f $GITHUB_WORKSPACE/configfiles/rk3566-jp-tvbox.dts target/linux/rockchip/dts/rk3568/rk3566-jp-tvbox.dts

cp -f $GITHUB_WORKSPACE/configfiles/rk3566-panther-x2.dts target/linux/rockchip/dts/rk3568/rk3566-panther-x2.dts

cp -f $GITHUB_WORKSPACE/configfiles/rk3568-dg-nas-lite-core.dtsi target/linux/rockchip/dts/rk3568/rk3568-dg-nas-lite-core.dtsi

cp -f $GITHUB_WORKSPACE/configfiles/rk3568-dg-nas-lite.dts target/linux/rockchip/dts/rk3568/rk3568-dg-nas-lite.dts



#修改uhttpd配置文件，启用nginx
# sed -i "/.*uhttpd.*/d" .config
# sed -i '/.*\/etc\/init.d.*/d' package/network/services/uhttpd/Makefile
# sed -i '/.*.\/files\/uhttpd.init.*/d' package/network/services/uhttpd/Makefile
sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config
cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/





#轮询检查ubus服务是否崩溃，崩溃就重启ubus服务
cp -f $GITHUB_WORKSPACE/configfiles/httpubus package/base-files/files/etc/init.d/httpubus
cp -f $GITHUB_WORKSPACE/configfiles/ubus-examine.sh package/base-files/files/bin/ubus-examine.sh
chmod 755 package/base-files/files/etc/init.d/httpubus
chmod 755 package/base-files/files/bin/ubus-examine.sh



#集成黑豹X2和荐片TV盒子无线功能并且开启无线功能
cp -a $GITHUB_WORKSPACE/configfiles/firmware/* package/firmware/
cp -f $GITHUB_WORKSPACE/configfiles/opwifi package/base-files/files/etc/init.d/opwifi
chmod 755 package/base-files/files/etc/init.d/opwifi
sed -i "s/wireless.radio\${devidx}.disabled=1/wireless.radio\${devidx}.disabled=0/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh



#集成CPU性能跑分脚本
cp -a $GITHUB_WORKSPACE/configfiles/coremark/* package/base-files/files/bin/
chmod 755 package/base-files/files/bin/coremark
chmod 755 package/base-files/files/bin/coremark.sh




rm -f target/linux/rockchip/rk35xx/base-files/etc/board.d/02_network
cp -f $GITHUB_WORKSPACE/configfiles/02_network target/linux/rockchip/rk35xx/base-files/etc/board.d/02_network


# 增加nsy-g68-plus
echo -e "\\ndefine Device/nsy_g68-plus
\$(call Device/rk3568)
  DEVICE_VENDOR := NSY
  DEVICE_MODEL := G68PLUS
  DEVICE_DTS := rk3568-nsy-g68-plus1
  SUPPORTED_DEVICES += nsy,g68-plus
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-hwmon-pwmfan kmod-leds-pwm kmod-r8125 kmod-r8168 kmod-switch-rtl8367b swconfig
endef
TARGET_DEVICES += nsy_g68-plus" >> target/linux/rockchip/image/rk35xx.mk



cp -f $GITHUB_WORKSPACE/configfiles/rk3568-nsy-g68-plus1.dts target/linux/rockchip/dts/rk3568/rk3568-nsy-g68-plus1.dts

# 增加ys-ec588
echo -e "\\ndefine Device/ys-ec588
\$(call Device/rk3588)
  DEVICE_VENDOR := YS
  DEVICE_MODEL := EC588
  DEVICE_DTS := rk3588-ys-ec588
  SUPPORTED_DEVICES += ys,ec588
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core kmod-thermal kmod-hwmon-pwmfan kmod-leds-pwm kmod-r8125 kmod-r8168
endef
TARGET_DEVICES += ys-ec588" >> target/linux/rockchip/image/rk35xx.mk



cp -f $GITHUB_WORKSPACE/configfiles/rk3588-ys-ec588.dts target/linux/rockchip/dts/rk3588/rk3588-ys-ec588.dts

