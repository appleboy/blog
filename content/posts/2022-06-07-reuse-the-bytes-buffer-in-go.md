---
title: "在 Go 語言內使用 bytes.Buffer 注意事項"
date: 2022-06-07T20:42:17+08:00
type: post
slug: reuse-the-bytes-buffer-in-go
share_img: https://i.imgur.com/FD5go1t.png
categories:
  - Golang
tags:
  - golang
  - bytes.Buffer
---

![logo](https://i.imgur.com/FD5go1t.png)

在 [Go 語言][3]中，如何高效的處理字串相加，由於字串 (string) 是不可變的，所以將很多字串拼接起來，會如同宣告新的變數來儲存。這邊就可以透過 [strings.Builder][1] 或 [bytes.Buffer][2] 來解決字串相加效能問題。除了效能問題之外，還需要注意在 `bytes.Buffer` 處理 `[]byte` 及 `string` 之間的轉換，底下拿實際專案上寫出來的錯誤給大家參考看看

[1]:https://pkg.go.dev/strings
[2]:https://pkg.go.dev/bytes
[3]:https://go.dev

<!--more-->

## bytes.Buffer 重複使用問題

專案用 bytes.Buffer 套件處理資料 Parsing 後的結果，底下是一個基本範例

```go
package main

import (
  "bytes"
  "fmt"
)

var buf bytes.Buffer

func parseMultipleValue(n int, str string) []byte {
  buf.Reset()
  for i := 0; i < n; i++ {
    buf.WriteString(str)
  }
  return buf.Bytes()
}

func main() {
  s1 := parseMultipleValue(5, "1")
  fmt.Println("s1:", string(s1))
  s2 := parseMultipleValue(3, "2")
  fmt.Println("s1:", string(s1))
  fmt.Println("s2:", string(s2))
}
```

請直接[線上打開範例跑看看][11]，執行後的結果會是

[11]:https://go.dev/play/p/h1ENIht6vQi

```sh
s1: 11111
s1: 22211
s2: 222
```

大家有無看到，如果要存取 `s1` 第二次的結果，會發現後者 `s2` 資料蓋掉部分 `s1` 資料。原因是這樣，當第一次 s1 拿到的是有 5 位元空間的記憶體，而當執行第二次 `parseMultipleValue` 後，透過 `bytes.Rest()` 只是將 offset 位置移動到 0 位置，並將新的內容給寫入到同樣記憶體位置前面區段。固本來 `s1` 的內容前 3 個字元被改成新的 `s2` 字串。

## 兩種解決方式

該怎麼做可以不影響 `s1` 的內容呢？直接用 bytes.Buffer 內建函示 `String()` 可以解決此問題。

```go
var buf bytes.Buffer

func parseMultipleValue(n int, str string) string {
  buf.Reset()
  for i := 0; i < n; i++ {
    buf.WriteString(str)
  }
  return buf.String()
}
```

如果不透過 `String()` 解決的話，也可以透過 copy 方式來處理，並且使用 `unsafe.Pointer` 來做 byte 轉 string 的效能優化

```go
var buf bytes.Buffer

func b2s(b []byte) string {
  return *(*string)(unsafe.Pointer(&b))
}

func parseMultipleValue(n int, str string) string {
  buf.Reset()
  for i := 0; i < n; i++ {
    buf.WriteString(str)
  }
  s := make([]byte, len(buf.Bytes()))
  copy(s, buf.Bytes())
  return b2s(s)
}
```

上述兩種解法最終都能解決問題，效能也沒有差異，故大家可以選其中一種即可。

```sh
BenchmarkA
BenchmarkA-8                       34922             33986 ns/op          106496 B/op          1 allocs/op
BenchmarkB
BenchmarkB-8                       35760             33714 ns/op          106496 B/op          1 allocs/op
```

附上完整程式碼

```go
package main

import (
  "bytes"
  "math/rand"
  "testing"
  "unsafe"
)

const letterBytes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

func randomString(n int) string {
  b := make([]byte, n)
  for i := range b {
    b[i] = letterBytes[rand.Intn(len(letterBytes))]
  }
  return string(b)
}

var buf bytes.Buffer

func b2s(b []byte) string {
  return *(*string)(unsafe.Pointer(&b))
}

func parseMultipleValue(n int, str string) string {
  buf.Reset()
  for i := 0; i < n; i++ {
    buf.WriteString(str)
  }
  s := make([]byte, len(buf.Bytes()))
  copy(s, buf.Bytes())
  return b2s(s)
}

func parseMultipleValue2(n int, str string) string {
  buf.Reset()
  for i := 0; i < n; i++ {
    buf.WriteString(str)
  }

  return buf.String()
}

func benchmark(b *testing.B, f func(int, string) string) {
  str := randomString(10)
  b.ReportAllocs()
  for i := 0; i < b.N; i++ {
    f(10000, str)
  }
}

func BenchmarkA(b *testing.B) { benchmark(b, parseMultipleValue) }
func BenchmarkB(b *testing.B) { benchmark(b, parseMultipleValue2) }
```

## 心得

由於需要分析非常大的檔案 (200MB) 內容及時程非常趕，故沒有寫完整的測試，才沒發現這個錯誤，果然自己的一時疏忽，造成這個失誤，補上完整的測試後，就可以再陸續針對效能進行優化。
