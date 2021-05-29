---
title: 在 git Commit 之前檢查 PHP 是否有錯誤
author: appleboy
type: post
date: 2013-02-08T07:12:00+00:00
url: /2013/02/git-hooks-parse-php-error-before-commit/
dsq_thread_id:
  - 1071710566
categories:
  - Git
tags:
  - CoffeeScript
  - git
  - git hooks
  - Github
  - php

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8455538800/" title="Git-Logo-2Color by appleboy46, on Flickr"><img src="https://i0.wp.com/farm9.staticflickr.com/8523/8455538800_30f65954f8.jpg?resize=500%2C209&#038;ssl=1" alt="Git-Logo-2Color" data-recalc-dims="1" /></a>
</div> 在 commit code 之前，程式設計師必須確保程式碼的正確性，包含不要放入 debug message 到 

<a href="http://git-scm.com/" target="_blank">git</a> server，寫了一個簡單的 pre-commit 程式，來確保 PHP 是否有 Parse error，或者是在寫 CoffeeScript 及 JavaScript 時，常常會用到 console.* 來當作中斷點或者是顯示變數資料，這也是需要盡量避免 commit 到伺服器，你可不想要長官 review 的時候看到這麼多 debug 訊息吧。這時候就是需要 <a href="http://git-scm.com/book/en/Customizing-Git-Git-Hooks" target="_blank">git-hooks</a> 的 **<span style="color:red">pre-commit</span>** 幫忙檢查這些 Syntax 語法，可以直接參考[我的 git-hooks 專案][1]。安裝方式很簡單: 

<pre class="brush: bash; title: ; notranslate" title="">$ git clone https://github.com/appleboy/git-hooks.git
$ chmod +x bin/hooks.sh pre-commit
$ ./bin/hooks.sh your_project_path</pre> 如果使用 git commit 之前，就會檢查 .js、.coffee、.php 等副檔名。

 [1]: https://github.com/appleboy/git-hooks