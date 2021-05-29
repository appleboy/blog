---
title: 用 Caddy 申請 Let’s Encrypt Wildcard 憑證
author: appleboy
type: post
date: 2018-07-27T03:33:34+00:00
url: /2018/07/caddy-lets-encrypt-wildcard-certificate/
dsq_thread_id:
  - 6819800498
categories:
  - Caddy
  - DevOps
tags:
  - caddy
  - Letsencrypt
  - SSL

---
[<img src="https://i2.wp.com/farm1.staticflickr.com/846/42761134805_c4ab2e9168_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-07-27 at 11.29.44 AM" data-recalc-dims="1" />][1] 2018 年 3 月 [Let's Encrypt][2] 官方正式公告[支援 Wildcard Certificate 憑證][3]，有在玩多個 subdomain 有福了，未來只要申請一張 `*.example.com` 就全部通用啦，當然很高興 [Caddy][4] 也跟進了，在 [v11.0][5] 正式支援多種 DNS Provider，只要申請 DNS 提供商的 API Key 或 Secret 設定在啟動 Caddy 步驟內就可以了。底下用 [Godaddy][6] 舉例。 <!--more-->

## 申請 Godaddy API Key 請直接上 

[Godaddy 開發者網站][7]申請，就可以正式拿到 Key 跟 Secret [<img src="https://i0.wp.com/farm1.staticflickr.com/922/43663781331_ea6b26d29a_z.jpg?w=840&#038;ssl=1" alt="https___developer_godaddy_com_keys__🔊" data-recalc-dims="1" />][8] 

## 下載 Caddy 執行檔 可以直接到

[官方網站][9]下載，請記得選擇您的 DNS Provider plugin 才可以 [<img src="https://i0.wp.com/farm1.staticflickr.com/837/43617522682_96e20797cd_z.jpg?w=840&#038;ssl=1" alt="Download_Caddy_🔊" data-recalc-dims="1" />][10] 接著點選左下角的 Download 按鈕，下方會顯示可以透過 CURL 方式來安裝 

<pre class="brush: plain; title: ; notranslate" title="">$ curl https://getcaddy.com | bash -s personal http.cache,http.expires,tls.dns.godaddy
</pre> 直接把上面的指令貼到 Linux Console 上，這樣系統會預設將 Caddy 安裝到 

`/usr/local/bin` 底下。 

## Caddy 設定檔並啟動 打開您的 

`Caddyfile` 或者是其他檔案。裡面寫入 

<pre class="brush: plain; title: ; notranslate" title="">*.design.wu-boy.com {
    proxy / localhost:8081 {
        websocket
    }

    tls {
        dns godaddy
    }
}
</pre> 請注意 dns 區域，請填上 DNS Provider，如果不知道要填什麼值，可以參考

[線上文件][11]，完成後可以透過底下指令啟動: 

<pre class="brush: plain; title: ; notranslate" title="">$ GODADDY_API_KEY=xxxx \
GODADDY_API_SECRET=xxxx \
CADDYPATH=/etc/caddy/ssl \
caddy -conf=/etc/caddy/Caddyfile
</pre> 啟動後，可以打開網頁測試看看 

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/29794179438/in/dateposted-public/" title="Screenshot_2018_7_27__11_25_AM"><img src="https://i1.wp.com/farm1.staticflickr.com/914/29794179438_c3c1bf80a3_z.jpg?resize=640%2C292&#038;ssl=1" alt="Screenshot_2018_7_27__11_25_AM" data-recalc-dims="1" /></a>

 [1]: https://www.flickr.com/photos/appleboy/42761134805/in/dateposted-public/ "Screen Shot 2018-07-27 at 11.29.44 AM"
 [2]: https://letsencrypt.org/
 [3]: https://community.letsencrypt.org/t/acme-v2-production-environment-wildcards/55578
 [4]: https://caddyserver.com/
 [5]: https://caddyserver.com/blog/caddy-0_11-released
 [6]: https://tw.godaddy.com/
 [7]: https://developer.godaddy.com/keys
 [8]: https://www.flickr.com/photos/appleboy/43663781331/in/dateposted-public/ "https___developer_godaddy_com_keys__🔊"
 [9]: https://caddyserver.com/download
 [10]: https://www.flickr.com/photos/appleboy/43617522682/in/dateposted-public/ "Download_Caddy_🔊"
 [11]: https://caddyserver.com/docs/automatic-https