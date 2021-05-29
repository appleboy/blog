---
title: Drone.io 搭配 Ruby 環境測試
author: appleboy
type: post
date: 2013-10-17T02:54:54+00:00
url: /2013/10/drone-io-with-runy-compass-setup/
dsq_thread_id:
  - 1866073881
categories:
  - Git
  - javascript
  - NodeJS
tags:
  - Bitbucket
  - Codeship
  - CoffeeScript
  - Compass
  - Deploy
  - Drone.io
  - git
  - Github
  - GruntJS
  - Handlebars
  - Heroku

---
相信現在 <a href="http://git-scm.com/" target="_blank">Git</a> 已經是大家共通的版本控制工具，每當專案有新的 commit，我們可以透過 <a href="https://travis-ci.org/" target="_blank">Travis</a> 來幫忙做測試，但是 Travis 真的只有支援測試而已，如果測試成功想要進一步 Deploy 到任何機器或者是繼續做任何動作，這些都不支援的，那國外有些 Service 可以整合 <a href="https://github.com/" target="_blank">Github</a> 或 <a href="https://bitbucket.org/" target="_blank">Bitbucket</a> Project 幫忙做到自動測試及 Deploy，比較常見的就是 <a href="https://www.codeship.io" target="_blank">Codeship</a>，這服務非常強大，整合了 <a href="https://www.heroku.com/" target="_blank">Heroku</a>，<a href="https://appengine.google.com/" target="_blank">App Engine</a>，<a href="https://www.nodejitsu.com/" target="_blank">Nodejitsu</a> .. 等服務，Deploy 也支援 <a href="https://github.com/fabric/fabric" target="_blank">Fabric</a>, <a href="http://puppetlabs.com/" target="_blank">Puppet</a>, Shell script 等等，這家的收費是看每個月做了多少次編譯測試動作，最便宜的方案每個月 $9 美金，只能編譯 50 次。 <!--more--> 這時候就要找看看有沒有窮人編譯 + Deploy 的服務，看到網路上也有人推薦 

<a href="https://drone.io/" target="_blank">Drone.io</a> 服務，雖然沒有像 Codeship 支援這麼強大，但是最基本的功能還是有啦，最主要免費專案是 **<span style="color:green">Unlimited Builds</span>**，看到這個就超爽了，主要收費來源就是看你的專案是不是 Private，如果都是開放原始碼，就可以持續使用免費服務，此網站一樣支援 Github 或 Bitbucket 專案導入，另外也支援 SSH Deploy，Heroku，AppEngine 等。

Drone.io Ruby 編譯環境是透過 <a href="https://github.com/sstephenson/rbenv" target="_blank">rbenv</a> 來管理，如果安裝了任何 Ruby 工具，像是 Compass 等，要使用 Compass command 就必須加上底下指令

<pre class="brush: bash; title: ; notranslate" title="">$ gem install compass
$ rbenv rehash</pre>

其實這還蠻不方便的，因為同樣的測試環境，在 Travis 是可以編譯成功的，由於現在專案內會用到大量工具，像是 <a href="http://coffeescript.org/" target="_blank">CoffeeScript</a>，<a href="http://compass-style.org/" target="_blank">Compass</a>，<a href="http://handlebarsjs.com/" target="_blank">Handlebars</a> 等，所以這些工具產生的 js, css, *.handlebars 檔案，都不應該放到專案裡面，而是在開發專案的時候，自動幫忙產生，可以透過 <a href="http://gruntjs.com/" target="_blank">GruntJS</a> 工具來整合。整合方式可以參考 <a href="http://blog.wu-boy.com/2013/05/2013-javascript-conference-front-tool-grunt-js/" target="_blank">2013 Javascript Conference: 你不可不知的前端開發工具</a>

可以參考<a href="https://drone.io/github.com/appleboy/html5-template-engine/15" target="_blank">編譯的過程</a>，如果編譯過程有點多，會造成 Browser 有點小當，所以建議還是關掉，等跑完，不管成功或失敗，都是寄信通知，如果成功就會繼續跑 Deploy 流程。