#!/bin/bash
# diy-part2.sh

# =========================================================
# 1. 基础依赖与冲突修复 (必须保留，否则编译报错)
# =========================================================

# --- Golang 修复 ---
# 为了支持 v2dat 等新插件，必须替换 Go 版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
./scripts/feeds install -p packages golang

# --- 清理 Kenzo/Small 源的冲突包 ---
# 强制删除第三方源里的 MosDNS 和 AdGuardHome，使用 ImmortalWrt 官方稳定版
find feeds/kenzo -name "mosdns" -type d -exec rm -rf {} +
find feeds/small -name "mosdns" -type d -exec rm -rf {} +
find feeds/kenzo -name "adguardhome" -type d -exec rm -rf {} +
find feeds/small -name "adguardhome" -type d -exec rm -rf {} +
find feeds/kenzo -name "luci-app-mosdns" -type d -exec rm -rf {} +
find feeds/small -name "luci-app-mosdns" -type d -exec rm -rf {} +
find feeds/kenzo -name "luci-app-adguardhome" -type d -exec rm -rf {} +
find feeds/small -name "luci-app-adguardhome" -type d -exec rm -rf {} +

# --- 更新并安装 feeds ---
./scripts/feeds update -a
./scripts/feeds install -a

# --- 解决 MosDNS 启动脚本冲突 ---
# 删除 luci-app-mosdns 对 /etc/init.d/mosdns 的安装指令
sed -i '/\/etc\/init\.d\/mosdns/d' feeds/luci/applications/luci-app-mosdns/Makefile


# =========================================================
# 2. 系统个性化设置 (主题、风扇、IP)
# =========================================================

# --- 设置默认主题为 Design ---
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-argon/luci-theme-design/g' feeds/luci/collections/luci/Makefile

# --- 强制拉取风扇控制界面 ---
#git clone https://github.com/garypang13/luci-app-fan.git package/luci-app-fan

# --- 修改默认 LAN IP 地址 ---
# 将默认的 192.168.1.1 修改为 192.168.6.1 (防止光猫冲突)
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate


# =========================================================
# 3. Wi-Fi 自动化配置 (开启、改名、设密码)
# =========================================================

# 创建配置脚本目录
mkdir -p files/etc/uci-defaults

# 生成首次启动脚本
cat << 'EOF' > files/etc/uci-defaults/99-custom-wifi
#!/bin/sh

# 1. 默认开启 Wi-Fi (解除 disabled 状态)
uci set wireless.@wifi-device[0].disabled='0'
uci set wireless.@wifi-device[1].disabled='0'

# 2. 配置 5G Wi-Fi (通常是 iface[0]，如果反了就和下面对调)
uci set wireless.@wifi-iface[0].ssid='Widora_5G'
uci set wireless.@wifi-iface[0].key='password123'
uci set wireless.@wifi-iface[0].encryption='psk2'

# 3. 配置 2.4G Wi-Fi
uci set wireless.@wifi-iface[1].ssid='Widora_2.4G'
uci set wireless.@wifi-iface[1].key='password123'
uci set wireless.@wifi-iface[1].encryption='psk2'

# 4. 提交配置并应用
uci commit wireless
wifi reload

exit 0
EOF

# =========================================================
# 脚本结束
# =========================================================
