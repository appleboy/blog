---
title: 用 Go 語言實現單一或多重 Queue 搭配 optimistic concurrency
author: appleboy
type: post
date: 2018-03-10T08:26:38+00:00
url: /2018/03/simple-queue-with-optimistic-concurrency-in-go/
dsq_thread_id:
  - 6536233696
categories:
  - Golang
tags:
  - golang
  - mongodb
  - transaction

---
[<img src="https://i2.wp.com/farm5.staticflickr.com/4781/25850362427_fb8199a5ee_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-03-10 at 3.22.59 PM" data-recalc-dims="1" />][1]

本篇教學會著重在如何使用 Go 語言的 [goroutine][2] 及 [channel][3]。[MongoDB][4] 是一套具有高效能讀寫的 NoSQL 資料庫，但是不像傳統關連式資料庫，有非常好用的 Transaction 交易模式，而在 MongoDB 也可以透過 [Two Phase Commits][5] 來達成交易功能，大家可以先打開文件看看，非常冗長，工程師需要花很多時間閱讀文件並且實現出來。而在 [Go 語言][6]內，我們可以在 Single Thread 內同一時間點讀寫存取同一筆資料庫來解決此問題。此篇作法只適合運作在單一 application，如果是執行多個 application 則需要透過其他方式來解決，像是 [Optimistic concurrency control][7]。

<!--more-->

## 問題描述

* * *

底下步驟來產生資料

  1. 建立使用者，並且初始化每人 $1000 USD
  2. 接到新的交易請求
  3. 讀取使用者帳戶剩餘存款
  4. 將該帳號增加 $50 USD

根據上述的需求，我們可以知道，當有 100 個連線交易時，理論上該使用者的存款會變成 $1000 + $50*100 = $6000 USD。這是理想狀態，假設如果同時間打上來，大家可以知道最後存款肯定不到 $6000。底下程式碼可以複製出此問題

```go
func main() {
    session, _ := mgo.Dial("localhost:27017")
    globalDB = session.DB("queue")
    globalDB.C("bank").DropCollection()

    user := currency{Account: account, Amount: 1000.00, Code: "USD"}
    err := globalDB.C("bank").Insert(&user)

    if err != nil {
        panic("insert error")
    }

    log.Println("Listen server on 8000 port")
    http.HandleFunc("/", pay)
    http.ListenAndServe(":8000", nil)
}
```

上述是主程式，新增一個 Handle 為 pay，用來處理交易。

```go
func pay(w http.ResponseWriter, r *http.Request) {
    entry := currency{}
    // step 1: get current amount
    err := globalDB.C("bank").Find(bson.M{"account": account}).One(&entry)

    if err != nil {
        panic(err)
    }

    wait := Random(1, 100)
    time.Sleep(time.Duration(wait) * time.Millisecond)

    //step 3: subtract current balance and update back to database
    entry.Amount = entry.Amount + 50.000
    err = globalDB.C("bank").UpdateId(entry.ID, &entry)

    if err != nil {
        panic("update error")
    }

    fmt.Printf("%+v\n", entry)

    io.WriteString(w, "ok")
}
```

## 解決方式

這邊提供幾個解決方式，第一種就是透過 `sync.Mutex` 方式，直接將交易區段程式碼 lock 住，這樣可以避免同時寫入或讀出的問題。在 Handler 內直接新增底下程式碼就可以解決，詳細程式碼請參考 [safe.go][8]

```go
mu.Lock()
defer mu.Unlock()
```

第二種方式可以用 Go 語言內的優勢: [goroutine][2] + [channel][3]，在這邊我們只要建立兩個 Channle，第一個是使用者帳號 (string) 第二個是輸出 Result (struct)。[完整程式碼範例][9]

```go
in = make(chan string)
out = make(chan Result)
```

在 main func 內建立第一個 goroutine

```go
go func(in *chan string) {
  for {
    select {
    case account := <-*in:
      entry := currency{}
      // step 1: get current amount
      err := globalDB.C("bank").Find(bson.M{"account": account}).One(&entry)

      if err != nil {
        panic(err)
      }

      //step 3: subtract current balance and update back to database
      entry.Amount = entry.Amount + 50.000
      err = globalDB.C("bank").UpdateId(entry.ID, &entry)

      if err != nil {
        panic("update error")
      }

      out <- Result{
        Account: account,
        Result:  entry.Amount,
      }
    }
  }

}(&in)
```

上面可以很清楚看到使用到 `select` 來接受 input channel，並且透過 `go` 將 for loop 丟到背景執行。所以在每個交易時，將帳號丟到 `in` channel 內，就可以開始進行交易，同時間並不會有其他交易。在 handler 內，也是透過此方式來讀取使用者最後存款餘額

