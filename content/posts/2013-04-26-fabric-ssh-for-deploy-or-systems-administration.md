---
title: Fabric 管理多台 Linux 機器的 command tool
author: appleboy
type: post
date: 2013-04-25T16:35:37+00:00
url: /2013/04/fabric-ssh-for-deploy-or-systems-administration/
dsq_thread_id:
  - 1235340296
categories:
  - Linux
  - Python
tags:
  - capistrano
  - Fabric
  - Python
  - Ruby

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8679381967/" title="python-logo-master-v3-TM by appleboy46, on Flickr"><img src="https://i0.wp.com/farm9.staticflickr.com/8123/8679381967_75cee4e0e9_n.jpg?resize=320%2C108&#038;ssl=1" alt="python-logo-master-v3-TM" data-recalc-dims="1" /></a>
</div> 相信 Administrator 管理過兩台以上的 Linux Server 都一定會找 tool 讓多台機器同時執行指令，這也應用在 Deploy 任何 application 到多台機器或者是同時更新系統套件…等，網路上有蠻多套 command line tool 像是 

<a href="https://github.com/capistrano/capistrano" target="_blank">capistrano</a>、<a href="http://docs.fabfile.org" target="_blank">Fabric</a>、<a href="http://code.google.com/p/parallel-ssh/" target="_blank">pssh</a>、<a href="http://packages.debian.org/search?keywords=dsh" target="_blank">dsh</a>…等都，本篇會以 <a href="http://www.python.org/" target="_blank">Python</a> 所推的 Fabric 來做介紹。另外 Ruby 所寫的 capistrano tool 也是不錯的選擇，這兩套其實大同小異，可以將 Deploy 的邏輯寫成單一 file 再透過 task 定義來決定執行的工作。當然你也可以透過此 tool 來管理 local 端動作，但是這有點多此一舉，因為基本的 Shell 就可以完成了，如果熟悉 Python 則選 fabric，如果喜歡寫 <a href="http://www.ruby-lang.org/en/" target="_blank">Ruby</a> 則可以試試看 capistrano。 

### 安裝方式(Installation) 如果是 

<a href="http://www.centos.org/" target="_blank">CentOS</a> 系列可以透過 yum 套件管理，<a href="http://www.ubuntu.com/" target="_blank">Ubuntu</a> 或 <a href="http://www.debian.org/" target="_blank">Debian</a> 則是透過 aptitude 方式安裝。 Yum 

<pre class="brush: bash; title: ; notranslate" title=""># install python pip tool and fabric command
yum -y install python-pip
pip-python install fabric</pre> APT 

<pre class="brush: bash; title: ; notranslate" title=""># install python easy_install
aptitude -y install python-pip
# install fabric command
pip install fabric</pre> 安裝 capistrano 可以透過 Ruby gem。 

<pre class="brush: bash; title: ; notranslate" title="">$ gem install capistrano</pre>

<!--more-->

### 基本介紹 Fabric 可以透過 command line 或者是讀取 

<span style="color:green"><strong>fabfile.py</strong></span> 檔案方式來執行，fabfile.py 務必放在執行 fab command 的目錄底下，也就是的命令列所在位置 。假設目前在 /home/appleboy 目錄下，就必須將 fabfile.py 存放在 /home/appleboy。 簡易設定 /home/appleboy/fabfile.py，內容 

<pre class="brush: python; title: ; notranslate" title="">def hello():
    print("Hello world!")</pre> 該目錄底下執行 

<pre class="brush: bash; title: ; notranslate" title="">$ fab hello
Hello world!

Done.
</pre> 如果不透過 fabfile.py 檔案的話，你直接打 fab 會得到 Couldn't find any fabfiles!，看到這訊息沒關係，一樣可以用指令方式來達成上面的結果。學習 fabric 前，有一個很必要的條件，就是必需熟悉 Linux command 及 Shell script 用法，個人推薦

<a href="http://linux.vbird.org/" target="_blank">鳥哥的網站</a>，把基礎文件都看過後，就沒有任何 Linux 系統可以難倒你。如何用 fab command 直接得到上述的結果呢？ 

<pre class="brush: bash; title: ; notranslate" title="">$ fab -p xxxx -H localhost -- 'echo "Hello world!";'</pre> 上述指令會產生下面結果 

