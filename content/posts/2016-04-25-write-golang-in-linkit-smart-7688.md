---
title: 在 linkit smart 7688 寫 golang
author: appleboy
type: post
date: 2016-04-24T17:06:54+00:00
url: /2016/04/write-golang-in-linkit-smart-7688/
dsq_thread_id:
  - 4773041572
categories:
  - Embedded System
  - Golang
tags:
  - 7688
  - Docker
  - golang
  - mediatek

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/26010372204/in/dateposted-public/" title="7688_7688duo"><img src="https://i0.wp.com/farm2.staticflickr.com/1545/26010372204_a1dcf1e0fc_z.jpg?resize=640%2C391&#038;ssl=1" alt="7688_7688duo" data-recalc-dims="1" /></a>

很高興 [Mediatek][1] 在去年推出 [linkit smart 7688][2] 開發版，你可以把 7688 想成是一台迷你型 Router，如果不來拿開發，也可以當家用 Router 也是不錯的。7688 讓開發者可以在上面寫 [Node.js][3], Python 及 Native C，光是聽到 Node.js 就很興奮，用 JavaScript 控制硬體。但是本篇要介紹如何在 7688 執行 [Golang][4] 程式，其實不難，只要把 [OpenWrt][5] 支援 [gccgo][6] 及 [libgo][7] 即可。**底下步驟同步於我的 [Github Repo][8]**

<!--more-->

### 用 Docker 安裝 7688 環境

我建立了一個 [Dockerfile][9]，讓開發者可以透過 [Docker][10] 快速在任何作業系統產生開發環境，安裝步驟如下:

<pre><code class="language-bash">$ git clone https://github.com/appleboy/linkit-smart-7688-golang.git 
$ cd linkit-smart-7688-golang && docker build -t mt7688 .</code></pre>

開啟 7688 terminal 環境

<pre><code class="language-bash">$ docker run -ti --name 7688 mt7688 /bin/bash</code></pre>

### 啟動 gccgo 和 libgo

底下步驟教您如何打開 gccgo 及 libgo 選單。打開 `package/libs/toolchain/Makefile` 找到

<pre><code class="language-bash">define Package/ldd</code></pre>

在前面插入

<pre><code class="language-bash">define Package/libgo
$(call Package/gcc/Default)
  TITLE:=Go support library
  DEPENDS+=@INSTALL_GCCGO
  DEPENDS+=@USE_EGLIBC
endef

define Package/libgo/config
       menu "Configuration"
               depends EXTERNAL_TOOLCHAIN && PACKAGE_libgo

       config LIBGO_ROOT_DIR
               string
               prompt "libgo shared library base directory"
               depends EXTERNAL_TOOLCHAIN && PACKAGE_libgo
               default TOOLCHAIN_ROOT  if !NATIVE_TOOLCHAIN
               default "/"  if NATIVE_TOOLCHAIN

       config LIBGO_FILE_SPEC
               string
               prompt "libgo shared library files (use wildcards)"
               depends EXTERNAL_TOOLCHAIN && PACKAGE_libgo
               default "./usr/lib/libgo.so.*"

       endmenu
endef</code></pre>

找到

<pre><code class="language-bash">define Package/libssp/install</code></pre>

在前面插入

<pre><code class="language-bash">define Package/libgo/install
    $(INSTALL_DIR) $(1)/usr/lib
    $(if $(CONFIG_TARGET_avr32)$(CONFIG_TARGET_coldfire),,$(CP) $(TOOLCHAIN_DIR)/lib/libgo.so.* $(1)/usr/lib/)
endef</code></pre>

找到

<pre><code class="language-bash">$(eval $(call BuildPackage,ldd))</code></pre>

在前面插入

<pre><code class="language-bash">$(eval $(call BuildPackage,libgo))</code></pre>

打開 `toolchain/gcc/Config.in`

最後面插入

<pre><code class="language-bash">config INSTALL_GCCGO
    bool
    prompt "Build/install gccgo compiler?" if TOOLCHAINOPTS && !(GCC_VERSION_4_6 || GCC_VERSION_4_6_LINARO)
    default n
    help
        Build/install GNU gccgo compiler ?</code></pre>

打開 `toolchain/gcc/common.mk`

找到

<pre><code class="language-bash">TARGET_LANGUAGES:="c,c++$(if $(CONFIG_INSTALL_LIBGCJ),$(SEP)java)$(if $(CONFIG_INSTALL_GFORTRAN),$(SEP)fortran)"</code></pre>

取代成

<pre><code class="language-bash">TARGET_LANGUAGES:="c,c++$(if $(CONFIG_INSTALL_LIBGCJ),$(SEP)java)$(if $(CONFIG_INSTALL_GFORTRAN),$(SEP)fortran)$(if $(CONFIG_INSTALL_GCCGO),$(SEP)go)"</code></pre>

打開 Kernel Configuration

<pre><code class="language-bash">$ make menuconfig</code></pre>

  * Target System: Ralink RT288x/RT3xxx
  * Subtarget: MT7688 based boards
  * Target Profile: LinkIt7688

啟動 gccgo

<pre><code class="language-bash">-> Advanced configuration options
-> Toolchain options
-> Select Build/Install gccgo
-> C library implementation
-> Use eglibc</code></pre>

### 撰寫 golang hello world

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24407557644/in/dateposted-public/" title="Go-brown-side.sh"><img src="https://i1.wp.com/farm2.staticflickr.com/1622/24407557644_36087ca6de.jpg?resize=500%2C500&#038;ssl=1" alt="Go-brown-side.sh" data-recalc-dims="1" /></a>

用 `alias` 設定 mips gccgo 路徑

<pre><code class="language-bash">alias mips_gccgo='/root/openwrt/staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_glibc-2.19/bin/mipsel-openwrt-linux-gccgo -Wl,-R,/root/openwrt/staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_glibc-2.19/lib/gcc/mipsel-openwrt-linux-gnu/4.8.3 -L /root/openwrt/staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_glibc-2.19/lib'</code></pre>

hello world 程式

<pre><code class="language-go">package main

import "fmt"

func main() {
  fmt.Println("hello world")
}</code></pre>

編譯執行檔

<pre><code class="language-bash">$ mips_gccgo -Wall -o helloworld_static_libgo helloworld.go -static-libgo</code></pre>

在 7688 裝置內執行 `helloworld_static_libgo`

<pre><code class="language-bash">root@mylinkit:/tmp/7688# ./helloworld_static_libgo 
hello world</code></pre>

以上步驟就可以完成 hello world 程式，詳細步驟都記錄在 [linkit-smart-7688-golang][8]

 [1]: http://www.mediatek.com/zh-TW/
 [2]: https://labs.mediatek.com/site/global/developer_tools/mediatek_linkit_smart_7688/whatis_7688/index.gsp
 [3]: https://nodejs.org/en/
 [4]: https://golang.org/
 [5]: https://openwrt.org/
 [6]: https://golang.org/doc/install/gccgo
 [7]: https://github.com/golang/gofrontend/tree/master/libgo
 [8]: https://github.com/appleboy/linkit-smart-7688-golang
 [9]: https://github.com/appleboy/linkit-smart-7688-golang/blob/master/Dockerfile
 [10]: https://www.docker.com/