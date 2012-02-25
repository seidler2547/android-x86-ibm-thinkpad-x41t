#!/bin/bash

# sanity test
[ -d prebuilt ] || { echo "You need to run this script from the top of an Android source tree"; exit 1; }

MYDIR="$(readlink -f $(dirname $0))"

# build toolchain
[ -e prebuilt/linux-x86/toolchain/i686-android-linux-4.4.3/build-toolchain.sh ] && {
    cd prebuilt
    git apply "$MYDIR/prebuilt.patch"
    cd ../ndk
    git apply "$MYDIR/ndk.patch"
    cd ..
    prebuilt/linux-x86/toolchain/i686-android-linux-4.4.3/build-toolchain.sh &
}

# apply kernel patches
cd kernel
git status kernel/power/suspend.c | tail -1 | grep -q 'nothing to commit' && git apply "$MYDIR/kernel-suspend.patch"
git status drivers/platform/x86/thinkpad_acpi.c | tail -1 | grep -q 'nothing to commit' && git apply "$MYDIR/thinkpad_acpi.patch"
cd ..

[ -e buildspec.mk ] || cp "$MYDIR/buildspec.mk" buildspec.mk

wait
