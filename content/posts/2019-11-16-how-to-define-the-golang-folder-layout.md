---
title: 初探 Go 語言 Project Layout (新人必看)
author: appleboy
type: post
date: 2019-11-15T23:30:43+00:00
url: /2019/11/how-to-define-the-golang-folder-layout/
dsq_thread_id:
  - 7719840628
categories:
  - Docker
  - Golang
tags:
  - Docker
  - golang

---
[![cover photo][1]][1]

很多人初次進入 Go 語言，肯定都會尋找在 Go 裡面是否有一套標準且最多人使用的 Framework 來學習，但是在 Go 語言就是沒有這樣的標準，所有的開源專案架構目錄都是由各團隊自行設計，沒有誰對誰錯，也沒任何一個是最標準的。那你一定會問，怎樣才是最好的呢？很簡單，如果可以定義出一套結構是讓團隊所有成員可以一目瞭然的目錄結構，知道發生問題要去哪個地方找，要加入新的功能，就有相對應的目錄可以存放，那這個專案就是最好的。當然這沒有標準答案，只是讓團隊有個共識，未來有新人進入專案，可以讓他在最短時間內吸收整個專案架構。

<!--more-->

## 投影片

本次教學會著重在投影片 P5 ~ P20。

## 教學影片

https://www.youtube.com/watch?v=jApleGS2hQY

喜歡我的 Youtube 影片，可以訂閱 + 分享喔

  1. project layout 基本簡介 00:47
  2. 為什麼要用 [go module][2] 07:28
  3. 使用 Makefile 09:59
  4. .env 使用情境 11:42
  5. 如何設定專案版本資訊 12:54

未來會將投影片剩下的內容，錄製成影片放在 Udemy 平台上面，有興趣的可以直接參考底下:

  * [Go 語言基礎實戰 (開發, 測試及部署)][3]
  * [一天學會 DevOps 自動化測試及部署][4]

 [1]: https://lh3.googleusercontent.com/pKaq_CvDy37QrubxGcYfXpOoORzOO0t1zJ0eSDpiyNzl0IlrbXeY3zNRGmBVUkK6QdjcfE514j2MxeNdVQRfl8S9wfdEmbeK54414LFUVZLSob62AVimIlmbI7qiQhH_mPjqNDZoL18=w1920-h1080 "cover photo"
 [2]: https://blog.wu-boy.com/2018/10/go-1-11-support-go-module/comment-page-1/ "go module"
 [3]: https://www.udemy.com/course/golang-fight/?couponCode=20191201
 [4]: https://www.udemy.com/course/devops-oneday/?couponCode=20191201
