INSTALL_TARGET_PROCESSES = Swifile
TARGET = iphone:clang:15.5:15.0

include $(THEOS)/makefiles/common.mk

export SYSROOT
export ARCHS

XCODEPROJ_NAME = Swifile
Swifile_CODESIGN_FLAGS = -SSwifile/Swifile.entitlements

after-stage::
	make -C RootHelper
	cp RootHelper/RootHelper $(THEOS_STAGING_DIR)/Applications/Swifile.app/RootHelper

include $(THEOS_MAKE_PATH)/xcodeproj.mk
