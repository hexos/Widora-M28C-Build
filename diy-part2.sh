#!/bin/bash
# diy-part2.sh

# --- 1. Golang 修复 (保留) ---
# 即使不编译 v2dat，保留新版 Go 也是个好习惯，防止其他依赖报错
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
./scripts/feeds install -p packages golang

# --- 2. 清理第三方源的冲突包 ---
# 我们使用 find 命令来通过文件夹名称精准查找并删除，比死记路径更管用
# 只要是 kenzo 或 small 目录下的 mosdns/adguardhome，统统删掉
find feeds/kenzo -name "mosdns" -type d -exec rm -rf {} +
find feeds/small -name "mosdns" -type d -exec rm -rf {} +
find feeds/kenzo -name "adguardhome" -type d -exec rm -rf {} +
find feeds/small -name "adguardhome" -type d -exec rm -rf {} +
find feeds/kenzo -name "luci-app-mosdns" -type d -exec rm -rf {} +
find feeds/small -name "luci-app-mosdns" -type d -exec rm -rf {} +
find feeds/kenzo -name "luci-app-adguardhome" -type d -exec rm -rf {} +
find feeds/small -name "luci-app-adguardhome" -type d -exec rm -rf {} +

# --- 3. 更新 feeds 并安装官方包 ---
./scripts/feeds update -a
./scripts/feeds install -a

# --- 4. 【核心修复】解决 MosDNS 文件冲突 ---
# 报错说 /etc/init.d/mosdns 冲突，那我们就把 luci-app-mosdns 里安装这个文件的命令删掉
# 既然核心包已经提供了，APP 包就不需要再提供了
sed -i '/\/etc\/init\.d\/mosdns/d' feeds/luci/applications/luci-app-mosdns/Makefile

# --- 5. 主题与风扇 (保留) ---
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-argon/luci-theme-design/g' feeds/luci/collections/luci/Makefile
#git clone https://github.com/garypang13/luci-app-fan.git package/luci-app-fan
