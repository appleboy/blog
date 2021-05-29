---
title: Minio 從 Docker 容器移除 healthcheck 腳本
author: appleboy
type: post
date: 2019-08-18T05:20:45+00:00
url: /2019/08/minio-remove-healthcheck-script-for-docker-image/
dsq_thread_id:
  - 7592843815
categories:
  - Docker
  - Golang
tags:
  - golang
  - minio
  - s3

---
[![minio golang][1]][1]

[Minio][2] 是一套開源專案的 Object 儲存容器，如果你有使用 [AWS S3][3]，相信要找一套代替 S3 的替代品，一定會想到這套用 [Go 語言][4]開發的 Minio 專案。讓您在公司內部也可以享有 S3 的儲存容器，不需要變動任何程式碼就可以無痛從 AWS S3 搬到公司內部。剛好最近在整合 Traefik 搭配 Minio，由於 Minio 原先已經內建 healthcheck 腳本，所以當運行 Minio 時，使用 `docker ps` 正常來說可以看到類似 `Up 7 weeks (healthy)` 字眼，但是 Minio 運行了三分鐘之後，狀態就會從 `healthy` 變成 `unhealthy`，造成 Traefik 會自動移除 frontend 的對應設定，這樣 Web 就無法顯示了。我在 Udemy 上面有介紹如[何用 Golang 寫 healthcheck][5]，大家有興趣可以參考看看，coupon code 可以輸入 **GOLANG2019** 。

<!--more-->

## 官方移除 healthcheck 腳本

我在官方發了一個 [Issue][6]，發現大家 workaround 的方式就是自己移除 healthcheck 檢查，然後再自行發布到 DockerHub，這方法也是可行啦，只是這樣還要自己去更新版本有點麻煩，後來官方直接[發個 PR][7] 把整段 Healthcheck 腳本移除，官方說法是說，容器那大家的設定的執行 User 或權限都不同，所以造成無法讀取 netstat 資料，所以直接移除，用大家熟悉的 curl 方式來執行，在 kubernets 內可以使用

```yaml
healthcheck:
  image: minio/minio:RELEASE.2019-08-14T20-37-41Z
      test: ["CMD", "curl", "-f", "http://minio1:9000/minio/health/live"]
  volumes:
      interval: 1m30s
   - data2:/data
      timeout: 20s
  ports:
      retries: 3
   - "9002:9000"
      start_period: 3m
```

## 自行開發 healthcheck

如果你有看之前 minio 程式碼，可以發現寫得相當複雜，通常預設只要 ping 通 web 服務就可以了

```go
resp, err := http.Get("http://localhost" + config.Server.Addr + "/healthz")
if err != nil {
  log.Error().
    Err(err).
    Msg("failed to request health check")
  return err
}
defer resp.Body.Close()
if resp.StatusCode != http.StatusOK {
  log.Error().
    Int("code", resp.StatusCode).
    Msg("health seems to be in bad state")
  return fmt.Errorf("server returned non-200 status code")
}
return nil
```

接著在 Dockerfile 裡面寫入底下，就大功告成啦。

```dockerfile
HEALTHCHECK --start-period=2s --interval=10s --timeout=5s \
  CMD ["/bin/crosspoint-server", "health"]
```

 [1]: https://lh3.googleusercontent.com/3lAv9HlhI9mxCfow0jHY5-G6H-tvXJLCv3S2QvzKReV_R-61oywRIXW6sruwPrS69CXpMAuIrccgVH8HY5hIzDGvenyhFhKcGmBk0CmU1c36k6NrjSvYESSmAEAejlxmxdW_gduXZio=w1920-h1080 "minio golang"
 [2]: https://min.io/
 [3]: https://aws.amazon.com/tw/s3/
 [4]: https://golang.org
 [5]: https://www.udemy.com/course/golang-fight/learn/lecture/9962004#overview
 [6]: https://github.com/minio/minio/issues/8082
 [7]: https://github.com/minio/minio/pull/8095