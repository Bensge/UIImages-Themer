include theos/makefiles/common.mk

TWEAK_NAME = UIImages
UIImages_FILES = Tweak.xm
UIImages_FRAMEWORKS	 = Foundation UIKit

#TARGET_CXX = xcrun -sdk iphoneos clang++

include $(THEOS_MAKE_PATH)/tweak.mk
