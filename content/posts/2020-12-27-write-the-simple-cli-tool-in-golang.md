---
title: 用 Go 語言撰寫簡單的 Command Line 工具
author: appleboy
type: post
date: 2020-12-27T13:50:54+00:00
url: /2020/12/write-the-simple-cli-tool-in-golang/
dsq_thread_id:
  - 8332149315
categories:
  - Golang
tags:
  - golang

---
[![golang logo][1]][1]

之前介紹了一個開源工具『[用 Docker 每天自動化備份 MySQL, Postgres 或 MongoDB 並上傳到 AWS S3][2]』，讓開發者可以快速透過 Docker 方式來備份資料庫，而本篇要介紹我如何用 Go 語言來撰寫 CLI 並且整合 Docker 來實現備份。此工具都是透過各大資料庫官方提供的 CLI 指令 ([pg_dump][3], [mysqldump][4] ... 等)，故大家不用猜想是什麼神奇的技巧。底下來依序介紹整個目錄結構，及我如何實現。

<!--more-->

## 影片介紹

{{< youtube errwTiYqljY >}}

  * 00:00 backup 資料庫工具簡介
  * 01:29 專案目錄分層介紹
  * 03:16 介紹 pkg/storage interface
  * 04:35 介紹 pkg/dbdump interface
  * 06:15 為什麼要用 urfave/cli v2 版本
  * 07:25 用 Drone 做自動化上傳多種不同 Docker Image
  * 08:40 go build + demo 使用 CLI
  * 09:33 介紹 cmd 目錄底下產生多個 CLI 目錄

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][5]
  * [一天學會 DevOps 自動化測試及部署][6]
  * [DOCKER 容器開發部署實戰][7]

如果需要搭配購買請直接透過 [FB 聯絡我][8]，直接匯款（價格再減 **100**）

## 目錄結構

底下教學就拿 [docker-backup-database][9] 為範例，我從目錄結構開始講，剛入門的朋友肯定對於 Go 語言在目錄這塊定義的不是很清楚，但是其實這跟個人或團隊喜好也有點關係，底下看看目錄結構

```sh
├── LICENSE
├── Makefile
├── README.md
├── cmd
│   └── backup
│       ├── config.go
│       └── main.go
├── docker
│   ├── Dockerfile.mongo.3.6
│   ├── Dockerfile.mongo.4
│   ├── Dockerfile.mongo.4.2
│   ├── Dockerfile.mongo.4.4
│   ├── Dockerfile.mysql.5.6
│   ├── Dockerfile.mysql.5.7
│   ├── Dockerfile.mysql.8
│   ├── Dockerfile.postgres.10
│   ├── Dockerfile.postgres.11
│   ├── Dockerfile.postgres.12
│   ├── Dockerfile.postgres.13
│   └── Dockerfile.postgres.9
├── docker-compose.yml
├── go.mod
├── go.sum
└── pkg
    ├── config
    │   └── config.go
    ├── dbdump
    │   ├── dbdmp.go
    │   ├── mongo
    │   │   └── mongo.go
    │   ├── mysql
    │   │   └── mysql.go
    │   └── postgres
    │       └── postgres.go
    ├── helper
    │   └── cmd.go
    └── storage
        ├── core
        │   └── core.go
        ├── disk
        │   ├── disk.go
        │   └── disk_test.go
        ├── minio
        │   └── minio.go
        └── storage.go
```

其實目錄結構相當清楚，根目錄底下只會放跟部署或教學相關的資訊，像是 `.drone.yml` 用來做 CI/CD 幫忙自動化建立 [Docker][10] Image 並且上傳到 Docker Hub。而 docker-compose.yml 則是一份簡單的教學範例，讓想使用此工具的開發者可以快速建置出 [Minio][11] 或 Postgres 環境。而最後一個 Makefile 存放很多相關的指令，我本身不太喜歡打很長的指令，直接把用到的指令全都寫在 Makefile 內，這樣在寫 CI/CD 或同事及開發者想快速使用時，幾個指令就可以搞定了。盡量不要把指令在 CI/CD 流程中複雜化，這樣不好維護。而 docker 目錄會是此專案用到的所有 Dockerfile，就放在一起了，透過 [Drone][12] 直接平行化編譯 Image 並上傳。

## cmd 目錄

```sh
├── cmd
│   └── backup
│       ├── config.go
│       └── main.go
```

開發者都可以發現在 GitHub 上面的 Go 開源專案，幾乎都會有一個 cmd 目錄，因為不想把 main.go 放在跟目錄下，然後又要命名一個還不錯的名稱，就需要建立在 cmd 目錄底下，這樣大家透過 `go get` 才可以正確下載到您要的命令，通常一個專案也許會有多個 CLI 工具，那就會在 cmd 底下建立多個目錄，每個目錄都會有 main.go 檔案，以現在這個範例為例，只會有一個 CLI，大家可以透過底下指令來下載 CLI。

```sh
go get github.com/appleboy/docker-backup-database/cmd/backup
```

