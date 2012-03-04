#
# Copyright (C) 2009-2011 The Android-x86 Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#

#ifeq (x,y)

LOCAL_PATH := $(my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := wakeup_button
#LOCAL_MODULE_TAGS := optional

#EXTRA_KERNEL_MODULE_$(LOCAL_MODULE) := $(LOCAL_MODULE)
EXTRA_KERNEL_MODULE_PATH_$(LOCAL_MODULE) := $(LOCAL_PATH)

#(call add-dependency,$(INSTALLED_FILES_FILE),$(EXTRA_KERNEL_MODULE_$(LOCAL_MODULE))))
#kernel: ALL_EXTRA_KERNEL_MODULES += EXTRA_KERNEL_MODULE_$(LOCAL_MODULE)

#.PHONY: EXTRA_KERNEL_MODULE_$(LOCAL_MODULE)
#ALL_EXTRA_KERNEL_MODULES += $(EXTRA_KERNEL_MODULE_$(LOCAL_MODULE))

#KBUILD_OUTPUT := $(CURDIR)/$(TARGET_OUT_INTERMEDIATES)/kernel
#local_mk_kernel := + $(hide) $(MAKE) -C $(CURDIR)/kernel INSTALL_MOD_PATH=$(CURDIR)/$(TARGET_OUT) O=$(KBUILD_OUTPUT) ARCH=$(TARGET_ARCH) M=$(CURDIR)/$(LOCAL_PATH) $(if $(SHOW_COMMANDS),V=1)
#ifneq ($(TARGET_ARCH),$(HOST_ARCH))
#local_mk_kernel += CROSS_COMPILE=$(CURDIR)/$(TARGET_TOOLS_PREFIX)
#endif

#KERNEL_CONFIG_FILE := $(if $(wildcard $(CURDIR)/$(TARGET_KERNEL_CONFIG)),$(CURDIR)/$(TARGET_KERNEL_CONFIG),kernel/arch/$(TARGET_ARCH)/configs/$(TARGET_KERNEL_CONFIG))
#KERNELRELEASE := $(shell $(MAKE) -sC $(CURDIR)/kernel O=$(KBUILD_OUTPUT) ARCH=$(TARGET_ARCH) KCONFIG_CONFIG=$(KERNEL_CONFIG_FILE) kernelrelease)
#LOCAL_BUILT_MODULE := $(TARGET_OUT)/lib/modules/$(KERNELRELEASE)/extra/$(LOCAL_MODULE).ko
#LOCAL_MODULE_SUFFIX := .ko

#include $(BUILD_SYSTEM)/base_rules.mk

#$(LOCAL_BUILT_MODULE): kernel
#	$(local_mk_kernel) modules modules_install
#	$(local_mk_kernel) clean
#	@echo $@
#	@echo $(KERNELRELEASE)
#	@echo $(local_mk_kernel) modules modules_install
#	$(local_mk_kernel) modules modules_install
#	mkdir -p $(LOCAL_KBUILD_OUTPUT)
#	$(local_mk_kernel) M=$(CURDIR)/$(TEST_LOCAL_PATH) INSTALL_MOD_PATH=$(CURDIR)/$(TARGET_OUT) modules modules_install
#	$(mk_kernel) M=$(CURDIR)/$(TEST_LOCAL_PATH) INSTALL_MOD_PATH=$(CURDIR)/$(TARGET_OUT) modules modules_install

#ALL_EXTRA_KERNEL_MODULES += $(EXTRA_KERNEL_MODULE_$(LOCAL_MODULE))
#ALL_DEFAULT_INSTALLED_MODULES += $(LOCAL_BUILT_MODULE)

#endif