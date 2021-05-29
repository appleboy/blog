---
title: 在 Windows 底下安裝 Compass CSS Authoring Framework
author: appleboy
type: post
date: 2011-10-05T04:10:14+00:00
url: /2011/10/install-compass-css-authoring-framework-on-windows/
dsq_thread_id:
  - 434463302
categories:
  - Compass CSS Framework
tags:
  - Compass
  - CSS
  - SASS

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6213260474/" title="Compass Home   Compass Documentation by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6217/6213260474_e0e51eeefe_o.png?resize=486%2C110&#038;ssl=1" alt="Compass Home   Compass Documentation" data-recalc-dims="1" /></a>
</div>

<a href="http://compass-style.org/" target="_blank">Compass</a> 是一套 base on <a href="http://sass-lang.com/" target="_blank">Sass Language</a> 的一套 CSS Framework，它提供了豐富的 CSS3 原件，讓您可以加速開發 CSS，也繼承 Sass Language 的開發方式，支援 variables, mixins, selector inheritance…等，今天就來介紹如何在 Windows 底下快速安裝開發環境。如果想更瞭解 Sass 可以參考之前的文章: [加速開發 CSS 工具: Sass][1]。 

### 安裝步驟 (Install Compass) 在安裝 Compass 之前，您必須要先安裝 

[Ruby][2] 開發環境，在 Ubuntu 或 Debian 底下可以透過 apt 的方式安裝: 

<pre class="brush: bash; title: ; notranslate" title="">$ sudo apt-get install ruby1.9.1-full</pre> 如果你想裝 ruby 1.8 可以透過底下: 

<pre class="brush: bash; title: ; notranslate" title="">$ sudo apt-get install ruby-full</pre>

<!--more-->

### 在 Windows 底下安裝 Ruby 其實在 

<a href="http://www.ruby-lang.org/zh_TW/downloads/" target="_blank">Ruby 下載官網</a>有製作好懶人包了，我們只要下載 <a href="http://rubyinstaller.org/" target="_blank">RubyInstaller</a> 網站別人包好的執行檔即可。首先到 <a href="http://rubyinstaller.org/downloads/" target="_blank">RubyInstaller Download Page</a> 選擇 <a href="http://rubyforge.org/frs/download.php/75127/rubyinstaller-1.9.2-p290.exe" target="_blank">Ruby 1.9.2-p290</a>，下載之後直接執行，然後很簡單直接下一步按到最後，整個 Ruby 環境就建立好了。 

### 透過 Ruby gem 安裝 Compass 安裝好上述執行檔，你會發現在 C 槽多了 

<span style="color:green"><strong>C:\Ruby192</strong></span>，接著我們按<span style="color:red"><strong>開始->執行->打入 cmd->Enter</strong></span>，會跳出一個命令列視窗，接著我們利用底下步驟來安裝 compass: 

<pre class="brush: bash; title: ; notranslate" title=""># 切換到 ruby 執行目錄
cd c:\\ruby192\bin
# 先更新 gem (類似 apt-get update)
gem update --system
# 安裝 compass 套件
gem install compass</pre> 這樣直接在原來目錄下底下指令: 

<span style="color:green"><strong>compass -h</strong></span> 就可以看到底下畫面，這樣 Windows 底下大致完成了 [<img src="https://i1.wp.com/farm7.static.flickr.com/6152/6213395364_dd7dca76ac.jpg?resize=500%2C454&#038;ssl=1" alt="compass_windows" data-recalc-dims="1" />][3] 大家一定會覺得每次都要切換到 <span style="color:green"><strong>C:\Ruby192</strong></span> 才可以執行 compass，大家可以把 <span style="color:green"><strong>C:\Ruby192</strong></span> 加入到個人 PATH 裡面，只要到環境變數里面設定即可，請參考下圖 [<img src="https://i2.wp.com/farm7.static.flickr.com/6164/6212890243_45195f02e4.jpg?resize=500%2C288&#038;ssl=1" alt="compass_windows2" data-recalc-dims="1" />][4]

 [1]: http://blog.wu-boy.com/2011/05/%E5%8A%A0%E9%80%9F%E9%96%8B%E7%99%BC-css-%E5%B7%A5%E5%85%B7-sass/
 [2]: http://www.ruby-lang.org/zh_TW/
 [3]: https://www.flickr.com/photos/appleboy/6213395364/ "compass_windows by appleboy46, on Flickr"
 [4]: https://www.flickr.com/photos/appleboy/6212890243/ "compass_windows2 by appleboy46, on Flickr"