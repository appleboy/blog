---
title: Go 語言實現 gRPC Health 驗證
author: appleboy
type: post
date: 2017-11-14T05:57:10+00:00
url: /2017/11/grpc-health-check-in-go/
dsq_thread_id:
  - 6282647918
categories:
  - Golang
tags:
  - golang
  - gRPC

---
[<img src="https://i1.wp.com/farm5.staticflickr.com/4555/26629370309_b2fa3b59df_z.jpg?w=840&#038;ssl=1" alt="grpc_square_reverse_4x" data-recalc-dims="1" />][1]

本篇教大家如何每隔一段時間驗證 [gRPC][2] 服務是否存活，如果想了解什麼是 gRPC 可以參考 這篇『[REST 的另一個選擇：gRPC][3]』，這邊就不多介紹 gRPC 了，未來將會是容器的時代， 那該如何檢查容器 Container 是否存活。如果是用 Kubernetes 呢？該如何來撰寫 gRPC 接口搭配 `livenessProbe` 設定。底下是在 [Dockerfile][4] 內可以設定 `HEALTHCHECK` 來 達到檢查容器是否存活。詳細說明可以參考此[連結][5]。

<!--more-->

```bash
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
```

## 建立 Health Check proto 接口

打開您的 `*.proto` 檔案，並且寫入

```bash
message HealthCheckRequest {
  string service = 1;
}

message HealthCheckResponse {
  enum ServingStatus {
    UNKNOWN = 0;
    SERVING = 1;
    NOT_SERVING = 2;
  }
  ServingStatus status = 1;
}

service Health {
  rpc Check(HealthCheckRequest) returns (HealthCheckResponse);
}
```

存檔後重新產生 Go 程式碼: 檔案存放在 `rpc/proto` 目錄

```bash
$ protoc -I rpc/proto rpc/proto/gorush.proto --go_out=plugins=grpc:rpc/proto
```

或者在 Makefile 內驗證 proto 檔案是否變動才執行:

```bash
rpc/proto/gorush.pb.go: rpc/proto/gorush.proto
    protoc -I rpc/proto rpc/proto/gorush.proto \
    --go_out=plugins=grpc:rpc/proto
```

### [程式碼連結][6]

## 建立 Health Interface

如果還有其他接口需要驗證，這就必須建立一個 Health Interface 讓你的服務可以驗證多種 protocol， 建立 `health.go`

```go
package rpc

import (
    "context"
)

// Health defines a health-check connection.
type Health interface {
    // Check returns if server is healthy or not
    Check(c context.Context) (bool, error)
}
```

### [程式碼連結][7]

## 建立 gRPC 服務

首先要定義一個 Server 結構來實現 `Check` 接口

```go
type Server struct {
    mu sync.Mutex
    // statusMap stores the serving status of the services this Server monitors.
    statusMap map[string]proto.HealthCheckResponse_ServingStatus
}

// NewServer returns a new Server.
func NewServer() *Server {
    return &Server{
        statusMap: make(map[string]proto.HealthCheckResponse_ServingStatus),
    }
}
```

這邊可以看到，gRPC 的狀態可以從 proto 產生的 Go 檔案拿到，打開 `*.pb.go`，可以找到如下

```go
type HealthCheckResponse_ServingStatus int32

const (
    HealthCheckResponse_UNKNOWN     HealthCheckResponse_ServingStatus = 0
    HealthCheckResponse_SERVING     HealthCheckResponse_ServingStatus = 1
    HealthCheckResponse_NOT_SERVING HealthCheckResponse_ServingStatus = 2
)
```

接著來實現 Check 接口

```go
// Check implements `service Health`.
func (s *Server) Check(ctx context.Context, in *proto.HealthCheckRequest) (*proto.HealthCheckResponse, error) {
    s.mu.Lock()
    defer s.mu.Unlock()
    if in.Service == "" {
        // check the server overall health status.
        return &proto.HealthCheckResponse{
            Status: proto.HealthCheckResponse_SERVING,
        }, nil
    }
    if status, ok := s.statusMap[in.Service]; ok {
        return &proto.HealthCheckResponse{
            Status: status,
        }, nil
    }
    return nil, status.Error(codes.NotFound, "unknown service")
}
```

