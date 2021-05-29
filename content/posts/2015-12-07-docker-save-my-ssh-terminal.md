---
title: Docker 救了 Debian SSH terminal
author: appleboy
type: post
date: 2015-12-07T02:17:38+00:00
url: /2015/12/docker-save-my-ssh-terminal/
dsq_thread_id:
  - 4381942543
categories:
  - Debian
  - Linux
  - Ubuntu
tags:
  - Debian
  - Docker

---
<div style="margin:0 auto; text-align:center">
  <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/22947137613/in/datetaken-public/" title="Docker"><img src="https://i2.wp.com/farm1.staticflickr.com/778/22947137613_69a88cb94b_z.jpg?resize=640%2C217&#038;ssl=1" alt="Docker" data-recalc-dims="1" /></a>
</div>

上週在處理實體機器時，不小心下了底下指令

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ dpkg --purge --force-all zlib1g</pre>
</div>

造成系統所有相關指令都不能使用，像是 ssh, scp, fetch, wget 等跟網路相關的指令都會出現底下錯誤訊息

<div>
  <pre class="brush: bash; title: ; notranslate" title="">curl: error while loading shared libraries: libz.so.1: cannot open shared object file: No such file or directory</pre>
</div>

本來想說可以透過指令將檔案抓回來，放回去就可以恢復了，但是所有指令幾乎都不能用，連 [git][1] 也出現該錯誤訊息，這時候最怕 terminal 斷線，如果斷線了，就要到機房去處理問題了。最後想到用 [Docker][2] 來處理，簡單幾個步驟就可以將檔案抓回來了

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># 抓 debian images
$ docker pull debian:7
# 進入 docker
$ docker run -t -i debian:7 /bin/bash
# 從 docker 複製檔案到 home 目錄，其中 e1bf3950b16c docker id
$ docker cp e1bf3950b16c:/lib/x86_64-linux-gnu /home/</pre>
</div>

完成後，在去 x86_64-linux-gnu 找到 libz.so.1 丟到相對應目錄就可以了，結論就是：好險平常有裝 docker 習慣 XD

 [1]: https://git-scm.com/
 [2]: https://www.docker.com/