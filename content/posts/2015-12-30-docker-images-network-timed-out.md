---
title: Docker 下載 Images 遇到 Network timed out
author: appleboy
type: post
date: 2015-12-30T15:51:15+00:00
url: /2015/12/docker-images-network-timed-out/
dsq_thread_id:
  - 4447102270
categories:
  - Docker
tags:
  - Docker

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/22947137613/in/datetaken-public/" title="Docker"><img src="https://i2.wp.com/farm1.staticflickr.com/778/22947137613_69a88cb94b_z.jpg?resize=640%2C217&#038;ssl=1" alt="Docker" data-recalc-dims="1" /></a> 最近在弄 [Docker][1] 忽然發現不管怎麼樣都不能 Pull Images 下來，會噴出底下錯誤訊息

> Unable to find image 'corbinu/docker-phpmyadmin:latest' locally Pulling repository docker.io/corbinu/docker-phpmyadmin Network timed out while trying to connect to https://index.docker.io/v1/repositories/corbinu/docker-phpmyadmin/images. You may want to check your internet connection or if you are behind a proxy.<!--more-->

這也不知道是踩到 Docker 哪邊的雷，解決方式也很簡單，就是將 Docker Machine 重新開機就可以了

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ docker-machine restart default      # Restart the environment
$ eval $(docker-machine env default)  # Refresh your environment settings</pre>
</div>

另外在 [Mac][2] 環境要連 Docker 的開放 port 你必須先找到 Docker Machine 真正 IP 才可以，不要用 `localhost` 來連，因為根本沒有在本機端開啟這樣的 port，請用 [docker-machine][3] 指令來列出目前正在執行的 VM

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   ERRORS
default   *        virtualbox   Running   tcp://192.168.99.100:2376
$ docker-machine ip default
192.168.99.100
</pre>
</div>

記錄下來免得之後又遇到，常常發現找問題搜尋到自己的部落格 XD

 [1]: https://www.docker.com/
 [2]: http://www.apple.com/tw/mac/
 [3]: https://docs.docker.com/machine/