在 CLI 套件選擇，我則是選擇了 [urfave/cli][13]，原因很簡單，此工具未來會應用在 CI/CD 流程上，所以會希望可以直接支援 [GitHub Actions][14], Drone CI 或 [GitLab CI][15]，而 urfave/cli 讓開發者可以自行定義 ENV，原因是 GitHub Actions 只支援 `INPUT_` 而 Drone CI 只支援 `PLUGIN_`，故 urfave/cli 讓我自由定義，只有這個原因才選這套件。

## pkg 目錄

我會把專案用到的其他功能都一併建立在這邊，由這個目錄底下在做分類

```sh
└── pkg
    ├── config
    │   └── config.go
    ├── dbdump
    │   ├── dbdmp.go
    │   ├── mongo
    │   │   └── mongo.go
    │   ├── mysql
    │   │   └── mysql.go
    │   └── postgres
    │       └── postgres.go
    ├── helper
    │   └── cmd.go
    └── storage
        ├── core
        │   └── core.go
        ├── disk
        │   ├── disk.go
        │   └── disk_test.go
        ├── minio
        │   └── minio.go
        └── storage.go
```

可以看到我分了幾個目錄，config 用來存放 CLI 用到的環境變數，而 storage 用來定義上傳雲服務 AWS S3 或 Minio 的 Interface:

```go
// Storage for s3 and disk
type Storage interface {
    // CreateBucket for create new folder
    CreateBucket(string, string) error
    // UploadFile for upload single file
    UploadFile(string, string, []byte, io.Reader) error
    // DeleteFile for delete single file
    DeleteFile(string, string) error
    // FilePath for store path + file name
    FilePath(string, string) string
    // GetFile for storage host + bucket + filename
    GetFileURL(string, string) string
    // DownloadFile downloads and saves the object as a file in the local filesystem.
    DownloadFile(string, string, string) error
    // BucketExist check object exist. bucket + filename
    BucketExists(string) (bool, error)
    // FileExist check object exist. bucket + filename
    FileExist(string, string) bool
    // GetContent for storage bucket + filename
    GetContent(string, string) ([]byte, error)
    // Copy Create or replace an object through server-side copying of an existing object.
    CopyFile(string, string, string, string) error
    // Client get storage client
    Client() interface{}
    // SignedURL get signed URL
    SignedURL(string, string, *core.SignedURLOptions) (string, error)
}
```

定義完成後，未來有其他的 Storage 需要支援，就可以直接在 storage 目錄底下建立新的目錄，接著就可以直接開發了。另外 dbdump 也是同樣原理，現在支援三種 Database 而已，未來可以接受擴充到任何資料庫型態。

```go
// Backup database interface
type Backup interface {
    // Exec backup database
    Exec() error
}
```

可以看到 NewEngine

```go
// NewEngine return storage interface
func NewEngine(cfg config.Config) (backup Backup, err error) {
    switch cfg.Database.Driver {
    case "postgres":
        return postgres.NewEngine(
            cfg.Database.Host,
            cfg.Database.Username,
            cfg.Database.Password,
            cfg.Database.Name,
            cfg.Storage.DumpName,
            cfg.Database.Opts,
        )
    case "mysql":
        return mysql.NewEngine(
            cfg.Database.Host,
            cfg.Database.Username,
            cfg.Database.Password,
            cfg.Database.Name,
            cfg.Storage.DumpName,
            cfg.Database.Opts,
        )
    case "mongo":
        return mongo.NewEngine(
            cfg.Database.Host,
            cfg.Database.Username,
            cfg.Database.Password,
            cfg.Database.Name,
            cfg.Storage.DumpName,
            cfg.Database.Opts,
        )
    }

    return nil, errors.New("We don't support Databaser Dirver: " + cfg.Database.Driver)
}
```

## 心得

雖然是一個不起眼的功能，但是還是花了一些時間把文件及結構寫清楚，對於之後在團隊導入或者是有新的 CLI 工具，都可以按照這格式進行，當然技術會一直改變，只會更好不會更差。希望這教學可以分享給想踏入 Go 語言，或者是想寫寫簡單的 CLI 工具的朋友們參考看看。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://blog.wu-boy.com/2020/12/docker-image-to-periodically-backup-your-database-mysql-postgres-or-mongodb-to-s3/
 [3]: https://docs.postgresql.tw/reference/client-applications/pg_dump
 [4]: https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html
 [5]: https://www.udemy.com/course/golang-fight/?couponCode=202012
 [6]: https://www.udemy.com/course/devops-oneday/?couponCode=202012
 [7]: https://www.udemy.com/course/docker-practice/?couponCode=202012
 [8]: http://facebook.com/appleboy46
 [9]: https://github.com/appleboy/docker-backup-database
 [10]: https://www.docker.com/
 [11]: https://min.io/
 [12]: https://www.drone.io/
 [13]: https://github.com/urfave/cli
 [14]: https://github.com/features/actions
 [15]: https://docs.gitlab.com/ee/ci/
