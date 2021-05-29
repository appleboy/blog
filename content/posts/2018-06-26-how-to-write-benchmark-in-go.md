---
title: 如何在 Go 語言內寫效能測試
author: appleboy
type: post
date: 2018-06-26T02:18:50+00:00
url: /2018/06/how-to-write-benchmark-in-go/
dsq_thread_id:
  - 6754994162
categories:
  - Golang
tags:
  - benchmark
  - golang

---
[![golang logo][1]][1]

[Go 語言][2]不只有內建基本的 [Testing][3] 功能，另外也內建了 [Benchmark][4] 工具，讓開發者可以快速的驗證自己寫的程式碼效能如何？該如何使用基本的 Benchmark 工具，底下用簡單的例子來說明如何寫 Benchmark，透過內建工具可以知道程式碼單次執行多少時間，以及用了多少記憶體。不多說直接用『數字轉字串』來當例子。

<!--more-->

## 線上影片

如果您不想看底下的文字說明，可以直接參考線上影片教學：

另外我在 Udemy 上面開了兩門課程，一門 drone 另一門 golang 教學，如果對這兩門課有興趣的話，都可以購買，目前都是特價 $1800

  * [Go 語言實戰][5] $1800
  * [一天學會 DEVOPS 自動化流程][6] $1800

如果兩們都有興趣想一起合買，請直接匯款到下面帳戶，特價 **$3000**

  * 富邦銀行: 012
  * 富邦帳號: 746168268370
  * 匯款金額: 台幣 $3000 元

## 如何寫 Benchmark

建立 `main_test.go` 檔案

```go
func BenchmarkPrintInt2String01(b *testing.B) {
    for i := 0; i < b.N; i++ {
        printInt2String01(100)
    }
}
```

  * 檔案名稱一定要用 `_test.go` 當結尾
  * func 名稱開頭要用 `Benchmark`
  * for 循環內要放置要測試的程式碼
  * b.N 是 go 語言內建提供的循環，根據一秒鐘的時間計算
  * 跟測試不同的是帶入 `b *testing.B` 參數

底下是測試指令:

```bash
$ go test -v -bench=. -run=none .
goos: darwin
goarch: amd64
BenchmarkPrintInt2String01-4    10000000               140 ns/op
PASS
```

基本的 benchmark 測試也是透過 `go test` 指令，不同的是要加上 `-bench=.`，這樣才會跑 benchmark 部分，否則預設只有跑測試程式，大家可以看到 `-4` 代表目前的 CPU 核心數，也就是 `GOMAXPROCS` 的值，另外 `-run` 可以用在跑特定的測試函示，但是假設沒有指定 `-run` 時，你會看到預設跑測試 + benchmark，所以這邊補上 `-run=none` 的用意是不要跑任何測試，只有跑 benchmark，最後看看輸出結果，其中 `10000000` 代表一秒鐘可以跑 1000 萬次，每一次需要 `140 ns`，如果你想跑兩秒，請加上此參數在命令列 `-benchtime=2s`，但是個人覺得沒什麼意義。

## 效能比較

底下直接看看『數字轉字串』效能評估，參考底下寫出三種數字轉字串函式，[線上程式碼][7]

```go
func printInt2String01(num int) string {
    return fmt.Sprintf("%d", num)
}

func printInt2String02(num int64) string {
    return strconv.FormatInt(num, 10)
}
func printInt2String03(num int) string {
    return strconv.Itoa(num)
}
```

接著寫 benchmark，[線上程式碼][8]

```go
func BenchmarkPrintInt2String01(b *testing.B) {
    for i := 0; i < b.N; i++ {
        printInt2String01(100)
    }
}

func BenchmarkPrintInt2String02(b *testing.B) {
    for i := 0; i < b.N; i++ {
        printInt2String02(int64(100))
    }
}

func BenchmarkPrintInt2String03(b *testing.B) {
    for i := 0; i < b.N; i++ {
        printInt2String03(100)
    }
}
```

跑測試

```bash
$ go test -v -bench=. -run=none -benchmem .
goos: darwin
goarch: amd64
BenchmarkPrintInt2String01-4    10000000               125 ns/op              16 B/op          2 allocs/op
BenchmarkPrintInt2String02-4    30000000                37.8 ns/op             3 B/op          1 allocs/op
BenchmarkPrintInt2String03-4    30000000                38.6 ns/op             3 B/op          1 allocs/op
PASS
ok      _/Users/mtk10671/git/go/src/github.com/go-training/training/example20-write-benchmark   3.800s
```

可以很清楚看到使用 `strconv.FormatInt` 效能是最好的。透過 `-benchmem` 可以清楚知道記憶體分配方式，用此方式就可以知道要優化哪些函示。`1 allocs/op` 代表每次執行都需要搭配一個記憶體空間，而一個記憶體空間為 `3 Bytes`。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org/
 [3]: https://golang.org/pkg/testing/
 [4]: https://golang.org/pkg/testing/#hdr-Benchmarks
 [5]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-TOP
 [6]: https://www.udemy.com/devops-oneday/?couponCode=DRONE-DEVOPS
 [7]: https://github.com/go-training/training/blob/26838fcdfaa49e2c5e1b893c84498a5f28c2e7ac/example20-write-benchmark/main.go#L8-L23
 [8]: https://github.com/go-training/training/blob/26838fcdfaa49e2c5e1b893c84498a5f28c2e7ac/example20-write-benchmark/main_test.go#L23-L39