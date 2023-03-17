---
title: Go 語言搭配 Docker Healthy Check 檢查
author: appleboy
type: post
date: 2018-03-19T03:18:47+00:00
url: /2018/03/docker-healthcheck-in-golang/
dsq_thread_id:
  - 6561150968
categories:
  - DevOps
  - Docker
  - Golang

---

![cover](https://i2.wp.com/farm1.staticflickr.com/805/39050902230_b1d91bc120_z.jpg)

在 [Docker][2] 1.12 版本後，提供了 `HEALTHCHECK` 指令，通過指定的一行命令來判斷容器內的服務是否正常運作。在此之前大部分都是透過判斷程式是否 Crash 來決定容器是否存活，但是這地方有點風險的是，假設服務並非 crash，而是沒辦法退出容器，造成無法接受新的請求，這就確保容器存活。現在呢我們可以透過在 `Dockerfile` 內指定 `HEALTHCHECK` 指令來確保服務是否正常。而用 [Go 語言][3]開發的 Web 服務該如何來實現呢？

<!--more-->

## 建立 /healthz 路由

透過簡單的路由 `/healthz` 直接回傳 200 status code 即可 (使用 [Gin][4] 當例子)。

```go
func heartbeatHandler(c *gin.Context) {
  c.AbortWithStatus(http.StatusOK)
}
```

透過瀏覽器 `http://localhost:8080/healthz` 可以得到空白網頁，但是打開 console 可以看到正確回傳值。

![cover2](https://i1.wp.com/farm5.staticflickr.com/4774/26990632808_d800bc3800_z.jpg)

## 建立 ping 指令

透過 `net/http` 套件可以快速寫個驗證接口的函式

```go
func pinger() error {
  resp, err := http.Get("http://localhost:8080/healthz")
  if err != nil {
    return err
  }
  defer resp.Body.Close()
  if resp.StatusCode != 200 {
    return fmt.Errorf("server returned non-200 status code")
  }
  return nil
}
```

## 增加 HEALTHCHECK 指令

在 `Dockerfile` 內增加底下內容:

```bash
HEALTHCHECK --start-period=2s --interval=10s --timeout=5s \
  CMD ["/bin/gorush", "--ping"]
```

* **--start-period**: 容器啟動後需要等待幾秒，預設為 0 秒
* **--interval**: 偵測間隔時間，預設為 30 秒
* **--timeout**: 檢查超時時間

重新編譯容器，並且啟動容器，會看到初始狀態為 `(health: starting)`

![cover2](https://i2.wp.com/farm1.staticflickr.com/788/40861013721_d7327500f9_z.jpg)

經過 10 秒後，就會執行指定的指令，就可以知道容器健康與否，最後狀態為 `(healtyy)`。

![cover3](https://i1.wp.com/farm1.staticflickr.com/783/39051186800_ee9a838403_z.jpg)

最後可以透過 `docker inspect` 指令來知道容器的狀態列表 (JSON 格式)

```bash
docker inspect --format '{{json .State.Health}}' gorush | jq
```

![cover4](https://i1.wp.com/farm5.staticflickr.com/4781/40861130401_08ca9e2cce_z.jpg)

從上圖可以知道每隔 10 秒 Docker 就會自動偵測一次。有了上述這些資料，就可以來寫系統報警通知了。如果對 Go 語言有興趣，可以參考[線上課程][9]。

[2]: https://www.docker.com
[3]: https://golang.org
[4]: https://github.com/gin-gonic/gin
[9]: https://blog.wu-boy.com/golang-online-course/
