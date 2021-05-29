---
title: 用 Drone 部署靜態檔案到 GitHub Pages
author: appleboy
type: post
date: 2020-02-22T06:34:20+00:00
url: /2020/02/deploy-static-files-to-github-using-drone/
dsq_thread_id:
  - 7882733810
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - Github

---
> 新課程上架:『[Docker 容器實用實戰][1]』目前特價 **$800 TWD**，優惠代碼『**20200222**』，也可以直接匯款（價格再減 **100**），如果想搭配另外兩門課程合購可以透過 [FB 聯絡我][2]

![][3] 

[GitHub][4] 提供一個非常方便的功能，就是可以將[靜態檔案][5]部署在 GitHub 上，基本上開發者不用負擔任何 Host 費用，就可以使用靜態檔案來做 Demo 介紹，或者是文件系統。而本篇將教您如何用 [Drone][6] 來自動化部署靜態檔案到 GitHub 上。作者直接用 Vue.js 來介紹整個流程。

<!--more-->

## 教學影片

{{< youtube L4kMIkRE9DA >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][7]
  * [一天學會 DevOps 自動化測試及部署][8]
  * [DOCKER 容器開發部署實戰][9] (課程剛啟動，限時特價 $800 TWD)

## 準備 Vue.js 環境

這邊就不多著墨了，透過 `npm build` 可以在本機端將靜態檔案編譯到 `dist` 目錄內。而 GitHub Pages 預設的 domain 會是

> user\_id.github.io/project\_name

假設專案的 GitHub URL 為 

> github.com/go-training/vue-gh-pages-demo

就可以知道 user id 是 `go-training` 那 repo 名稱為 `vue-gh-pages-demo`，那 GitHub 提供的 URL 就會是

> <https://go-training.github.io/vue-gh-pages-demo>

可以看出來會有一個 sub folder 跑出來，因為在同一個 Org 或 User 底下會有很多 repo，故一定要這樣區分。這時候在編譯 Vue.js 專案時就需要使用不同的設定，請打開 `vue.config.js`

```js
module.exports = {
  assetsDir: 'assets',
  publicPath: process.env.NODE_ENV === 'production'
  ? '/vue-gh-pages-demo/'
  : '/',
};
```

從上面可以看到當開發者需要部署到 GitHub 時，就可以動態將 index.html 內的靜態檔案路徑換成 sub folder 方式，而不影響本機端開發。**完整程式範例可以[參考這邊][10]**。

## 搭配 Drone 自動化部署

由於 GitHub Page 預設是讀 `gh-pages` 分支，故需要先將此分支建立起來，後續才可以正常部署，請參照底下 `.drone.yml` 內容

```yaml
---
kind: pipeline
name: testing

platform:
  os: linux
  arch: amd64

steps:
- name: release
  image: node:13
  environment:
    NODE_ENV: gh-pages
  commands:
  - yarn install
  - yarn build

- name: publish
  image: plugins/gh-pages
  settings:
    username:
      from_secret: username
    password:
      from_secret: password
    pages_directory: dist
```

其中 username 跟 password 會是 GitHub 的帳號密碼，但是密碼部分可以透過 GitHub 的 [Personal Access token][11] 來產生，這樣就不用給真的密碼了。

![][12] 

## 設定 custom domain

其實會發現使用 sub folder 其實很不方便，所以我個人都習慣使用 custome domain 方式來配置

![][13] 

GitHub 也提供個人網域的 https 憑證，所以像是各大 Conference 如果沒有什麼後端需求，其實都可以直接放到這上面，這樣還可以省下不少人力，及維護主機的成本。

**完整程式範例可以[參考這邊][10]**

 [1]: https://www.udemy.com/course/docker-practice/?couponCode=20200222 "Docker 容器實用實戰"
 [2]: http://facebook.com/appleboy46
 [3]: https://lh3.googleusercontent.com/vD-ucUYf5HyaiqFcboabD13gP0b_ZQeTKdceFqim75J5z3jiA-D_H4BZEbd0hPf9Go1h-kN06yPcYoT-qpym7jLbFNAjadLvhWMx8XdAQRdAa7Bg61I5pYO2U3fqVEh6n6D4I38sdoo=w1920-h1080
 [4]: https://github.com
 [5]: https://pages.github.com
 [6]: https://drone.io
 [7]: https://www.udemy.com/course/golang-fight/?couponCode=202002
 [8]: https://www.udemy.com/course/devops-oneday/?couponCode=202002
 [9]: https://www.udemy.com/course/docker-practice/?couponCode=20200222
 [10]: https://github.com/go-training/vue-gh-pages-demo
 [11]: https://github.com/settings/tokens
 [12]: https://lh3.googleusercontent.com/qM0YbWBmBWNyuIJOIJ3aDCfKNisUwXOP59i8bWjXfuiKVObx84ImVs703zbu1A63T_d4An0M82p2GakF0eX9pGri9CaNicmiZMpARk2UAlubVV5VhOJqAtKxJzecJE0C-E_bsUi5G5k=w1920-h1080
 [13]: https://lh3.googleusercontent.com/fcKE0N5iLh314FXA_FcA4bkTRHH_F0EBMnO_fOy3uP3ZFi6LqQ1QwKUu29TvsSxawgS5JWcWh1J2mcF2fTGLK32YAbFNjp_73HE2iHYo7B9a3f2a8PxbavG-Xth0tmOT1R4W6AAEVEQ=w1920-h1080
