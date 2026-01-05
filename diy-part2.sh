#!/bin/bash
# diy-part2.sh

# --- 1. Golang 修复 (保留) ---
# 依然需要替换 Go，因为 v2dat 等其他插件可能需要新版 Go
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
./scripts/feeds install -p packages golang

# --- 2. 关键修正：清理 Kenzo 源的冲突包 (而不是清理官方的) ---
# 之前的错误在于删除了官方包。现在我们要反过来，
# 删除 Kenzo 源里的 AdGuardHome/MosDNS，强制系统使用 ImmortalWrt 官方自带的稳定版。

# 删除 Kenzo/Small 源里的冲突插件
rm -rf feeds/kenzo/adguardhome
rm -rf feeds/kenzo/mosdns
rm -rf feeds/kenzo/luci-app-adguardhome
rm -rf feeds/kenzo/luci-app-mosdns
rm -rf feeds/small/adguardhome
rm -rf feeds/small/mosdns
# (如果有的话，确保删干净，防止抢占)

# --- 3. 确保官方插件被正确安装 ---
# 因为上面删除了 Kenzo 的，现在 install -a 会自动挂载官方 feeds 里的同名包
./scripts/feeds update -a
./scripts/feeds install -a

# --- 4. 主题与风扇 (保留) ---
# 设置 Design 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-argon/luci-theme-design/g' feeds/luci/collections/luci/Makefile

# 强制拉取风扇控制
#git clone https://github.com/garypang13/luci-app-fan.git package/luci-app-fan
