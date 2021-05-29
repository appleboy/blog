---
title: Ruby Compass and Sass Auto Testing Environment
author: appleboy
type: post
date: 2014-03-11T02:37:51+00:00
url: /2014/03/ruby-compass-and-sass-auto-testing-environment/
dsq_thread_id:
  - 2405100944
categories:
  - Compass CSS Framework
  - CSS
  - Testing
tags:
  - Codeship
  - Compass
  - gulp
  - Gulp-compass
  - Jenkins
  - Ruby
  - RubyGems
  - SASS
  - Travis CI

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6213260474/" title="Compass Home   Compass Documentation by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6217/6213260474_e0e51eeefe_o.png?resize=486%2C110&#038;ssl=1" alt="Compass Home   Compass Documentation" data-recalc-dims="1" /></a>
</div>

[Compass][1] 是一套 CSS Authoring Framework，也是基於 [Sass][2] 語法的一套 Framework，先前寫了 [Gulp][3] 的 [Compass Plugin][4]，在針對自動化測試時候出現版本相依性不同，造成無法自動測試成功。自動化測試目前跟 [Github][5] 最常搭配的就是 [Travis CI][6] 或者是 [Codeship][7]，當然如果非 Open source 專案可能就要自己架設 [CI][8] 伺服器，個人推薦就是 [Jenkins][9]。這次遇到的問題其實跟 Ruby Gem 版本相依性有關，由於要測試 Compass 所有 Command 語法，所以使用了 [Susy][10] + sass + compass，如果在 `.travis.yml` 內直接寫

<!--more-->

<div>
  <pre class="brush: bash; title: ; notranslate" title="">language: node_js
node_js:
    - "0.10"
before_install:
    - gem update --system
    - gem install sass
    - gem install compass
    - gem install susy
    - gem install modular-scale</pre>
</div>

這樣編譯出來的結果會噴底下錯誤訊息

> /home/rof/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/site\_ruby/1.9.1/rubygems/core\_ext/kernel\_require.rb:55:in \`require': cannot load such file -- sass/script/node (LoadError) from /home/rof/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/site\_ruby/1.9.1/rubygems/core\_ext/kernel\_require.rb:55:in \`require' from /home/rof/.rvm/gems/ruby-1.9.3-p327/gems/compass-0.12.2/lib/compass/sass\_extensions/monkey\_patches/browser_support.rb:1:in \`<top (required)>' from /home/rof/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/site\_ruby/1.9.1/rubygems/core\_ext/kernel_require.rb:55:in \`require'
會造成這樣的原因就是目前 sass、compass、susy 都不能安裝最新版本。Compass 目前版本是 0.12.3 只有支援 Sass 3.2.14 版本，但是 Sass 前幾天剛推出 3.3.1 版本，另外 Susy 也是一樣問題，由於 Susy 推出 2.0.0 版本需要 Sass 3.3.0 版本以上才可以使用，所以針對 Compass 變成只能指定版本測試，否則會得到上述錯誤訊息，請將 `.travis.yml` 修正為

<div>
  <pre class="brush: bash; title: ; notranslate" title="">language: node_js
node_js:
    - "0.10"
before_install:
    - gem update --system
    - gem install sass --version 3.2.14
    - gem install compass --version 0.12.3
    - gem install susy --version 1.0.9
    - gem install modular-scale</pre>
</div>

這樣就可以正常跑出測試結果。

 [1]: http://compass-style.org/
 [2]: http://sass-lang.com/
 [3]: http://gulpjs.com/
 [4]: https://github.com/appleboy/gulp-compass
 [5]: http://github.com
 [6]: https://travis-ci.org/
 [7]: https://www.codeship.io/
 [8]: http://en.wikipedia.org/wiki/Continuous_integration
 [9]: http://jenkins-ci.org/
 [10]: http://susy.oddbird.net/