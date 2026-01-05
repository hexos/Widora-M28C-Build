#!/bin/bash
# diy-part1.sh

# 1. 添加 iStoreOS 核心源 (首页、商店、依赖)
echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default

# 2. 添加 Kenzo 源 (OpenClash, MosDNS, Modemband)
# Kenzo 是目前最全的源，用来替代失效的 Sirpdboy
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
