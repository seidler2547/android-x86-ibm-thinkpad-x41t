PRODUCT_PACKAGES := $(THIRD_PARTY_APPS)
#PRODUCT_PACKAGES += sensors.$(TARGET_PRODUCT)
PRODUCT_PACKAGES += lights.$(TARGET_PRODUCT)
#PRODUCT_PACKAGES += sensors.hdaps
PRODUCT_PACKAGES += wacom-input

#PRODUCT_COPY_FILES := \
#    $(LOCAL_PATH)/vold.fstab:system/etc/vold.fstab \

$(call inherit-product,$(SRC_TARGET_DIR)/product/generic_x86.mk)

USE_SQUASHFS := 0

PRODUCT_NAME := thinkpad_x41t
PRODUCT_DEVICE := x41t
PRODUCT_MANUFACTURER := ibm

DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlays

#PRODUCT_COPY_FILES += \
#	$(LOCAL_PATH)/init.x41t.sh:system/etc/init.x41t.sh
#	$(LOCAL_PATH)/asound.conf:system/etc/asound.conf

include $(call all-subdir-makefiles)
