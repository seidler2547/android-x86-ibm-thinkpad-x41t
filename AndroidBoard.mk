LOCAL_PATH := $(call my-dir)
TARGET_KERNEL_CONFIG := $(LOCAL_PATH)/x41t_defconfig
TARGET_INITRD_SCRIPTS := $(LOCAL_PATH)/x41t_info
TARGET_PREBUILT_APPS := $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/app/*))
$(call add-prebuilt-targets,$(TARGET_OUT),$(TARGET_PREBUILT_APPS))
TARGET_EXTRA_KERNEL_MODULES := wakeup_button phc-intel tp_smapi

include $(GENERIC_X86_ANDROID_MK)