上面可以看到透過帶入 `proto.HealthCheckRequest` 得到 gRPC 的回覆，這邊通常都是帶空值， gRPC 會自動回 `1`，最後在啟動 gRPC 服務前把 Health Service 註冊上去

```go
    s := grpc.NewServer()
    srv := NewServer()
    proto.RegisterHealthServer(s, srv)
    // Register reflection service on gRPC server.
    reflection.Register(s)
```

這樣大致上完成了 gRPC 伺服器端實作

### [程式碼連結][8]

## 建立 Client 套件

一樣可以透過 proto 產生的程式碼來撰寫 Client 驗證，建立 `client.go` 裡面寫入

```go
package rpc

import (
    "context"

    "github.com/appleboy/gorush/rpc/proto"

    "google.golang.org/grpc"
    "google.golang.org/grpc/codes"
)

// generate protobuffs
//   protoc --go_out=plugins=grpc,import_path=proto:. *.proto

type healthClient struct {
    client proto.HealthClient
    conn   *grpc.ClientConn
}

// NewGrpcHealthClient returns a new grpc Client.
func NewGrpcHealthClient(conn *grpc.ClientConn) Health {
    client := new(healthClient)
    client.client = proto.NewHealthClient(conn)
    client.conn = conn
    return client
}

func (c *healthClient) Close() error {
    return c.conn.Close()
}

func (c *healthClient) Check(ctx context.Context) (bool, error) {
    var res *proto.HealthCheckResponse
    var err error
    req := new(proto.HealthCheckRequest)

    res, err = c.client.Check(ctx, req)
    if err == nil {
        if res.GetStatus() == proto.HealthCheckResponse_SERVING {
            return true, nil
        }
        return false, nil
    }
    switch grpc.Code(err) {
    case
        codes.Aborted,
        codes.DataLoss,
        codes.DeadlineExceeded,
        codes.Internal,
        codes.Unavailable:
        // non-fatal errors
    default:
        return false, err
    }

    return false, err
}
```

### [程式碼連結][9]

## 驗證 gRPC 服務是否存活

上述 Client 寫好後，其他開發者可以直接 import 此 package，就可以直接使用。再建立 一個檔案取名叫 `check.go`

```go
package main

import (
    "context"
    "log"
    "time"

    "github.com/go-training/grpc-health-check/rpc"

    "google.golang.org/grpc"
)

const (
    address = "localhost:9000"
)

func main() {
    // Set up a connection to the server.
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("did not connect: %v", err)
    }
    defer conn.Close()

    client := rpc.NewGrpcHealthClient(conn)

    for {
        ok, err := client.Check(context.Background())
        if !ok || err != nil {
            log.Printf("can't connect grpc server: %v, code: %v\n", err, grpc.Code(err))
        } else {
            log.Println("connect the grpc server successfully")
        }

        <-time.After(time.Second)
    }
}

```

### [程式碼連結][10]

## 結論

所有程式碼都可以在[這邊找到][11]，假設團隊的 gRPC 服務跟 Web 服務器 綁在同一個 Go 程式的話，可以透過撰寫 `/healthz` 來同時處理 gRPC 及 Http 服務的驗證。在 Kubernetes 內就可以透過設定 `livenessProbe` 來驗證 Container 是否存活。

```yml
livenessProbe:
  httpGet:
    path: /healthz
    port: 3000
  initialDelaySeconds: 3
  periodSeconds: 3
```

 [1]: https://www.flickr.com/photos/appleboy/26629370309/in/dateposted-public/ "grpc_square_reverse_4x"
 [2]: https://grpc.io/
 [3]: https://yami.io/grpc/
 [4]: https://docs.docker.com/engine/reference/builder/
 [5]: https://docs.docker.com/engine/reference/builder/#healthcheck
 [6]: https://github.com/go-training/grpc-health-check/blob/master/proto/health.proto
 [7]: https://github.com/go-training/grpc-health-check/blob/master/client/health.go
 [8]: https://github.com/go-training/grpc-health-check/blob/master/main.go
 [9]: https://github.com/go-training/grpc-health-check/blob/master/rpc/client.go
 [10]: https://github.com/go-training/grpc-health-check/blob/master/client/main.go
 [11]: https://github.com/go-training/grpc-health-check