---
title: Git tips 請不要 commit 已經註解的程式碼
author: appleboy
type: post
date: 2015-11-05T06:52:32+00:00
url: /2015/11/git-tips-don-t-commit-commented-out-code/
dsq_thread_id:
  - 4291178824
categories:
  - Git
tags:
  - git

---
<div style="margin:0 auto; text-align:center">
  <div style="margin:0 auto; text-align:center">
    <a href="https://www.flickr.com/photos/appleboy/13158675193/" title="github-logo by appleboy46, on Flickr"><img src="https://i0.wp.com/farm3.staticflickr.com/2238/13158675193_2892abac95_n.jpg?resize=320%2C127&#038;ssl=1" alt="github-logo" data-recalc-dims="1" /></a>
  </div>
</div>

上週看到一篇國外作者寫的 [Please, don’t commit commented out code][1]，裡面內文真的不得不按讚啊，對於每天都要 review code 的開發者來說，最不喜歡看到的就是類似下面的程式碼

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">this.test = function(req, res, next) {

  // if (foo) {
  //   return '1';
  // } else if (bar) {
  //   return '2';
  // }

  return 3;
};
</pre>
</div>

<!--more-->

上面的程式碼在 git diff 指令會產生如下

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/22378926057/in/datetaken-public/" title="Screen Shot 2015-11-05 at 2.23.06 PM"><img src="https://i2.wp.com/farm6.staticflickr.com/5814/22378926057_de3b3d8950_o.png?resize=557%2C423&#038;ssl=1" alt="Screen Shot 2015-11-05 at 2.23.06 PM" data-recalc-dims="1" /></a>

可是正確來說應該是看到底下畫面

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/22771397296/in/datetaken-public/" title="Screen Shot 2015-11-05 at 2.32.03 PM"><img src="https://i1.wp.com/farm1.staticflickr.com/567/22771397296_1ab926cdcc_o.png?resize=554%2C346&#038;ssl=1" alt="Screen Shot 2015-11-05 at 2.32.03 PM" data-recalc-dims="1" /></a>

上面這張圖才是對於開發團隊有幫助的，文章內作者提到幾點為什麼不要留下已經註解的程式碼，底下是作者的一些看法，我覺得相當實用啊

### 造成誤解或誤會

對我而言這點是最大的原因，假設你是剛加入團隊，或者是每天需要 review 別人程式碼的開發者來說，當你看到被註解的程式碼，第一的感覺是什麼，我自己是會停住，並且想想為什麼前一位開發者會將這段程式碼註解呢？也許這段註解對於團隊是非常**_重要_**？但是你的思緒已經停住，是不是會想找上一位開發者討論呢？而造成不必要的誤解，也浪費了其他開發者時間。每次找該開發者詢問的的結果都是『喔 忘記砍掉了』

### 隱藏重要的程式碼

請看原作者提出的範例

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">// dozens
// of
// lines
// of
// commented
// code
someImportantCode()
// dozens
// of
// more
// lines
// of
// commented
// code</pre>
</div>

開發者快速看程式碼的同時，是不是很容易忽略掉 `someImportantCode` 函示？

### 過時 Out of date

註解的程式碼時間一久，跟目前已經脫離的一段時間，根本就不適合放在專案內了，都已經在使用 git 版本控制了，為什麼不好好利用 Git 的優點，而是透過註解程式碼來記錄過去的程式呢？請注意，在團隊合作時，寫註解是給其他團員看，而不是給自己看。寫程式的同時，也請寫好完整文件。

### 結論

註解程式碼的缺點遠大於優點，實在看不出來有什麼理由需要將註解程式碼留下，為了避免此，可以透過一些工具，像是 [eslint-rules][2] 內的 [no-commented-out-code][3] 規則，團隊合作最終極目標就是，團隊專案給其他人 Review 的時候，別人會說這專案是一個人寫的嗎？這樣就成功了 ^__^

 [1]: https://medium.com/@kentcdodds/please-don-t-commit-commented-out-code-53d0b5b26d5f
 [2]: https://github.com/bahmutov/eslint-rules
 [3]: https://github.com/bahmutov/eslint-rules#no-commented-out-code