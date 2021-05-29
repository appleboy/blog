---
title: 'Git 版本控制: 「You have some suspicious patch lines」'
author: appleboy
type: post
date: 2010-08-18T06:18:11+00:00
url: /2010/08/git-版本控制-「you-have-some-suspicious-patch-lines」/
views:
  - 2475
bot_views:
  - 327
dsq_thread_id:
  - 246757672
categories:
  - Git
tags:
  - git
  - 版本控制

---
相信大家對 [Git][1] 並不陌生，這次在升級 [Moztw][2] 的[討論區][3]，從 3.0.5 升級到 3.0.7 p1，過程由其他 Moztw 成員升級，我在將最後程式 commit 到 [github][4]，因為兩個版本差異性很大，所以有新增多個檔案，commit 過程出現了錯誤訊息：「<span style="color:red"><strong>You have some suspicious patch lines</strong></span>」，這是因為 git 會檢查每行程式碼最後是否有多餘空白或者是 Tab 按鍵，為瞭解決此問題，可以去修改 <span style="color:green"><strong>.git/hooks/pre-commit</strong></span>，將底下程式碼： 

<pre class="brush: bash; title: ; notranslate" title="">if (s/^\+//) {
    $lineno++;
    chomp;
    if (/\s$/) {
        bad_line("trailing whitespace", $_);
    }
    if (/^\s* \t/) {
        bad_line("indent SP followed by a TAB", $_);
    }
    if (/^([<>])\1{6} |^={7}$/) {
        bad_line("unresolved merge conflict", $_);
    }
}</pre> 改成： 

<pre class="brush: bash; title: ; notranslate" title="">if (s/^\+//) {
    $lineno++;
    chomp;
#   if (/\s$/) {
#       bad_line("trailing whitespace", $_);
#   }
#   if (/^\s* \t/) {
#       bad_line("indent SP followed by a TAB", $_);
#   }
    if (/^([<>])\1{6} |^={7}$/) {
        bad_line("unresolved merge conflict", $_);
    }
}</pre> 暫時停止 git 過濾字串，等 commit 完成之後，在將其 unmask 掉。 參考網站： 

[Git on Windows: 「You have some suspicious patch lines」][5]

 [1]: http://git-scm.com/
 [2]: http://Moztw.org
 [3]: http://forum.moztw.org
 [4]: http://github.com/
 [5]: http://www.dont-panic.cc/capi/2007/07/13/git-on-windows-you-have-some-suspicious-patch-lines/