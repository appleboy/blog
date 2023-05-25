---
title: "設計流程及系統架構圖好工具 D2"
date: 2023-05-21T10:09:26+08:00
author: appleboy
type: post
slug: what-is-d2-declarative-diagramming-language
share_img: https://lh3.googleusercontent.com/pw/AJFCJaXH-MYgMTn3_iMl7FIKNbI1B93sTffzWPn8ZEaC96iTp9ZCpqu2DZY9gNLWrnqUL10qUBD2pwHhdOBOczBiHeaFCC6MhrSBwI-jgNZuaGC50fVhTBl7yQDXem2AhvMpR871jUuvHssv-muKZqfZ8-4chw=w2786-h1152-s-no?authuser=0
categories:
  - D2
  - PlantUML  
  - VSCode  
  - diagrams  
  - draw.io  
  - excalidraw 
---

![cover](https://lh3.googleusercontent.com/pw/AJFCJaXH-MYgMTn3_iMl7FIKNbI1B93sTffzWPn8ZEaC96iTp9ZCpqu2DZY9gNLWrnqUL10qUBD2pwHhdOBOczBiHeaFCC6MhrSBwI-jgNZuaGC50fVhTBl7yQDXem2AhvMpR871jUuvHssv-muKZqfZ8-4chw=w2786-h1152-s-no?authuser=0)

在之前寫過一篇『[三款好用的繪圖工具來解決系統架構或流程圖][1]』，內文介紹了 PlantUML、Diagrams 及 Excalidraw 三套不同的工具，而本篇要來介紹一套用 Go 語言寫的工具 [D2: Declarative Diagramming][2]，這套工具可以讓你使用簡單的語法來繪製系統架構圖或流程圖，並且可以將圖片轉換成 SVG 或 PNG 格式。在介紹之前，我來講講為什麼要用這些流程圖工具，對工作上或團隊內部有什麼優點？

[1]:https://blog.wu-boy.com/2022/09/three-tools-design-system-architecture-and-flow/
[2]:https://d2lang.com/

<!--more-->

## 教學影片

{{< youtube Dgjic4BbjGs >}}

```sh
00:00 好用的架構圖工具
00:48 什麼是系統流程圖
01:45 什麼是系統架構圖
02:59 帶來的優勢及好處
05:33 什麼是 D2
06:59 D2 設計原則
08:13 D2 特性及優勢
08:53 D2 的缺點
10:35 D2 流程案例 Demo
```

其他線上課程請參考如下

* [Docker 容器實戰](https://blog.wu-boy.com/docker-course/)
* [Go 語言課程](https://blog.wu-boy.com/golang-online-course/)

## 什麼是系統流程圖或系統架構圖?

**系統流程圖**（System Flowchart）和**系統架構圖**（System Architecture Diagram）是兩種常用於軟體開發和系統設計的圖形表示工具，用於描述系統的結構和流程。

系統流程圖是一種圖形化表示方法，用於展示系統中各個元件之間的流程和相互作用。它使用不同的符號和線條，以圖形化的方式描述系統中的各個步驟、過程和決策。系統流程圖通常包含各種元件，例如處理程序、資料庫、輸入/輸出、判斷條件等，並使用箭頭表示數據流動的方向。通過系統流程圖，開發人員和設計師可以更清晰地了解系統的運作方式，有助於識別問題、改進流程和進行系統優化。

系統架構圖是一種高層次的視覺化表示方法，用於展示系統中各個組件之間的結構和關係。它提供了系統的整體視圖，顯示系統的主要組件、子系統和其相互之間的關聯。系統架構圖可以包括硬體元件、軟體模塊、資料庫、外部系統等，並使用框圖、連線和標籤等元素來表示它們之間的關係和通訊方式。通過系統架構圖，開發人員可以更好地理解系統的組成部分，並協助設計、部署和管理系統。

總結來說，系統流程圖強調系統中各個元件之間的流程和互動，用於描述系統的運作流程；而系統架構圖則強調系統中各個組件之間的結構和關係，用於展示系統的整體結構。兩者在軟體開發和系統設計中都是重要的工具，用於提高對系統的理解和溝通。

## 使用系統流程圖或系統架構圖帶來的好處?

系統流程圖和系統架構圖在軟體開發和系統設計中帶來以下好處：

1. 清晰的視覺化表示：系統流程圖和系統架構圖使用圖形化的方式來表示系統的流程和結構，使得複雜的系統概念和相互關係更加清晰可見。開發人員和設計師可以通過圖形的視覺化表示更容易理解系統的運作方式和結構，有助於加深對系統的理解。

2. 問題識別和改進：系統流程圖可以幫助開發人員識別流程中的瓶頸和問題點。通過詳細地描述系統中的各個步驟和決策，開發人員可以快速定位可能的問題，並提出改進方案。系統架構圖則可以協助開發人員識別系統中不同組件之間的依賴關係和通訊方式，有助於優化系統的結構和性能。

3. 溝通和協作：系統流程圖和系統架構圖提供了一種統一的語言和視覺表示方式，可以促進團隊成員之間的溝通和協作。開發人員、設計師和相關利益相關者可以通過這些圖形工具來共享和討論系統的運作和結構，確保彼此對系統的理解保持一致，並更好地協同工作。

4. 系統設計和優化：系統流程圖和系統架構圖可以用於系統的設計和優化。開發人員可以基於流程圖和架構圖來進行系統的規劃和設計，確定各個組件的功能和關係，以及數據的流動方式。同時，這些圖形工具還可以用於檢視和優化系統的性能、可靠性和可擴展性。

5. 錯誤預防和問題追蹤：透過系統流程圖和系統架構圖，可以預先識別潛在的錯誤和問題點。開發人員可以在設計階段發現並修復可能的錯誤，從而降低後續開發和測試階段的風險。同時，這些圖形工具還可用於追蹤問題的根源，便於進行故障排除和修復。

6. 系統文檔和培訓材料：系統流程圖和系統架構圖可作為系統的文檔和培訓材料，用於向新成員介紹系統的運作方式和結構。這些圖形工具提供了一種簡單明瞭的方式來傳達系統的概念和相互關係，使新成員更容易理解和上手。

7. 系統維護和升級：系統流程圖和系統架構圖對於系統的維護和升級也非常有用。當需要修改或擴展現有系統時，開發人員可以參考流程圖和架構圖，更好地理解系統的結構和流程，從而進行相應的改動和優化。

8. 規劃和預算控制：系統流程圖和系統架構圖有助於進行項目規劃和預算控制。通過分析流程圖和架構圖，可以確定系統開發所需的資源和時間，從而進行合理的預算規劃和資源分配。

9. 項目管理和風險控制：系統流程圖和系統架構圖可以用於項目管理和風險控制。這些圖形工具提供了一個整體的視圖，顯示了系統中各個組件的關係和依賴。這有助於項目管理人員更好地規劃和控制項目進度，並在風險發生時進行及時處理。

10. 跨團隊協作：系統流程圖和系統架構圖可以促進跨團隊的協作。例如，在複雜的系統開發項目中，開發團隊、測試團隊和運維團隊可以共享系統流程圖和系統架構圖，以便更好地理解系統的運作和結構。這有助於不同團隊之間的溝通、合作和協調。

11. 標準化和重複使用：系統流程圖和系統架構圖可以作為標準化的工具，用於描述和設計系統。這有助於建立標準化的開發和設計流程，並促進組件的重複使用。開發人員可以根據現有的流程圖和架構圖，更快速地開發和設計新的系統，從而提高效率和質量。

12. 潛在的錯誤和風險降低：通過使用系統流程圖和系統架構圖，可以在系統設計階段發現潛在的錯誤和風險。這有助於提前識別和解決問題，從而降低後續開發和部署階段的錯誤成本和風險。

它們提供了清晰的視覺化表示，使複雜的系統運作和結構更易理解，同時有助於問題的識別和改進。這些圖形工具促進了團隊成員之間的溝通和協作，並支持系統的設計、優化和維護。它們還用於系統文檔、培訓材料和項目管理，以及在預算控制和風險管理方面的應用。最重要的是，系統流程圖和系統架構圖提供了一種統一的表示方式，標準化開發和設計流程，並降低潛在的錯誤和風險。

## 什麼是 D2 (Declarative Diagramming)?

[D2][2] 是一種將文字轉換為圖形的圖表腳本語言。它代表著「聲明式圖表繪製」（Declarative Diagramming）。聲明式的意思是，您描述想要繪製的內容，它會生成相應的圖像。

創建一個名為 `input.d2` 的文件，複製並粘貼以下內容，執行該命令，您將獲得下面的圖像。

```sh
d2 --theme=300 --dark-theme=200 -l elk --pad 0 ./input.d2
```

底下是官網提供的範例：

```sh
network: {
  cell tower: {
    satellites: {
      shape: stored_data
      style.multiple: true
    }

    transmitter

    satellites -> transmitter: send
    satellites -> transmitter: send
    satellites -> transmitter: send
  }

  online portal: {
    ui: {shape: hexagon}
  }

  data processor: {
    storage: {
      shape: cylinder
      style.multiple: true
    }
  }

  cell tower.transmitter -> data processor.storage: phone logs
}

user: {
  shape: person
  width: 130
}

user -> network.cell tower: make call
user -> network.online portal.ui: access {
  style.stroke-dash: 3
}

api server -> network.online portal.ui: display
api server -> logs: persist
logs: {shape: page; style.multiple: true}

network.data processor -> api server
```

## D2 設計原則?

D2的設計旨在將圖表繪製變成一種對工程師來說愉快的體驗。許多工具聲稱可以做到對於簡單的圖表，但是一旦涉及稍微複雜的圖表，你就不再感到愉快了。而這些複雜的圖表恰恰是最需要存在的。

為什麼會這樣呢？因為大多數現今的圖表工具都是設計工具，而不是開發工具。它們給你一個空白畫布和類似於 Figma 或 Photoshop 的拖放工具列，並將它們的預期工作流程視為設計過程。工程師不是視覺設計師，缺乏空間建構系統的能力不應該妨礙有價值的文檔的創建。每次拖放都不應該需要計劃，更新也不應該成為一個令人沮喪的任務，需要不斷移動和調整大小以為新元素留出空間。聲明式圖表繪製消除了這種摩擦。

在 Hashicorp 引入 Terraform 讓工程師以文字形式編寫基礎設施之前，我們一直在 AWS 和 Google Cloud 的控制台上點擊配置基礎設施。如今，這已經是不專業的做法。評審過程在哪裡？回滾步驟在哪裡？歷史記錄和版本控制在哪裡？很難相信全球企業在視覺文檔方面的未來主要將使用拖放式設計工具來創建。

## 安裝方式

### 用 Script 安裝

```sh
# With --dry-run the install script will print the commands it will use
# to install without actually installing so you know what it's going to do.
curl -fsSL https://d2lang.com/install.sh | sh -s -- --dry-run
# If things look good, install for real.
curl -fsSL https://d2lang.com/install.sh | sh -s --
```

移除安裝

```sh
curl -fsSL https://d2lang.com/install.sh | sh -s -- --uninstall
```

### 用 Go 語言安裝

```sh
go install oss.terrastruct.com/d2
```

## D2 特性及優勢

相對其他工具，底下整理我看到 D2 的優勢及功能

1. 支援轉換成手繪模式 (Sketch Mode)
2. 支援動畫模式 (Animations Mode)
3. 支援 LaTeX 或其他語言展示 (Code snippets)
4. 支援 [Markdown](https://markdown.tw/) 格式
5. 支援 CLI 搭配瀏覽器即時呈現
6. 支援輸出格式 PDF, PNG 及 SVG
7. 支援 Autoformat (Coding Style)

## D2 缺點

個人用 D2 在公司內部畫了一些簡易的流程圖，為什麼說是『簡易』呢？原因是這樣，通常比較複雜的流程或架構圖，像是底下這系統圖:

![cover](https://lh3.googleusercontent.com/pw/AJFCJaXsQHU1rGlmpM2plVHdhtchh3YKWVl3UR9_NyL3ijnoLQKPE6MgIjoIyueLLjBjc_m8cPjUzvLW4DFTI9CBfbh9E0Jxnh4WVIdIBKF2sJnCn6DAnMkDCR953eegub2AIgJgqP7N4YcLRU9hOzXiIGzT6w=w2942-h1072-s-no?authuser=0)

我嘗試用 D2 來呈現這張圖的效果，但是由於是自動產生那些流程，所以有時候畫面呈現會不是我們所預期，這會造成什麼問題？有時候改動好幾版後，你會發現跟第一版的位置都會跑掉，無法固定一些元件在特定的地方，這是我目前遇到最大的問題，所以目前我個人都是拿 D2 來做簡單的流程圖，比較複雜的流程圖我還是拿其他工具來手繪，相對來說會比較好呈現給團隊。

## D2 流程案例

用 D2 實作開源專案 [golang-queue](https://github.com/golang-queue) 流程圖

![cover](https://lh3.googleusercontent.com/pw/AJFCJaWJKaOGGygj66YIsV7ttihdPkRFXrOLKcDaj17o7UQUogacU0jFQmbRacOKVNdoxoG06Rg93p31bARhSYshxFSbaiEbJAMavdku13ktAkGIHVS2fwJ_bEkyt7jLXEUv-utYQ7n8AH0H8SwGPNscRYVaEQ=w2778-h1230-s-no?authuser=0)

如果要畫上面這張有順序性從左到右，其實不難，D2 也可以按照你的思維呈現，但是像是底下這張架構圖，我就花了不少時間在調整每個元件最後呈現的位置。

![cover](https://lh3.googleusercontent.com/pw/AJFCJaXD1UuhMpjEe-LfiWlSQUrUhnsG_3O4JtYtcaZQ7fdkhP3qCkZ-og--j_PjfiKhq2QHMBKL7Bz-4Wd1zAJ9w38bgtppCdowgQBWhbxPye9-zxjD7eXl7AUl-qjEn7aHW0ODBFYr6XLGPpcjwuan4E5U1w=w2710-h1422-s-no?authuser=0)

上面範例都可以在[這邊找到原始碼](https://github.com/golang-queue/queue/tree/master/images)
