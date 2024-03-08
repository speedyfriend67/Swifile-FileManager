#!/usr/bin/env bash
set -e

# Taken from Geranium's ipabuild!

APP=Swifile
TARGET=Debug

rm -rf build
rm -rf Payload
rm -f $APP.tipa
mkdir build
mkdir Payload

echo "Set the ARCHS and SYSROOT variables before continuing!"

make -C RootHelper

xcodebuild -project ./$APP.xcodeproj -scheme $APP -configuration $TARGET \
	-derivedDataPath ./build/DerivedData -destination 'generic/platform=iOS' \
	ONLY_ACTIVE_ARCH="NO" CODE_SIGNING_ALLOWED="NO"

APP_PATH="./build/DerivedData/Build/Products/$TARGET-iphoneos/$APP.app"
cp -r $APP_PATH ./build
cp RootHelper/RootHelper ./build/$APP.app/RootHelper

codesign --remove "./build/$APP.app"
ldid -S"./Swifile/Swifile.entitlements" "./build/$APP.app/$APP"

cp -r "./build/$APP.app" Payload/
zip -vr $APP.tipa Payload


