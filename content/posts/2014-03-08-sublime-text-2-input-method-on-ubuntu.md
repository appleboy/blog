---
title: Sublime Text 2 在 Ubuntu 中文輸入問題
author: appleboy
type: post
date: 2014-03-08T12:00:55+00:00
url: /2014/03/sublime-text-2-input-method-on-ubuntu/
dsq_thread_id:
  - 2387682926
categories:
  - Linux
  - Ubuntu
tags:
  - Sublime Text
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/13007892705/" title="Sublime_Text_Logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm8.staticflickr.com/7458/13007892705_062066d2ab_m.jpg?resize=240%2C240&#038;ssl=1" alt="Sublime_Text_Logo" data-recalc-dims="1" /></a>
</div>

[Sublime Text][1] 是一個非常好用的文字編輯器，如果不喜歡 [Vim][2] Console 介面，我強烈推薦這套，因為可以透過 [Package Control][3] 安裝實用的 Plugin。安裝好 Sublime Text 軟體後，發現切換輸入法跟 Sublime 預設的快捷鍵衝突，所以將 [gcin][4] 切換的快捷鍵也換掉，但是似乎沒有作用，網路上找到此篇解法 [Sublime Text 2 如何在 Ubuntu+iBus 下输入中文？][5]，解法就是安裝 [InputHelper Plugin][6] 當然這方法是治標不治本，但是至少解決無法輸入中文的問題，底下是安裝方式

<!--more-->

### 安裝方式

首先要先安裝 `Package Control`，兩種方式安裝，可以用 `ctrl + ~` 或是透過 `View > Show Console` 選單打開 Console，將底下程式碼貼入並且按下 Enter

<div>
  <pre class="brush: bash; title: ; notranslate" title="">import urllib2,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404' + 'e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler()) ); by = urllib2.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); open( os.path.join( ipp, pf), 'wb' ).write(by) if dh == h else None; print('Error validating download (got %s instead of %s), please try manual install' % (dh, h) if dh != h else 'Please restart Sublime Text to finish installation')</pre>
</div>

最後在 Preference 找到 Package Control 選擇 Install Package，輸入 `InputHelper` 這樣就安裝完成，使用方式很容易，`Ctrl + Shift + z` 可以叫出 Input 視窗就可以輸入中文了。

 [1]: http://www.sublimetext.com/
 [2]: http://www.vim.org/
 [3]: https://sublime.wbond.net/
 [4]: http://zh.wikipedia.org/wiki/Gcin
 [5]: http://www.zhihu.com/question/20163104
 [6]: https://sublime.wbond.net/packages/InputHelper