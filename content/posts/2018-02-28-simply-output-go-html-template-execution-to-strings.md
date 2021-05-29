---
title: 將 Go Html Template 存入 String 變數
author: appleboy
type: post
date: 2018-02-28T01:12:52+00:00
url: /2018/02/simply-output-go-html-template-execution-to-strings/
dsq_thread_id:
  - 6512307646
categories:
  - Golang
tags:
  - golang

---
[![][1]][1]

在 [Go 語言][2]內通常都將 [Html Temaple][3] 寫入到 `io.Writer interface` 像是 `*http.ResponseWriter`，但是有些情境需要將 Template 寫入到 String 變數內，例如實作簡訊 Template，這時候需要將 Html Temaple 轉成 String。該如何實作，非常簡單，只需要在任意變數內實作 `io.Writer interface` 即可，而 String 該如何轉換呢？可以使用 buffer's pointer

<!--more-->

```go
func GetString(filename string, data interface{}) (string, error) {
    t := template.New(filename).Funcs(NewFuncMap())

    content, err := ReadFile(filename)

    if err != nil {
        logrus.Warnf("Failed to read builtin %s template. %s", filename, err)
        return "", err
    }

    t.Parse(
        string(content),
    )

    var tpl bytes.Buffer
    if err := t.Execute(&tpl, data); err != nil {
        return "", err
    }

    return tpl.String(), nil
}
```

其中 `ReadFile` 是讀取檔案函式，`NewFuncMap` 則是 [Function Map][4]。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org/
 [3]: https://golang.org/pkg/text/template/
 [4]: https://golang.org/pkg/text/template/#FuncMap