#!/bin/sh

#  CommonDylib.sh
#  LrcTest
#
#  Created by pengyucheng on 15/03/2017.
#  Copyright © 2017 PBBReader. All rights reserved.
#http://www.cocoachina.com/industry/20140613/8810.html
##1.分别编译生成真机和模拟器使用的framework；
# 2.使用lipo命令将其合并成一个通用framework；
# 3.最后将生成的通用framework放置在工程根目录下新建的Products目录下。

# Sets the target folders and the final framework product.
#FMK_NAME=${PROJECT_NAME}
FMK_NAME=MusicLRC
DRM_DIR="${HOME}/git-svn/DRM2.X/DRM/Libs/MusicLRCSDK/${FMK_NAME}.framework"
if  [ -d "${DRM_DIR}" ]
then
    echo "当前在pengyucheng主机上"
else
    echo "仅支持在pengyucheng主机上更新MusicLRCSDK"
    exit 0
fi

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework

# Working dir will be deleted after the framework creation.
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

# -configuration ${CONFIGURATION}
# Clean and Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos clean build
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator clean build

# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"

# 拷贝至DRM项目中，更新动态包
#echo "cp -R ${INSTALL_DIR}/ ${DRM_DIR}/"
#cp -R "${INSTALL_DIR}/" "${DRM_DIR}"

rm -r "${WRK_DIR}"
