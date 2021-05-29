---
title: Using Capistrano to deploy current branch
author: appleboy
type: post
date: 2014-03-19T03:14:29+00:00
url: /2014/03/using-capistrano-to-deploy-current-branch/
dsq_thread_id:
  - 2459187100
categories:
  - Ruby on Rails
tags:
  - capistrano
  - Ruby
  - Ruby on Rails

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/13256445484/" title="CapistranoLogo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm4.staticflickr.com/3756/13256445484_d0ca222f48.jpg?resize=500%2C125&#038;ssl=1" alt="CapistranoLogo" data-recalc-dims="1" /></a>
</div>

[Capistrano][1] 是一套用 [Ruby][2] 語言所寫的 Deploy Tool，可以用來管理多台伺服器自動化流程，在 [Rails][3] 專案內都會使用這套 Deploy Tool，也方便管理遠端機器。這次有個問題是，假設我們在 Staging 或 Production 設定檔分別定義了 `:branch` 變數如下

<div>
  <pre class="brush: ruby; title: ; notranslate" title="">set :branch, "master"
set :env, "production"</pre>
</div>

<!--more-->

這時候可以透過底下指令來 Deploy 到遠端伺服器

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ bundle exec cap production deploy</pre>
</div>

假設這次想要 deploy 不同 branch 到 Production Server，就必須修改 `production.rb` 設定檔，每次不同 branch 就要改一次，會比較麻煩，要解決此問題只需要將上述程式碼改成可以用 command line 方式管理

<div>
  <pre class="brush: ruby; title: ; notranslate" title="">set :branch, fetch(:branch, "master")
set :env, fetch(:env, "production")</pre>
</div>

將指令換成

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ bundle exec cap -S branch="my-branch" production deploy</pre>
</div>

也就可以達成目的了。多人同時在開發專案時，一定會有很多 feature 或 issue branch，開發者會希望目前在哪個 Branch，程式碼 commit 後，就直接用 `cap deploy`，將現在的 Branch 程式碼 Deploy 到伺服器，方便其他人測試，要達成此功能，請修改 `deploy.rb` 加入底下程式碼

<div>
  <pre class="brush: ruby; title: ; notranslate" title=""># Figure out the name of the current local branch
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  branch
end

# Set the deploy branch to the current branch
set :branch, fetch(:branch, current_git_branch)</pre>
</div>

完成後，請將 `config/deploy/*.rb` 內的 `set :branch` 全部拿掉，這樣切到任何 Branch，就直接下 `cap deploy` 即可，，當然也可以透過 command line 方式指定 Branch 來 Deploy。最後附上 Capistrano 的目錄架構圖

<div>
  <pre class="brush: bash; title: ; notranslate" title="">├── Capfile
├── config
│   ├── deploy
│   │   ├── production.rb
│   │   └── staging.rb
│   └── deploy.rb
└── lib
    └── capistrano
            └── tasks</pre>
</div>

參考文章:

  * [Capistrano Deployment From Specific Git Branch][4]
  * [Deploying from your current branch with Capistrano][5]
  * [Using capistrano to deploy from different git branches][6]

 [1]: http://capistranorb.com/
 [2]: https://www.ruby-lang.org/en/
 [3]: http://rubyonrails.org/
 [4]: http://wintersolutions.de/de/blog/capistrano-deployment-from-specific-git-branch
 [5]: http://www.codeography.com/2010/12/09/deploying-from-your-current-branch-with-capistrano.html
 [6]: http://stackoverflow.com/questions/1524204/using-capistrano-to-deploy-from-different-git-branches