---
title: '[FreeBSD] port committer 快速建立 pkg-plist'
author: appleboy
type: post
date: 2009-11-18T08:51:12+00:00
url: /2009/11/freebsd-port-committer-快速建立-pkg-plist/
views:
  - 3043
bot_views:
  - 295
dsq_thread_id:
  - 246930368
categories:
  - FreeBSD
tags:
  - FreeBSD

---
在 [FreeBSD][1] 系統裡，最常使用就是管理安裝 ports，之前寫過一篇如何 commit update ports :『[[FreeBSD] send-pr porter committer 需要注意事項][2]』，根據 [FreeBSD Porter's Handbook][3] 裡頭，寫到 [pkg-plist][4] 檔案內容是根據 ports 所產生的檔案列表，可以參考 [Automated package list creation][5] 這篇來快速產生，而我自己把該篇寫成 shell script 來直接產生，再來利用 diff 的方式來看看有無需要修改或者是增加，底下就是 shell script 內容： 

<pre class="brush: bash; title: ; notranslate" title="">#!/usr/local/bin/bash
###############################################
#
# Date:	    2009.11.18
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:	    http://blog.wu-boy.com
# Ref:	    http://www.freebsd.org/doc/en/books/porters-handbook/plist-autoplist.html
#
###############################################

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$#" -lt "2" ]; then
    echo "please give two argument"
    echo "example $0 /tmp/dir1 /tmp/dir2"
    exit
fi

#
# configure system parameters

HOME=$1
TARGET=$2
TMPDIR="/var/tmp"

#
# configure end

if [ ! -d "$HOME" ]; then
    echo "${HOME} is not directory"
    exit
fi

if [ "$TARGET" != "" ] && [ ! -d "$TARGET" ]; then
    echo "$TARGET will be created"
    mkdir -p $TARGET
fi

#
# clean ports file

cd $HOME && make clean

#
# get port name 

PORTNAME=$(make -V PORTNAME)

#
# Before create port directory, please delete it.
# Next, create a temporary directory tree into which your port can be installed, and install any dependencies.
rm -rf ${TMPDIR}/${PORTNAME}
if [ ! -d "${TMPDIR}/${PORTNAME}" ]; then
    echo "${TMPDIR}/${PORTNAME} will be created"
    mkdir -p ${TMPDIR}/${PORTNAME}
fi

mtree -U -f $(make -V MTREE_FILE) -d -e -p ${TMPDIR}/${PORTNAME}
make depends PREFIX=${TMPDIR}/$PORTNAME

#
# Store the directory structure in a new file.

cd ${TMPDIR}/${PORTNAME} && find -d * -type d | sort > ${TARGET}/OLD-DIRS

#
# If your port honors PREFIX (which it should) you can then install the port and create the package list.

cd $HOME && make install PREFIX=${TMPDIR}/${PORTNAME}
cd ${TMPDIR}/${PORTNAME} && find -d * \! -type d | sort > ${TARGET}/pkg-plist

#
# You must also add any newly created directories to the packing list.

cd ${TMPDIR}/${PORTNAME} && find -d * -type d | sort | comm -13 ${TARGET}/OLD-DIRS - | sort -r | sed -e 's#^#@dirrm #' >> ${TARGET}/pkg-plist

echo "Please check  ${TARGET}/pkg-plist file"
</pre> 用法大概是： ./create_pkg.sh /root/phpbb3 /root/test /root/phpbb3 是你修改 ports 的資料夾 /root/test 是 pkg-plist 新的資料夾

 [1]: http://www.freebsd.org/
 [2]: http://blog.wu-boy.com/2009/09/22/1670/
 [3]: http://www.freebsd.org/doc/en/books/porters-handbook/
 [4]: http://www.freebsd.org/doc/en/books/porters-handbook/porting-desc.html#AEN100
 [5]: http://www.freebsd.org/doc/en/books/porters-handbook/plist-autoplist.html