<pre class="brush: bash; title: ; notranslate" title="">[localhost] Executing task '&lt;remainder>'
[localhost] run: echo "Hello world!";
[localhost] out: Hello world!
[localhost] out: 
Done.
Disconnecting from localhost... done.</pre> 執行 fab 就像是透過 ssh 登入機器，需要帳號及密碼，執行當下就必須提供使用者帳號及密碼，如果沒給參數，預設就是執行該 command 的使用者，-p 則是給密碼，這樣就不會詢問密碼了，-H 是指定要對哪個 host 執行該命令，也許同時 3 台機器，-H 請改寫成 -H web1,web2,web3。要換其他使用者直接加上 -u 參數 

<pre class="brush: bash; title: ; notranslate" title="">$ fab -u deploy -p xxxx -H localhost -- 'echo "Hello world!";'</pre> 接下來聊聊該如何寫 fabfile.py，fab 有分 local 端或 Host 端執行，如果只用在 local 端就跟寫 Shell script 沒啥不同，fabric 提供了 local function 執行 local command。對於專案而言，你可以建立 fabfile.py 設定檔，裡面寫入 

<pre class="brush: python; title: ; notranslate" title="">from fabric.api import local

def prepare_deploy():
    local("git add -p && git commit")
    local("git push")</pre> 執行 fab prepare_deploy 會將專案已修改的 commit 到 server，當然你也可以拆開來執行 

<pre class="brush: python; title: ; notranslate" title="">from fabric.api import local

def clone():
    local("git clone git@github.com:appleboy/minify-tool.git")

def commit():
    local("git add -p && git commit")

def push():
    local("git push")

def prepare_deploy():
    commit()
    push()</pre> 大家可以依照專案需求來定義工作項目，好讓團隊所有的成員都可以使用。 

### 錯誤處理 看到上面例子，可以知道透過 fab clone 來初始化專案，執行後，發現多了 minify-tool 目錄，但是再執行同樣指令一次呢？會發現出現底下錯誤訊息 

<pre class="brush: bash; title: ; notranslate" title="">[localhost] local: git clone git@github.com:appleboy/minify-tool.git
fatal: destination path 'minify-tool' already exists and is not an empty directory.

Fatal error: local() encountered an error (return code 128) while executing 'git clone git@github.com:appleboy/minify-tool.git'

Aborting.</pre> 程式就停止了，但是如果底下有必須執行的工作，該怎麼辦，必須要 import with_statement 模組，將程式碼改成底下 

<pre class="brush: python; title: ; notranslate" title="">from __future__ import with_statement
from fabric.api import local, settings, abort
from fabric.contrib.console import confirm

def clone():
    with settings(warn_only=True):
        result = local("git clone git@github.com:appleboy/minify-tool.git")
    if result.failed and not confirm("Tests failed. Continue anyway?"):
        abort("Aborting at user request.")</pre> 會發現畫面還是會出現錯誤訊息，最後跳出 confirm 視窗鍵入 Y，結果會得到 Done!，鍵入 N 則得到 Aborting 訊息。 

<pre class="brush: bash; title: ; notranslate" title="">[localhost] local: git clone git@github.com:appleboy/minify-tool.git
fatal: destination path 'minify-tool' already exists and is not an empty directory.

Warning: local() encountered an error (return code 128) while executing 'git clone git@github.com:appleboy/minify-tool.git'

Tests failed. Continue anyway? [Y/n] y

Done.</pre> 接著來定義 deploy 工作內容 

<pre class="brush: python; title: ; notranslate" title="">def deploy():
    code_dir = 'minify-tool'
    with cd(code_dir):
        run("git pull")</pre> 上面多了二個函式，就是 cd 和 run，cd 很直覺，就跟 Linux command 一樣，run 跟 local 不同的地方就是 run 是用來管理遠端機器。 

### 定義 Host 最前面有提到可以用 -H 方式定義，那也可以直些寫在 fabfile.py 設定檔 

<pre class="brush: python; title: ; notranslate" title="">env.hosts = ['127.0.0.1']
env.hosts = ['localhost']
env.hosts = ['web1']</pre> 上面寫法都正確，host name 可以直接在 /etc/hosts 檔案內定義，將程式碼改為底下 

<pre class="brush: python; title: ; notranslate" title="">env.hosts = ['my_server']

def deploy():
    code_dir = 'minify-tool'
    with settings(warn_only=True):
        if run("test -d %s" % code_dir).failed:
            run("git clone git@github.com:appleboy/minify-tool.git %s" % code_dir)
    with cd(code_dir):
        run("git pull")</pre> 如果沒有定義 env.hosts，你也可以執行 

<pre class="brush: bash; title: ; notranslate" title="">$ fab -H web1 deploy</pre> 這次先介紹到這裡，或許之後有機會來介紹進階用法，當然可以先參考看看 

<a href="http://docs.fabfile.org" target="_blank">fabric document</a>。