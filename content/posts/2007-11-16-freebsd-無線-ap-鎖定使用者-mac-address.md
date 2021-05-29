---
title: '[FreeBSD] 無線 AP 鎖定使用者 MAC Address'
author: appleboy
type: post
date: 2007-11-16T11:23:39+00:00
url: /2007/11/freebsd-無線-ap-鎖定使用者-mac-address/
views:
  - 3762
bot_views:
  - 628
dsq_thread_id:
  - 247294353
categories:
  - FreeBSD
  - Linux
  - Network

---
在之前的文章已經提到如何利用一張無線網卡架設 AP 伺服器，[[FreeBSD] 無線網卡架設AP Server DWL-G520 Ralink RT2561][1]，但是如何跟外面賣得產品一樣可以鎖mac呢，雖然mac的竄改相當普遍，linux底下只要下一個指令就可以達到了，不過你要知道別人的mac還蠻難的吧，除非你跟她同一網域，所以底下就介紹在freebsd底下如何做到。 在linux底下其實很簡單，因為google一下就好了 <http://madwifi.org/wiki/UserDocs> 這個網頁相當豐富，教你如何在linux底下實做ap跟鎖MAC。 

> Steps 1. First, make sure your card is not set to any particular mode or essid. 2. Run: \* To flush the list of MAC addresses: iwpriv ath0 maccmd 3 \* To make the list a whitelist: iwpriv ath0 maccmd 1 3. Put the card in master mode: iwconfig ath0 mode master essid test ifconfig ath0 up 4. At this point, nothing will be able to connect to the AP, since the whitelist is empty. To rectify this, you need to add some MACs to the list: iwpriv ath0 addmac 00:01:02:03:04:05 在 FreeBSD 底下，作法也蠻容易的，就是利用 ifconfig 這個指令就可以做到了，底下是我 man ifconfig 看到的 

> The following parameters support an optional access control list feature available with some adaptors when operating in ap mode; see wlan_acl(4). This facility allows an access point to accept/deny association requests based on the MAC address of the station. Note that this feature does not significantly enhance security as MAC address spoofing is easy to do. mac:add address Add the specified MAC address to the database. Depending on the policy setting association requests from the specified station will be allowed or denied. mac:allow Set the ACL policy to permit association only by stations regis- tered in the database. mac:del address Delete the specified MAC address from the database. mac:deny Set the ACL policy to deny association only by stations regis- tered in the database. mac:kick address Force the specified station to be deauthenticated. This typi- cally is done to block a station after updating the address data- base. mac:open Set the ACL policy to allow all stations to associate. mac:flush Delete all entries in the database. 設定只有 database 裡面的 mac 才可以連上 ifconfig ral0 mac:allow 設定只有 database 裡面的 mac 不能連上 ifconfig ral0 mac:deny 新增 mac 到資料庫 ifconfig ral0 mac:add address 清除 database 資料 ifconfig ral0 mac:flush

 [1]: http://blog.wu-boy.com/2007/10/22/122/