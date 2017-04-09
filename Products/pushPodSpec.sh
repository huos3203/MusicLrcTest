#!/bin/sh

#  pushPodSpec.sh
#  LrcTest
#
#  Created by pengyucheng on 16/03/2017.
#  Copyright © 2017 PBBReader. All rights reserved.

# 1. 定义函数：函数名(){函数体 [return Int]}
# 2. 函数调用：fun名称 参数1 参数2。$n：函数内使用传入值0<n<10 .${n}获取无限制。
# 3. 函数返回：必须为整数，$?：获取函数返回值。不能返回字符串 。错误提示：“numeric argument required”。


# 索引文件绝对路径
specPath=$PROJECT_DIR/Products/MusicLrc.podspec
#托管私库名
repoNAME=podRepo
#远程托管库
repoURL=https://github.com/huos3203/PodRepo.git
#本地索引库库
repoPATH=`pod repo list | grep /.*${repoNAME}$ | sed 's/- Path: //g' | sed 's/- URL: //g'`

# 判断个人私库是否以clone到本地目录
funAddRepoToPod()
{
    echo "私库路径：$repoPATH"
    if [ -d "${repoPATH}" ]
    then
        echo "私库已被添加，返回本地路径"
    else
        echo "添加私库，并clone到本地,返回本地路径"
        pod repo add $1 $repoURL
    fi
}

#添加tag并push
funAddTagAndPush()
{

    #获取podspec文件中的tag值
    tag=`cat $specPath | grep 's.version' | sed -n '1p' | sed 's/s.*=//g' | sed 's/"//g' | sed 's/ //g'`
    echo "获取podspec文件中的tag值 ${tag}"
    git commit -m "新增版本：tag值 ${tag}"
    git tag ${tag}
    git push --tag
}

# 更新私库
funPushSpec()
{
    #指定新版本
    funAddTagAndPush

    # 验证未见合法性
    #pod lib lint

    #添加远程私库，并clone到本地
    funAddRepoToPod $1
    # 清理私库，便于维护更新索引文件
    cd $repoPATH
    echo "进入私库目录：`pwd`"
    #设置当前系统的 locale,支持中文路径
    #或在~/.profile文件中添加配置：export LANG=en_US.UTF-8
    export LC_CTYPE="zh_CN.UTF-8"
    git clean -f

    # 开始更新索引文件
    pod repo push $1 $2
}

#判断是否安装pod工具
PodInstalled=`gem list | grep 'cocoapod'`
if([[ $PodInstalled =~ "cocoapod" ]])  #判断是否包含字段
then
    echo "Pod已安装"
    funPushSpec $repoNAME $specPath
else
    sudo gem install cocoapods  #更新／安装
    exit 0
fi
