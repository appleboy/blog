---
title: gofight 支援多個檔案上傳測試
author: appleboy
type: post
date: 2018-09-25T01:20:29+00:00
url: /2018/09/gofight-support-upload-file-testing/
dsq_thread_id:
  - 6930724519
categories:
  - Golang
  - Testing
tags:
  - gofight
  - golang
  - Testing

---
[![][1]][1]

[gofight][2] 是一套用 [Go 語言][3]撰寫的 HTTP API 測試套件，之前已經寫過[一篇介紹用法][4]，當時候尚未支援檔案上傳測試，也就是假設寫了一個[檔案上傳的 http handler][5] 在專案內如何寫測試，底下來看看該如何使用。

<!--more-->

## 準備環境

首先需要一個測試檔案，通常會在專案底下建立 `testdata` 目錄，裡面放置一個叫 `hello.txt` 檔案，內容為 `world`。接著安裝 `gofight` 套件，可以用團隊內喜愛的 vendor 工具，我個人偏好 [govendor][6]：

```shell
$ govendor fetch github.com/kardianos/govendor
或
$ go get -u github.com/kardianos/govendor
```

## 檔案上傳範例

這邊用 [gin][7] 框架當作範例，如果您用其他框架只要支援 `http.HandlerFunc` 都可以使用。

```go
func gintFileUploadHandler(c *gin.Context) {
    ip := c.ClientIP()
    hello, err := c.FormFile("hello")
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": err.Error(),
        })
        return
    }

    helloFile, _ := hello.Open()
    helloBytes := make([]byte, 6)
    helloFile.Read(helloBytes)

    world, err := c.FormFile("world")
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": err.Error(),
        })
        return
    }

    worldFile, _ := world.Open()
    worldBytes := make([]byte, 6)
    worldFile.Read(worldBytes)

    foo := c.PostForm("foo")
    bar := c.PostForm("bar")
    c.JSON(http.StatusOK, gin.H{
        "hello":     hello.Filename,
        "world":     world.Filename,
        "foo":       foo,
        "bar":       bar,
        "ip":        ip,
        "helloSize": string(helloBytes),
        "worldSize": string(worldBytes),
    })
}

// GinEngine is gin router.
func GinEngine() *gin.Engine {
    gin.SetMode(gin.TestMode)
    r := gin.New()
    r.POST("/upload", gintFileUploadHandler)

    return r
}
```

上面例子可以發現，測試端需要傳兩個 post 參數，加上一個檔案 (檔名為 test)，底下看看 gofight 怎麼寫測試。

## 檔案上傳測試

gofight 現在支援一個函式叫 `SetFileFromPath` 此 func 支援兩個參數。

  1. 上傳檔案格式
  2. POST 參數

第一項上傳檔案格式，可以是從實體路徑讀取，或者是透過 `[]byte` 讀取兩種格式都可以，在 gofight 可以看到 `UploadFile` struct 如下:

```go
// UploadFile for upload file struct
type UploadFile struct {
    Path    string
    Name    string
    Content []byte
}
```

假設是透過實體路徑上傳，請在 `Path` 填上實體路徑名稱，例如: `./testdata/hello.txt`，而 `Name` 則是在 Gin 裡面接受的 Upload File 名稱 `c.FormFile("hello")`，其中的 `hello` 參數。底下是一個實際例子教大家如何上傳多個檔案測試。

```go
func TestUploadFile(t *testing.T) {
    r := New()

    r.POST("/upload").
        SetDebug(true).
        SetFileFromPath([]UploadFile{
            {
                Path: "./testdata/hello.txt",
                Name: "hello",
            },
            {
                Path: "./testdata/world.txt",
                Name: "world",
            },
        }, H{
            "foo": "bar",
            "bar": "foo",
        }).
        Run(framework.GinEngine(), func(r HTTPResponse, rq HTTPRequest) {
            data := []byte(r.Body.String())

            hello := gjson.GetBytes(data, "hello")
            world := gjson.GetBytes(data, "world")
            foo := gjson.GetBytes(data, "foo")
            bar := gjson.GetBytes(data, "bar")
            ip := gjson.GetBytes(data, "ip")
            helloSize := gjson.GetBytes(data, "helloSize")
            worldSize := gjson.GetBytes(data, "worldSize")

            assert.Equal(t, "world\n", helloSize.String())
            assert.Equal(t, "hello\n", worldSize.String())
            assert.Equal(t, "hello.txt", hello.String())
            assert.Equal(t, "world.txt", world.String())
            assert.Equal(t, "bar", foo.String())
            assert.Equal(t, "foo", bar.String())
            assert.Equal(t, "", ip.String())
            assert.Equal(t, http.StatusOK, r.Code)
            assert.Equal(t, "application/json; charset=utf-8", r.HeaderMap.Get("Content-Type"))
        })
}
```

假設專案內有使用 [Resource Embedding][8] 像是 [fileb0x][9]，就可以透過設定 `Content` 方式來讀取喔，要注意的是，由於不是從實體路徑讀取，所以 `Path` 請直接放檔案名稱即可。測試程式碼如下:

```go
    r := New()

    helloContent, err := ioutil.ReadFile("./testdata/hello.txt")
    if err != nil {
        log.Fatal(err)
    }

    worldContent, err := ioutil.ReadFile("./testdata/world.txt")
    if err != nil {
        log.Fatal(err)
    }

    r.POST("/upload").
        SetDebug(true).
        SetFileFromPath([]UploadFile{
            {
                Path:    "hello.txt",
                Name:    "hello",
                Content: helloContent,
            },
            {
                Path:    "world.txt",
                Name:    "world",
                Content: worldContent,
            },
        }, H{
            "foo": "bar",
            "bar": "foo",
        }).
        Run(framework.GinEngine(), func(r HTTPResponse, rq HTTPRequest) {
            data := []byte(r.Body.String())

            hello := gjson.GetBytes(data, "hello")
            world := gjson.GetBytes(data, "world")
            foo := gjson.GetBytes(data, "foo")
            bar := gjson.GetBytes(data, "bar")
            ip := gjson.GetBytes(data, "ip")
            helloSize := gjson.GetBytes(data, "helloSize")
            worldSize := gjson.GetBytes(data, "worldSize")

            assert.Equal(t, "world\n", helloSize.String())
            assert.Equal(t, "hello\n", worldSize.String())
            assert.Equal(t, "hello.txt", hello.String())
            assert.Equal(t, "world.txt", world.String())
            assert.Equal(t, "bar", foo.String())
            assert.Equal(t, "foo", bar.String())
            assert.Equal(t, "", ip.String())
            assert.Equal(t, http.StatusOK, r.Code)
            assert.Equal(t, "application/json; charset=utf-8", r.HeaderMap.Get("Content-Type"))
        })
```

## 心得

其實這類測試 HTTP Handler API 的套件相當多，當時就自幹一套當作練習，後來每個 Go 專案，我個人都用自己寫的這套，測試起來相當方便。更多詳細的用法請直接看 [gofight 文件][2]。對於 Go 語言有興趣的朋友們，可以直接參考我的[線上課程][10]。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://github.com/appleboy/gofight
 [3]: https://golang.org
 [4]: https://blog.wu-boy.com/2016/04/gofight-tool-for-api-handler-testing-in-golang/
 [5]: https://github.com/gin-gonic/gin/#upload-files
 [6]: https://github.com/kardianos/govendor
 [7]: https://github.com/gin-gonic/gin
 [8]: https://github.com/avelino/awesome-go#resource-embedding
 [9]: https://github.com/UnnoTed/fileb0x
 [10]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-TOP
