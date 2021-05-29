---
title: Git 版本控制：利用 git reset 恢復檔案、暫存狀態、commit 訊息
author: appleboy
type: post
date: 2010-08-20T12:15:50+00:00
url: /2010/08/git-版本控制：利用-git-reset-恢復檔案、暫存狀態、commit-訊息/
views:
  - 6178
bot_views:
  - 366
dsq_thread_id:
  - 246690275
categories:
  - Git
tags:
  - git
  - 版本控制

---
這次來介紹一下 [git][1] reset 的用法，為什麼會介紹這指令呢？因為今天想要看專案狀態，用 git status 觀看，發現被我玩爛了，所以出現了底下錯誤訊息： 

<pre class="brush: bash; title: ; notranslate" title="">$ git status
error: bad index file sha1 signature
fatal: index file corrupt</pre> 解決此問題非常簡單，要先刪除 index 檔案，請先砍掉 

<span style="color:green"><strong>.git/index</strong></span>，恢復此 index 請用 

<pre class="brush: bash; title: ; notranslate" title="">git reset</pre> 這行指令相當於 

<span style="color:red"><strong>git reset --mixed HEAD</strong></span>，或者是可以用 <span style="color:red"><strong>git read-tree</strong></span> 來取代 git reset，當然 git reset 不只是有這功能而已，假如您已經建立了 commit 訊息，也可以將此訊息拿掉，重新在 commit，或者是您修改過的檔案在暫存區，git 也可以幫您恢復到未暫存，或者是不想要這次的修改，也可以恢復到未修改的檔案喔。 

### 取消已經暫存的檔案 假如我們有兩個檔案需要 commit，但是不小心按到 git add * 全部加入到暫存區，那該怎麼恢復呢？ 

<pre class="brush: bash; title: ; notranslate" title=""># On branch master
# Changes to be committed:
#   (use "git reset HEAD &lt;file>..." to unstage)
#
#       modified:   Makefile
#       modified:   user/easy_setup/easysetup.h
#</pre> 上面是以經在暫存區裡面等待被 commit 檔案(

<span style="color:green">Changes to be committed</span>)，大家可以看到括號裡面有提示如何拿掉 (use "git reset HEAD <file>..." to unstage)，所以我們下： 

<pre class="brush: bash; title: ; notranslate" title="">git reset HEAD user/easy_setup/easysetup.h</pre> 之後會看到 『

<span style="color:red">user/easy_setup/easysetup.h: locally modified</span>』此訊息，這時候在用 git status 看狀態 

<pre class="brush: bash; title: ; notranslate" title=""># On branch master
# Changes to be committed:
#   (use "git reset HEAD &lt;file>..." to unstage)
#
#       modified:   Makefile
#
# Changed but not updated:
#   (use "git add &lt;file>..." to update what will be committed)
#
#       modified:   user/easy_setup/easysetup.h
#</pre>

<!--more-->

### 取消對檔案的修改 如果剛剛針對 Makefile 的修改覺得不需要，該如何取消修改，以及恢復檔案狀態呢？尚未恢復之前的狀態如下： 

<pre class="brush: bash; title: ; notranslate" title=""># On branch master
# Changed but not updated:
#   (use "git add &lt;file>..." to update what will be committed)
#
#       modified:   Makefile
#</pre> 然後恢復檔案指令： 

<pre class="brush: bash; title: ; notranslate" title="">git checkout -- Makefile</pre> 接下來用 git status 看看狀態： 

<pre class="brush: bash; title: ; notranslate" title=""># On branch master
nothing to commit (working directory clean)</pre> 可以看到，該檔案已經恢復到修改前的版本。請

**注意**：這指令有些危險，針對該檔案的修改都沒有了，因為我們剛剛把之前版本的檔案複製過來覆蓋了此檔案。所以在用這指令前，請務必確定真的不再需要剛剛的修改。 

### 恢復 Commit，重新提交 Commit 假如今天您修改了兩個檔案，並且新增到暫存區了，狀態如下： 

<pre class="brush: bash; title: ; notranslate" title=""># On branch master
# Changes to be committed:
#   (use "git reset HEAD &lt;file>..." to unstage)
#
#       modified:   Makefile
#       modified:   user/easy_setup/easysetup.h
#
</pre> 並且已經執行了 

<span style="color:green">git commit -m "first commit"</span>，發現訊息寫錯想要修改，可以透過 reset 方式來做，請先用 <span style="color:green"><strong>git log</strong></span> 方式查看訊息 

<pre class="brush: bash; title: ; notranslate" title="">git log --stat</pre>

<pre class="brush: bash; title: ; notranslate" title="">commit c13eb41110a38ef7145bb8815560641697800659
Author: appleboy &lt;appleboy.tw at gmail.com>
Date:   Fri Aug 20 20:02:55 2010 +0800

    first commit

 Makefile                    |   10 ++-
 user/easy_setup/easysetup.h |  157 ++++++++++++++++++++-----------------------
 2 files changed, 79 insertions(+), 88 deletions(-)</pre> 這要怎麼解決才可以改變此訊息呢？ 

<pre class="brush: bash; title: ; notranslate" title="">git reset --soft HEAD^</pre> 這是一個大家常用的作法，假如您想要修改 commit 訊息，或者是尚未修改好檔案，下完此指令，您會發現 reset 會幫忙把舊的 head 複製到 

<span style="color:green"><strong>.git/ORIG_HEAD</strong></span>，如果您沒有想要重新建立 commit 訊息，您可以下 

<pre class="brush: bash; title: ; notranslate" title="">git commit -a -c ORIG_HEAD</pre> git 會跳出剛剛的 

<span style="color:red">first commit</span> 讓您來修改，或者是自己用 git commit -m "XXXXXXX" 這樣也可以喔。 

### 強制恢復到上一版本 上面是介紹恢復 commit 訊息，之前修改過的檔案還會存在，底下會使用 reset hard 的方式恢復到上一版本，上一版本跟此版本之間所修改的檔案，將不會存檔，git reset 參數之一 

<span style="color:green"><strong>--hard</strong></span> 

<pre class="brush: bash; title: ; notranslate" title="">git reset --hard HEAD~3</pre> 這指令意思是說，最後三個版本 (HEAD, HEAD^, and HEAD~2) 都不是您想要修改的，你也不想給其他人看見這三個版本資訊，如果您想要保存修改過的檔案，

**<span style="color:red">請勿下此指令</span>**，請用上面的方式去解決。這次先介紹到這裡，還有很多 reset 功能沒有講到，下次有機會在寫。

 [1]: http://git-scm.com/