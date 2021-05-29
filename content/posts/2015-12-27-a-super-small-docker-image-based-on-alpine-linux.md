---
title: Alpine Linux 挑戰最小 docker image OS
author: appleboy
type: post
date: 2015-12-27T01:25:42+00:00
url: /2015/12/a-super-small-docker-image-based-on-alpine-linux/
dsq_thread_id:
  - 4436731322
categories:
  - Debian
  - Docker
  - Linux
  - Ubuntu
tags:
  - Alpine
  - Busybox
  - Docker
  - OpenWrt

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23885045552/in/datetaken-public/" title="Screen Shot 2015-12-27 at 9.17.22 AM"><img src="https://i1.wp.com/farm2.staticflickr.com/1582/23885045552_eb06df81c8.jpg?resize=500%2C123&#038;ssl=1" alt="Screen Shot 2015-12-27 at 9.17.22 AM" data-recalc-dims="1" /></a>

[Alpine Linux][1] 是一套極小安全又簡單的作業系統，在現今 [Docker][2] Images 裡面，最主要推崇的就是 [Ubuntu][3] 作業系統，但是令人詬病的是 Ubuntu 還是不夠小，今天看到 Alpine 在 docker 內的大小大約是 `5 MB`，看到這 size 大小，相信是令人很震撼，之前要是看到這 size 大概只有 [OpenWRT][4] 編譯 [BusyBox][5] 才有可能的大小，但是 OpenWRT 最主要還是缺乏很多目前 popular 的套件，所以 Alpine 幫你解決這問題，提供大量的 [Packages][6] 讓開發者使用。底下就可以看出 Alpine 擊敗目前盛行的 docker images 大小比較圖。

<!--more-->

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23366439263/in/datetaken-public/" title="Screen Shot 2015-12-27 at 9.04.43 AM"><img src="https://i1.wp.com/farm6.staticflickr.com/5635/23366439263_3a445d81f6_z.jpg?resize=640%2C107&#038;ssl=1" alt="Screen Shot 2015-12-27 at 9.04.43 AM" data-recalc-dims="1" /></a>

### 使用方式

我們來看看傳統 Ubuntu 的方式，安裝 [Redis][7] 工具

<div>
  <pre class="brush: bash; title: ; notranslate" title="">FROM ubuntu-debootstrap:14.04
RUN apt-get update -q \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy redis-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt
ENTRYPOINT ["redis-cli"]</pre>
</div>

用 Alpine 則是

<div>
  <pre class="brush: bash; title: ; notranslate" title="">FROM gliderlabs/alpine:3.3
RUN apk --update add redis
ENTRYPOINT ["redis-cli"]</pre>
</div>

後者執行的時間 (含裝系統) 總共需要 `14 秒` 大小為 `6.535 MB` 前者 Ubuntu 大小為 `88.09 MB` 差距還蠻大的。可能找時間把開發環境轉成 Alpine Docker 試試看，更多資料請參考：[Alpine Linux Docker image. Win at minimalism!][8]

 [1]: http://www.alpinelinux.org/
 [2]: https://www.docker.com/
 [3]: http://www.ubuntu.com/
 [4]: https://openwrt.org/
 [5]: https://busybox.net/
 [6]: https://pkgs.alpinelinux.org/packages
 [7]: http://redis.io/
 [8]: http://gliderlabs.viewdocs.io/docker-alpine/