---
title: Flutter 推出 1.0 版本
author: appleboy
type: post
date: 2018-12-05T03:51:05+00:00
url: /2018/12/flutter-release-1-0-0-version/
dsq_thread_id:
  - 7088085509
categories:
  - flutter
tags:
  - dart
  - flutter

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/46133062882/in/dateposted-public/" title="Screen Shot 2018-12-05 at 10.25.34 AM"><img src="https://i0.wp.com/farm5.staticflickr.com/4843/46133062882_6aed05cb12_z.jpg?resize=640%2C422&#038;ssl=1" alt="Screen Shot 2018-12-05 at 10.25.34 AM" data-recalc-dims="1" /></a> 

很高興看到台灣時間 12/5 號 [Flutter][1] 正式推出 [1.0 版本][2]，相信很多人都不知道什麼是 Flutter，簡單來說開發者只要學會 Flutter 就可以維護一套程式碼，並且同時編譯出 iOS 及 Android 手機 App，其實就跟 [Facebook][3] 推出的 [React Native][4] 一樣，但是 Flutter 的老爸是 [Google][5]。相信大家很常看到這一兩年內，蠻多新創公司相繼找 RN 工程師，而不是分別找兩位 iOS 及 Android 工程師，原因就在後續的維護性及成本。而 Flutter 也有相同好處。我個人覺得 RN 跟 Flutter 比起來，單純對入門來說，RN 是非常好上手的，但是如果您考慮到後續的維護成本，我建議選用 Flutter，雖然 Flutter 要學一套全新的語言 [Dart][6]，在初期時要學習如何使用 Widgets，把很多元件都寫成 Widgets 方便後續維護。但是在 RN 後期的維護使用了大量的第三方 Library，您想要升級一個套件可能影響到太多地方，造成不好維護。語言選擇 RN 可以使用純 JavaScript 撰寫，或者是導入 JS Flow + TypeScript 來達到 Statically Type，而 Flutter 則是使用 Dart 直接支援強型別編譯。如果現在要我選擇學 RN 或 Flutter 我肯定選擇後者。那底下來看看這次 Flutter 釋出了哪些新功能？對於 Flutter 還不了解的，可以看底下介紹影片。

<!--more-->

## Flutter 1.0 

Flutter 在 1.0 版本使用了最新版 Dart 2.1 版本，那在 Dart 2 版本帶來什麼好處？此版本提供了更小的 code size，快速檢查型別及錯誤型別的可用性。這次的 Rlease 也代表之後不會再更動版本這麽快了，可以看看在 [GitHub 上 Release 速度][7]，在 1.0 還沒出來前，大概不到一週就會 Release 一版。未來應該不太會動版這麼迅速了。當然還有其他功能介紹像是 `Add to App` 或 `Platform Views` 會預計在 2019 二月正式跟大家見面。詳細介紹可以參考 [Flutter 1.0: Google’s Portable UI Toolkit][2] 

## Square SDK

[Square][8] 釋出了兩套 SDK，幫助 Flutter 開發者可以快速整合手機支付，或者是直接透過 Reader 讀取手機 App 資料付款兩種方式。詳細使用方式可以參考 [Flutter plugin for Reader SDK][9] 或 [Flutter plugin for In-App Payments SDK][10] 

## Flare 2D 動畫 Flutter 釋出 

[Flare][11] 讓 Designer 可以快速的在 Fluter 產生動畫，這樣可以透過 Widget 快速使用動畫。所以未來 Designer 跟 Developer 可以加速 App 實作。這對於兩種不同領域的工程師是一大福音啊。 

## CI/CD 流程

相信大家最困擾的就是如何在 Android 及 iOS 自動化測試及同時發佈到 [App Store][12] 及 [Google Play][13]，好的 Flutter 聽到大家的聲音了，一個 Flutter 合作夥伴 [Nevercode][14] 建立一套 [Codemagic][15]，讓開發者可以寫一套 code base 自動在 iOS 及 Android 上面測試，並且同時發佈到 Apple 及 Google，減少之前很多手動流程，此套工具還在 Beta 版本，目前尚未看到收費模式。想試用的話，可以直接在 GitHub 上面建立 Flutter 專案。登入之後選取該專案，每次 commit + push 後就可以看到正在測試及部署了。 

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/32312340038/in/dateposted-public/" title="Screen Shot 2018-12-05 at 11.32.40 AM"><img src="https://i2.wp.com/farm5.staticflickr.com/4807/32312340038_04cce52655_z.jpg?resize=640%2C344&#038;ssl=1" alt="Screen Shot 2018-12-05 at 11.32.40 AM" data-recalc-dims="1" /></a> 

## Hummingbird

Hummingbird 是 Flutter runtime 用 web-base 方式實作，也就是說 Flutter 不只有支援原生 ARM Code 而也支援 JavaScript，未來也可以透過 Flutter 直接產生 Web 相關程式碼，開發者不用改寫任何一行程式碼，就可以直接將 Flutter 運行在瀏覽器內。詳細情形可以直接看

[官方部落格][16]，在明年 Google I/O 也會正式介紹這門技術。 

## 後記

{{< youtube xz-F7YRrYGM >}}

更多詳細的影片可以參考 flutter live 18

{{< youtube NQ5HVyqg1Qc >}}


 [1]: https://flutter.io/
 [2]: https://developers.googleblog.com/2018/12/flutter-10-googles-portable-ui-toolkit.html
 [3]: https://facebook.com
 [4]: https://facebook.github.io/react-native/
 [5]: https://google.com
 [6]: https://www.dartlang.org/
 [7]: https://github.com/flutter/flutter/releases
 [8]: https://squareup.com/us/en/flutter
 [9]: https://docs.connect.squareup.com/payments/readersdk/flutter
 [10]: https://www.workwithsquare.com/in-app-sdk.html
 [11]: https://medium.com/2dimensions/flare-launch-d524067d34d8
 [12]: https://www.apple.com/tw/ios/app-store/
 [13]: https://play.google.com/store
 [14]: https://nevercode.io/
 [15]: https://codemagic.io
 [16]: https://medium.com/p/e687c2a023a8
