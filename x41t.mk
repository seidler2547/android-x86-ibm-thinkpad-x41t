PRODUCT_PACKAGES := $(THIRD_PARTY_APPS)

$(call inherit-product,$(SRC_TARGET_DIR)/product/generic_x86.mk)

PRODUCT_NAME := thinkpad_x41t
PRODUCT_DEVICE := x41t
PRODUCT_MANUFACTURER := ibm
#PRODUCT_PACKAGE_OVERLAYS := device/viewsonic/viewpad10/overlays

USE_SQUASHFS := 0

#PRODUCT_COPY_FILES += \
#	$(LOCAL_PATH)/init.x41t.sh:system/etc/init.x41t.sh
#	$(LOCAL_PATH)/asound.conf:system/etc/asound.conf

include $(call all-subdir-makefiles)
