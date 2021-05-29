---
title: 在 Go 語言內的 URL RawQuery 的改變
author: appleboy
type: post
date: 2018-08-27T06:00:56+00:00
url: /2018/08/escape-url-rawquery-on-parse-in-golang/
dsq_thread_id:
  - 6876591611
categories:
  - Golang
tags:
  - golang

---
**更新 (2018.08.29) 感謝中國網友幫忙發個 [Issue][1]，大家有空可以關注看看，等官方怎麼回應**

[![][2]][2]

[Go 語言][3]內的 `net/url` 函式庫讓開發者可以簡單的 Parse 指定的 URL，最近 Google 上了這個 [Patch][4]，這個 Patch 讓原本的 RawQuery 值產生了變化，原先沒有驗證 RawQuery 是否包含了不合法的字元，現在只要 RawQuesy 內含有任意的不合法字元，就會直接被 `QueryEscape` 函式轉換，這個 Patch 不影響這次 [Go 1.11 版本][5]，會影響的是明年 2019 年釋出的 Go 1.12 版本，但是大家都知道在 [GitHub][6] 上面有在寫測試的話，都會在 [Travis][7] 內加入 `master` 版本當作驗證，如果有用到 RawQuery 的話，肯定會遇到這問題，底下來描述為什麼會出現這問題。

<!--more-->

## RawQuery 含有不合法字元

首先來看看在 Go 1.11 版本時本來應該輸出什麼，請直接線上看[例子][8]。

<pre><code class="language-go">package main

import (
    "log"
    "net/url"
)

func main() {
    u, err := url.Parse("http://bing.com/search?k=v&id=main&id=omit&array[]=first&array[]=second&ids<em></em>=111&ids[j]=3.14")
    if err != nil {
        log.Fatal(err)
    }

    if u.RawQuery != "k=v&id=main&id=omit&array[]=first&array[]=second&ids<em></em>=111&ids[j]=3.14" {
        log.Fatal("RawQuery error")
    }

    log.Printf("%#v", u.Query())
}</code></pre>

在 Go 1.11 以前，你會直接看到底下輸出:

> url.Values{"k":[]string{"v"}, "id":[]string{"main", "omit"}, "array[]":[]string{"first", "second"}, "ids__":[]string{"111"}, "ids[j]":[]string{"3.14"}}

[url 函式庫][9]幫忙把 RawQuery 整理成 map\[string\]\[\]string 格式，所以在 URL 內可以直接 Parse `array[]=first&array[]=second` 多個 Array 值。這個預設行為在最新的 Go 語言被換掉了，現在執行 `u.Query()` 你會看到變成底下，整串的 Raw Query String 被當長一個 Key 值了。

> url.Values{"k=v&id=main&id=omit&array[]=first&array[]=second&ids__=111&ids[j]=3.14": []string{""}}

這就是最大的改變，造成在 Travis 執行錯誤。

## 如何修正

修正方式其實很簡單，自己在寫個小型 Parser 把原本的格式在轉換就好，請參考[線上解法][10]

<pre><code class="language-go">package main

import (
    "log"
    "net/url"
    "strings"
)

func main() {
    u, err := url.Parse("http://bing.com/search?k=v&id=main&id=omit&array[]=first&array[]=second&ids<em></em>=111&ids[j]=3.14")
    if err != nil {
        log.Fatal(err)
    }

    if u.RawQuery != "k=v&id=main&id=omit&array[]=first&array[]=second&ids<em></em>=111&ids[j]=3.14" {
        log.Fatal("RawQuery error")
    }

    log.Printf("%#v", u.Query())

    query := resetQuery(map[string][]string{"k=v&id=main&id=omit&array[]=first&array[]=second&ids<em></em>=111&ids[j]=3.14": []string{""}})
    log.Printf("%#v", query)
}

func resetQuery(m map[string][]string) map[string][]string {
    dicts := make(map[string][]string)
    for k, v := range m {
        lists := strings.Split(k, "&")
        if len(lists) == 1 {
            dicts[k] = v
            continue
        }
        for _, vv := range lists {
            p := strings.Split(vv, "=")
            dicts[p[0]] = append(dicts[p[0]], p[1])
        }
    }
    return dicts
}</code></pre>

只要 RawQuery 裡面有包含底下字元，就會被 escape 掉

<pre><code class="language-bash">// validQuery reports whether s is a valid query string per RFC 3986
// Section 3.4:
//     query       = *( pchar / "/" / "?" )
//     pchar       = unreserved / pct-encoded / sub-delims / ":" / "@"
//     unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
//     sub-delims  = "!" / "$" / "&" / "'" / "(" / ")"
//                   / "*" / "+" / "," / ";" / "="</code></pre>

## 後記

現在含以前的版本都不會遇到這問題，如果你有用一些 Framework 請務必在明年釋出下一版後，一起跟著升級，[Gin][11] 現在已經發 [Patch][12] 修正了。

 [1]: https://github.com/golang/go/issues/27302
 [2]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [3]: https://golang.org/
 [4]: https://github.com/golang/go/commit/1040626c0ce4a1bc2b312aa0866ffeb2ff53c1ab
 [5]: https://blog.golang.org/go1.11
 [6]: https://github.com
 [7]: https://travis-ci.org
 [8]: https://play.golang.org/p/ZvZ-SoUjK16
 [9]: https://golang.org/pkg/net/url/
 [10]: https://play.golang.org/p/wO9vR3Ylliq
 [11]: https://github.com/gin-gonic/gin
 [12]: https://github.com/gin-gonic/gin/pull/1510