INSTALL_TARGET_PROCESSES = Swifile
TARGET = iphone:clang:15.5:15.0

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = Swifile
Swifile_CODESIGN_FLAGS = -SSwifile/Swifile.entitlements

include $(THEOS_MAKE_PATH)/xcodeproj.mk
