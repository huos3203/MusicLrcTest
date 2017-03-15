#!/bin/sh

#  buildNumber.sh
#  LrcTest
#
#  Created by pengyucheng on 15/03/2017.
#  Copyright © 2017 PBBReader. All rights reserved.

#递增build版本号，重命名app带版本号的文件名称
#递增版本号
#方法一：获取上一版本号并递增
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
buildNumber=$(($buildNumber + 1))
echo $buildNumber
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"

#方法二：直接修改指定版本号
#pwd
#PLIST_FILE_PATH=${PROJECT_DIR}/'PBBReader-Info.plist'
#buildVersion=13
#ImportSVN="importSVN"

#echo $PLIST_FILE_PATH
#echo "/<key>CFBundleVersion<\/key>/{ n; s/\(<string>\).*\(<\/string>\)/\1${buildVersion}\2/;}" ${PLIST_FILE_PATH}

#sed -i '' "/<key>CFBundleVersion<\/key>/{ n; s/\(<string>\).*\(<\/string>\)/\1${buildVersion}\2/;}" ${PLIST_FILE_PATH}

