---
title: Caddy 搭配 Drone 伺服器設定
author: appleboy
type: post
date: 2017-02-07T06:46:53+00:00
url: /2017/02/caddy-setting-with-drone-ci-server/
dsq_thread_id:
  - 5529104966
categories:
  - Docker
  - Golang
tags:
  - caddy
  - Docker
  - drone
  - golang
  - nginx

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/32758934825/in/dateposted-public/" title="The_Caddy_web_server_logo.svg"><img src="https://i0.wp.com/c1.staticflickr.com/1/528/32758934825_665c449ff3_z.jpg?resize=640%2C138&#038;ssl=1" alt="The_Caddy_web_server_logo.svg" data-recalc-dims="1" /></a>

## 緣由

[Caddy][1] 是一套 [HTTP/2][2] 伺服器，你可以想成跟 [Nginx][3] 是同一種角色，但是 Caddy 有一點不一樣的地方就是自動支援 HTTPS 設定，也就是 Caddy 幫網站自動申請 [Letsencrypt][4] 憑證，開發者不需要擔心憑證會過期，Caddy 會定期幫忙更換。[Drone][5] 則是一套以 [Docker][5] 為基礎的 [Continuous Integration][6] 平台。就在上個月 Caddy 發佈了 [0.9.5][7] 版本，更新過後，發現 [Drone][8] 的 WebSocket 連線會斷線又連線，底下來看看 Caddy 更動了什麼造成 WebSocket 連線失效。

<!--more-->

## Caddy 預設將 HTTP Timeouts 啟動

在 `0.9.5` 版本以前，Caddy 預設是沒有將 [Timeouts][9] 模組載入，所以只要使用底下設定就可以成功串起 Drone 服務

<pre><code class="language-bash">example.com {
  proxy / localhost:8000 {
    websocket
    transparent
  }
}</code></pre>

Drone 預設跑 8000 Port，另外在 Agent 跑 wss 連線

<pre><code class="language-bash">export DRONE_SERVER="wss://example.com/ws/broker"</code></pre>

Caddy 在 `0.9.5` 版本啟動 Timeouts 模組，也就是沒有支援 long connection，預設值如下

  * read: 10s (time spent reading request headers and body)
  * header: 10s (time spent reading just headers; not used until Go 1.8 is released)
  * write: 20s (starts at reading request body, ends when finished writing response body)
  * idle: 2m (time to hold connection between requests; not used until Go 1.8 is released)

也就是每 10 秒就會自動斷線在連線，解決方式也不難，就是把 Timeouts 模組關閉

<pre><code class="language-bash">example.com {
  # please comment the timeouts configures
  # if caddy server version under 0.9.5
  timeouts none
  proxy / localhost:8000 {
    websocket
    transparent
  }
}</code></pre>

這樣就可以解決 Drone 搭配 Caddy 0.9.5 版本的問題，請注意 `timeouts` 只支援 `0.9.5` 以上版本，非此版本就會出現底下錯誤

> Parse error: unknown property 'timeouts'

## 結論

大家可以盡快更新 Caddy，因為在 `0.9.5` 版本強化了 Proxy 效能。更多更新可以直接參考 [Release Notes][7]。

 [1]: https://caddyserver.com/
 [2]: https://zh.wikipedia.org/zh-tw/HTTP/2
 [3]: https://nginx.org/
 [4]: https://letsencrypt.org/
 [5]: https://www.docker.com/
 [6]: https://en.wikipedia.org/wiki/Continuous_integration
 [7]: https://github.com/mholt/caddy/releases/tag/v0.9.5
 [8]: https://github.com/drone/drone
 [9]: https://caddyserver.com/docs/timeouts