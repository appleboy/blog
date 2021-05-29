---
title: 在 WordPress 內寫 Markdown 語法
author: appleboy
type: post
date: 2016-04-09T07:14:31+00:00
url: /2016/04/write-markdown-in-wordpress/
dsq_thread_id:
  - 4732456359
categories:
  - wordpress
tags:
  - Jetpack
  - Markdwon
  - SyntaxHighlighter
  - wordpress

---
在 [Markdown][1] 還沒出來之前，要寫一篇部落格教學真的非常麻煩，尤其是要學習 html 語法及如何引用程式碼在文章內，Markdwon 的出現，改變了整個工程師寫 Blog 的習慣，現在不管使用任何網站，沒有支援 Markdwon 語法，真的就不太想留言或發文了。最早以前自己的部落格是用 [WP-Markdwon][2] 這套 Plugin，但是這套 Plugin 在整合 [SyntaxHighlighter Evolved][3] 的時候根本無法使用，需要特定的語法才可以使用。WP-Markdwon 有個好用的工具那就是 editor tool bar，幫你省下製作 hyperlink 的時間，會自動幫忙編號，如果沒有 SyntaxHighlighter 需求，我個人是推薦用 WP-Markdwon。

<!--more-->

## golang 範例

<pre><code class="language-go">package main

import (
    "fmt"
)

func main() {
    fmt.Println("Welcome Golang World")
}</code></pre>

為了解決 SyntaxHighlighter 問題，後來換到 [jetpack][4] plugin，這套 Plugin 蠻強大的，內建一堆好用的工具，像是會自動分析每天來造訪你的 Blog 有哪些人。所以推薦大家用 jetpack。最後要學習 Markdown 語法，可以直接參考[這網站教學][5]。

 [1]: https://zh.wikipedia.org/wiki/Markdown
 [2]: https://wordpress.org/plugins/wp-markdown/
 [3]: https://wordpress.org/plugins/syntaxhighlighter/
 [4]: https://wordpress.org/plugins/jetpack/
 [5]: http://markdown.tw/