TARGET := iphone:clang:latest:8.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MinhayaFaker

MinhayaFaker_FRAMEWORKS = Foundation
MinhayaFaker_FILES = Tweak.x
MinhayaFaker_CFLAGS = -fobjc-arc
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS_MAKE_PATH)/tweak.mk

