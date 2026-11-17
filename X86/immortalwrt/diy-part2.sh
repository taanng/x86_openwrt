#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Fix rust build failure: the openwrt-25.12 packages feed still ships rust 1.96.0,
# upgrade it to 1.96.1 (backport of immortalwrt/packages commit 1d995816576c).
# LLVM and src/bootstrap are identical between 1.96.0 and 1.96.1, so only
# PKG_VERSION / PKG_RELEASE / PKG_HASH need to be updated.
RUST_MAKEFILE=feeds/packages/lang/rust/Makefile
if [ -f "$RUST_MAKEFILE" ]; then
	sed -i 's/^PKG_VERSION:=1\.96\.0$/PKG_VERSION:=1.96.1/' "$RUST_MAKEFILE"
	sed -i 's/^PKG_RELEASE:=2$/PKG_RELEASE:=1/' "$RUST_MAKEFILE"
	sed -i 's/^PKG_HASH:=b99ce16cdf0ecfc761b585ac84d131b46733465a02f8ecd0ff2de9713c62ee09$/PKG_HASH:=77a6ff3003a4ad0cb00697b043c879e3e1a15d945b1a1f63818903bfc3fa8b98/' "$RUST_MAKEFILE"
	grep -E '^PKG_(VERSION|RELEASE|HASH):=' "$RUST_MAKEFILE"
else
	echo "ERROR: $RUST_MAKEFILE not found" >&2
	exit 1
fi