```go
wg := sync.WaitGroup{}
wg.Add(1)

go func(wg *sync.WaitGroup) {
  in <- account
  for {
    select {
    case result := <-out:
      fmt.Printf("%+v\n", result)
      wg.Done()
      return
    }
  }
}(&wg)

wg.Wait()
```

不過上面這方法，可想而知，只有一個 Queue 幫忙處理交易資料，那假設有幾百萬個交易要同時進行呢，該如何消化更多的交易，就要將上面程式碼改成 Multiple Queue [完整程式碼範例][10]。假設我們有 100 個帳號，開 10 個 Queue 去處理，每一個 Queue 來處理 10 個帳號，也就是說 ID 為 23 號的分給第 3 (23 % 10) 個 Queue，ID 為 59 號則分給第 9 個 Queue。

```go
for i := range in {
  go func(in *chan string, i int) {
    for {
      select {
      case account := <-*in:
        out <- Result{
          Account: account,
          Result:  entry.Amount,
        }
      }
    }

  }(&in, i)
}
```

其中 channel 要宣告為底下: maxThread 為 10 (可以由開發者任意設定)

```go
in = make([]chan string, maxThread)
out = make([]chan Result, maxThread)
```

## Optimistic concurrency control

假設需要擴展服務，執行超過一個服務，就會遇到 [Optimistic concurrency control][7]，原因在上述方法只能保證在單一服務內不會同時存取同一筆資料，但是如果是多個服務則還是會發生同時存取或寫入單筆資料。這邊可以用簡單的機制來解決應用層的問題，直接在資料表加上 `Version`，初始值為 `1`，要執行更新時請透過底下語法來更新:

```go
entry.Amount = entry.Amount + 50.000
err = globalDB.C("bank").Update(bson.M{
  "version": entry.Version,
  "_id":     entry.ID,
}, bson.M{"$set": map[string]interface{}{
  "amount":  entry.Amount,
  "version": (entry.Version + 1),
}})

if err != nil {
  goto LOOP
}
```

如果資料不存在時，就無法寫入，這樣可以避免同時寫入問題。

## 效能測試

上述提供了幾種解決方式，但是該選擇哪一種會比較好呢，底下是透過 [vegeta] http 效能檢測工具來實驗看看，底下先整理結果

  1. 使用 sync.Mutex
  2. 使用 single queue
  3. 使用 multiple queue
  4. 使用 optimistic concurrency 解決方案
  5. 使用 single queue + optimistic concurrency 解決方案
  6. 使用 multiple queue + optimistic concurrency 解決方案

直接給數據看看

|                           | max Latencies | mean Latencies | user account |
| ------------------------- | ------------- | -------------- | ------------ |
| sync lock                 | 26.250468944s | 13.171447347s  | 1            |
| optimistic lock           | 5.016707396s  | 1.903748023s   | 1            |
| single queue              | 66.078117ms   | 763.662µs      | 1            |
| multiple queue            | 49.270982ms   | 789.131µs      | 100          |
| optimistic single queue   | 139.045488ms  | 1.297197ms     | 1            |
| optimistic multiple queue | 51.268963ms   | 924.951µs      | 100          |

如果只需要執行單一服務，可以選擇 `multiple queue`，這不是最好的解法，要執行多個服務，請務必使用 `optimistic multiple queue`

## 結論

詳細的程式碼都有放在 [go-transaction-example][11]，歡迎大家拿去測試看看。最後宣傳一下自己最近開的 [Go 語言課程][12]，限時特價 **$1600** 如果想趁這機會踏入 Go 語言，可以透過此線上課程學到基礎實戰，包含本片的的影音教學。

 [1]: https://www.flickr.com/photos/appleboy/25850362427/in/dateposted-public/ "Screen Shot 2018-03-10 at 3.22.59 PM"
 [2]: https://gobyexample.com/goroutines
 [3]: https://gobyexample.com/channels
 [4]: https://www.mongodb.com/
 [5]: https://docs.mongodb.com/manual/tutorial/perform-two-phase-commits/
 [6]: https://golang.org
 [7]: https://en.wikipedia.org/wiki/Optimistic_concurrency_control
 [8]: https://github.com/go-training/go-transaction-example/blob/master/safe/safe.go
 [9]: https://github.com/go-training/go-transaction-example/blob/master/queue/single_queue.go
 [10]: https://github.com/go-training/go-transaction-example/blob/master/multiple_queue/multiple_queue.go
 [11]: https://github.com/go-training/go-transaction-example
 [12]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-INTRO
