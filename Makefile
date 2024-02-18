INSTALL_TARGET_PROCESSES = Swifile
TARGET = iphone:clang:15.5:15.0

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = Swifile
Swifile_CODESIGN_FLAGS = -SSwifile/Swifile.entitlements

all::
	make -C "RootHelper (Pascal)"
	cp "RootHelper (Pascal)/RootHelper" .theos/obj/debug/install_Swifile/Applications/Swifile.app/RootHelper

include $(THEOS_MAKE_PATH)/xcodeproj.mk
