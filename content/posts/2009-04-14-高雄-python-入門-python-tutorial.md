---
title: '[高雄] Python 入門 – Python tutorial'
author: appleboy
type: post
date: 2009-04-14T14:46:39+00:00
url: /2009/04/高雄-python-入門-python-tutorial/
views:
  - 11733
bot_views:
  - 616
dsq_thread_id:
  - 246847356
categories:
  - Python
tags:
  - Python

---
在現今 [Google][1] 的大多數服務都是利用 [Python][2] 程式撰寫，例如：[Google App Engine][3]，之前買下的 Youtube 影音網站，就是因為 Youtube 是用 Python 的程式撰寫起來的一個 Web 2.0 網站，在上禮拜去參加了 [工作坊][4] 所開的一門入門的課程 [Python 入門 - Python tutorial - 第一梯 (講者：黃宇新)][5]，這課程是給要學習 Python 的基本入門，講師 黃宇新 教的真的很棒，把 Python 的精神都講的非常好，自己感覺跟 Perl 的功能差沒多少，可是兩種語言在比較方面各有優缺點，聽完最大的感想歸納為兩點，那就是 <span style="color: #ff0000;">Python 產生線上文件相當方</span>便，還有非常的<span style="color: #ff0000;">快速模組化</span>，每個 Python 程式都是一個獨立模組，在其他 Python 程式裡面都以利用 import 方式來交互使用，個人認為在 系統管理、網路管理、網路傳輸程式、網頁程式開發 上面會有相當大的幫助。 Python 還有一個優點就是程式可閱讀性，在每個程式都必須有良好的撰寫習慣，那就是要善用 tab 鍵來排版，不然程式就是會錯誤，底下一個 Python 的例子，九九乘法表： 

<pre class="brush: python; title: ; notranslate" title="">#!/usr/local/bin/python
for i in range(1,10):
  for j in range(1,10):
    print "%d*%d=%s" % (i,j,i*j),
  print ""</pre>

<!--more--> 程式的可閱讀性，可以讓程式設計師依照這個規範來撰寫程式，將來程式控管，或者是交接給其他人，那一定相當方便，至少不會在找 if for 這些迴圈的括號，產生困擾。 程式說明撰寫：這部份我覺得 Python 做的非常好，比如說一個 Python 定義了幾個 function，那只要在程式的特定地方寫上註解，就可以利用 help 下去查了喔，請看底下例子： #!/usr/local/bin/python def fib(n): "Print a Fibonacci series up to n" a, b = 0, 1 while b < n: print b, a, b = b, a+b def test(n): "for range print" for i in range(1,n): print i def module_99(n): "9\*9" for i in range(1,10): for j in range(1,n): print "%d\*%d=%s" % (i,j,i*j), print "" def fib2(n): # return Fibonacci series up to n "Return a list containing the Fibonacci series up to n" result = [] a, b = 0, 1 while b < n: result.append(b) # see below a, b = b, a+b return result[/code] 上面看到 "註解" 這部份，就是可以利用 Python 的 command line help 指令可以查詢說明，撰寫說明很快，很方便，寫出來跟 man 差不多 

[<img src="https://i0.wp.com/farm4.static.flickr.com/3356/3441952396_287e9cafb8.jpg?resize=500%2C390&#038;ssl=1" title="Python (by appleboy46)" alt="Python (by appleboy46)" data-recalc-dims="1" />][6] [<img src="https://i1.wp.com/farm4.static.flickr.com/3638/3441282041_086e611dc8.jpg?resize=479%2C500&#038;ssl=1" title="Python2 (by appleboy46)" alt="Python2 (by appleboy46)" data-recalc-dims="1" />][7] PS: 如果要有中文註解請參考這篇：<http://www.python.org/dev/peps/pep-0263/>

 [1]: http://www.google.com
 [2]: http://www.python.org/
 [3]: http://code.google.com/intl/zh-TW/appengine/
 [4]: http://whoswho.openfoundry.org/
 [5]: http://whoswho.openfoundry.org/workshop/details/18.html
 [6]: https://www.flickr.com/photos/appleboy/3441952396/ "Python (by appleboy46)"
 [7]: https://www.flickr.com/photos/appleboy/3441282041/ "Python2 (by appleboy46)"