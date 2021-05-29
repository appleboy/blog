---
title: '[Django] Web Framework- Django -初階學習心得'
author: appleboy
type: post
date: 2009-04-27T02:50:00+00:00
url: /2009/04/django-web-framework-django-初階學習心得/
views:
  - 17106
bot_views:
  - 574
dsq_thread_id:
  - 246829436
categories:
  - Python
tags:
  - Django
  - FreeBSD
  - Python

---
[<img title="django-logo-negative_1236046419 (by appleboy46)" src="https://i1.wp.com/farm4.static.flickr.com/3595/3475465970_7044242629.jpg?resize=198%2C90&#038;ssl=1" alt="django-logo-negative_1236046419 (by appleboy46)" data-recalc-dims="1" />][1] 首先感謝 [酷學園團隊][2]、[Who's Who 工作坊][3]、<a href="http://www.openfoundry.org" target="_blank">自由軟體鑄造場</a> 舉辦的一系列南部的 [python][4]、<a href="http://www.djangoproject.com/" target="_blank">Django</a> 活動，今天的活動主題是：[Web Framework- Django -初階 (講者：陳建玎)][5]，簡介了為什麼需要 MVC 架構寫法，MVC 的重要性，以及 Django 的優點，還蠻豐富的課程，其實重點都是在如何使用 MVC 加速開發 Web 網站，以及在 Team Work 裡的重要性，目前在開發 Web Framework 都是利用 PHP 一套 Frame Work：[Codeigniter][6]，在台灣已經有中文網站：[CodeIgniter 繁體中文][7]，自己接手了 CodeIgniter 計畫翻譯中文文件，還有開發 [forum 中文討論區][8]，還在規劃中，自己也才摸 CodeIgniter 一個多禮拜，底下有一張上課的投影片，介紹三種 Frame Work 的 Model、Views、Controller [<img title="django (by appleboy46)" src="https://i0.wp.com/farm4.static.flickr.com/3343/3474957475_2a379b69ff.jpg?resize=500%2C371&#038;ssl=1" alt="django (by appleboy46)" data-recalc-dims="1" />][9] <!--more-->

[<img title="django_01 (by appleboy46)" src="https://i1.wp.com/farm4.static.flickr.com/3597/3475934172_a7747dd79b.jpg?resize=500%2C296&#038;ssl=1" alt="django_01 (by appleboy46)" data-recalc-dims="1" />][10] 上面兩張投影片把 <a href="http://www.djangoproject.com/" target="_blank">Django</a> MVC 的精華都講出來了，Model 在 Frame Work 裡面就是跟 database 互相溝通，View 部份就是設計基本的 html 架構，把簡單的 while、for 的語法寫到 Template 裡面。使用者 Browser 對伺服器要求 Request，Django 就會針對 url 呼叫 urls.py，urls.py 裡面就寫著相對應的結構，如下： 

<pre class="brush: python; title: ; notranslate" title="">from django.conf.urls.defaults import *

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Example:
    # (r'^mysite/', include('mysite.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs'
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'^admin/(.*)', admin.site.root),
    # (r'^admin/', include('django.contrib.admin.urls')),
    (r'news/', 'mysite.hellowordapp.startpage'),
    (r'^$', 'mysite.hellowordapp.startpage'),
)</pre> urls.py 裡面會寫基本的 

<a href="http://en.wikipedia.org/wiki/Regular_expression" target="_blank">Regular Expression</a> 對應到 project 檔案，基本的 <a href="http://en.wikipedia.org/wiki/Regular_expression" target="_blank">Regular Expression</a> 要會一點，不管是哪一套 MVC，都需要用到 Regular Expression，在 [Codeigniter PHP Framework][6] 架構裡面對應的是 application/config/routes.php 的 <a href="http://codeigniter.com/user_guide/general/routing.html" target="_blank">URI Routing</a>，接下來就是 View(COntroller)，最後就是 model 呼叫了，其實最主要就是達到程式與樣板的分離，以及 database 跟 controller 的分開，對於程式人員跟美工人員相互合作，這個方式是最好的。 底下來快速介紹如何實作出線上新聞發佈系統，上課老師是把環境建立在 Windows 底下，不過我發現底下很多學員都是 run 在 Linux 底下，而我自己是弄在 FreeBSD 系統上面,其實做法都差不多，ubuntu 用 apt-get 方式，Fedora 是用 yum，FreeBSD 是用 ports 的方式，不管熟悉哪一種都可以輕鬆上手，run 在 Windows 上面也蠻方便的，一切都是看個人習慣了。 首先 FreeBSD ports 安裝: 課程上的很充實，需要投影片或者是範例的，都可以到 [Web Framework- Django -初階 (講者：陳建玎)][5] 上面觀看或者是下載,另外也有 [wiki][11]，大家上課的筆記都可以寫在上面喔。 

<pre class="brush: bash; title: ; notranslate" title="">#
# 目前版本 py25-django-1.0.2
# maintainer lwhsu@FreeBSD.org
cd /usr/ports/www/py-django
# make showconfig
make install clean</pre> FreeBSD 會依序幫您裝好相關套件，MySQL、SQLite3、POSTGRESQL、MOD\_PYTHON3(Install Apache2 with mod\_python3)，這些是 ports 的 config 選單是可以自由選擇。 接下來介紹快速使用 Django 開發一個新聞系統，介紹如何使用 Django 強大後台，上課過程老師是教大家先建立 model 再使用 manager syncdb tool 建立 database 資料表，那我來寫反向教學，先建立資料表，在利用 inspectdb tool 產生 model 資訊，自己通常都是用 MySQL 先建立好該有的資料表，這樣會比較方便。 1. 建立專案 

<pre class="brush: bash; title: ; notranslate" title="">#
# 在任何目錄底下都可以使用這個指令
django-admin.py startproject mysite</pre> 底下會出現幾個檔案：settings.py、urls.py、manage.py，大概介紹一下這三個檔案的用途，settings.py 用來設定系統參數，如：連接資料庫類型，帳號，密碼，urls.py 用來處理網址列導向，需要基本正規語言知識，manage.py 管理整個 Django 專案工具，可以鍵入 python manage.py help 來查看如何使用。 2. 建立 app # # 在 mysite(剛剛建立的專案)底下新增 app 名稱 python manage.py startapp news 3. 設定資料庫類型帳號密碼 

<pre class="brush: python; title: ; notranslate" title="">#
# 打開 settings.py
#
DATABASE_ENGINE = 'mysql'           # 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
DATABASE_NAME = 'django'             # Or path to database file if using sqlite3.
DATABASE_USER = 'django'             # Not used with sqlite3.
DATABASE_PASSWORD = 'xxxx'         # Not used with sqlite3.
DATABASE_HOST = ''             # Set to empty string for localhost. Not used with sqlite3.
DATABASE_PORT = ''             # Set to empty string for default. Not used with sqlite3.</pre> 4. 建立資料表 

<pre class="brush: sql; title: ; notranslate" title="">CREATE TABLE IF NOT EXISTS `project_news` (
  `news_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) NOT NULL,
  `group_id` mediumint(8) NOT NULL,
  `categories_id` int(4) NOT NULL,
  `news_name` varchar(255) NOT NULL,
  `news_desc` text NOT NULL,
  `news_top` tinyint(1) NOT NULL DEFAULT '0',
  `news_add_time` int(11) NOT NULL,
  `news_edit_time` int(11) NOT NULL,
  PRIMARY KEY (`news_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `project_news_categories` (
  `categories_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `categories_name` varchar(64) NOT NULL,
  `add_time` int(11) NOT NULL,
  `edit_time` int(11) NOT NULL,
  PRIMARY KEY (`categories_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;</pre> 5. 利用 Django tool 產生系統帳號認證相關資料表 

<pre class="brush: bash; title: ; notranslate" title="">#
# 會依照 settings.py 裡面的 INSTALLED_APPS 設定產生相關資料表喔
python manage.py syncdb</pre> 另外反向作法： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 可以產生全部在 database 裡面的 table 資料表，選取該對應您要的資料即可
python manage.py inspectdb</pre> 6. 開啟 admin 管理介面：設定 urls.py 

[<img src="https://i1.wp.com/farm4.static.flickr.com/3555/3478713850_800c92f6c6.jpg?resize=500%2C267&#038;ssl=1" title="Django_2 (by appleboy46)" alt="Django_2 (by appleboy46)" data-recalc-dims="1" />][12] 上面英文部份都寫得很清楚了，如果要打開 admin 功能必須要 unmark 掉哪幾行。 7. 新增 admin.py 到 app 資料夾裡頭，檔案內容： 

<pre class="brush: python; title: ; notranslate" title="">from mysite.news2.models import ProjectNews, ProjectNewsCategories
from django.contrib import admin
admin.site.register(ProjectNews)
admin.site.register(ProjectNewsCategories)</pre> 修改 settings.py 

<pre class="brush: python; title: ; notranslate" title="">INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.admin',
    'mysite.news',
)
</pre> 8. 啟動伺服器，內建 python manage tool 就可以辦到了 

<pre class="brush: python; title: ; notranslate" title="">python manage.py runserver 0.0.0.0:8000
</pre> 9. 打開瀏覽器：http://localhost:8000 或者是您的 ip 跟 domain 都可以上去 登入畫面： 

[<img src="https://i0.wp.com/farm4.static.flickr.com/3539/3478773086_3dab7acc19.jpg?resize=336%2C193&#038;ssl=1" title="Django_3 (by appleboy46)" alt="Django_3 (by appleboy46)" data-recalc-dims="1" />][13] 系統首頁： [<img src="https://i2.wp.com/farm4.static.flickr.com/3621/3478773166_028341e484.jpg?resize=500%2C199&#038;ssl=1" title="Site administration - Django site admin_1240799902399 (by appleboy46)" alt="Site administration - Django site admin_1240799902399 (by appleboy46)" data-recalc-dims="1" />][14] 管理新聞畫面： [<img src="https://i1.wp.com/farm4.static.flickr.com/3591/3478773262_6d0297ba76.jpg?resize=500%2C280&#038;ssl=1" title="Select project news to change - Django site admin_1240799942489 (by appleboy46)" alt="Select project news to change - Django site admin_1240799942489 (by appleboy46)" data-recalc-dims="1" />][15] 新增新聞畫面： [<img src="https://i1.wp.com/farm4.static.flickr.com/3394/3478773332_bfc9db0b1c.jpg?resize=500%2C270&#038;ssl=1" title="Change project news - Django site admin_1240799962251 (by appleboy46)" alt="Change project news - Django site admin_1240799962251 (by appleboy46)" data-recalc-dims="1" />][16] 10. 修改新聞系統 ForeignKey 

<pre class="brush: python; title: ; notranslate" title="">from django.db import models

# Create your models here.

class ProjectNews(models.Model):
    news_id = models.IntegerField(primary_key=True)
    user_id = models.IntegerField()
    group_id = models.IntegerField()
    #categories_id = models.IntegerField()
    categories = models.ForeignKey("ProjectNewsCategories")
    news_name = models.CharField(max_length=1020)
    news_desc = models.TextField()
    news_top = models.IntegerField()
    news_add_time = models.IntegerField()
    news_edit_time = models.IntegerField()
    class Meta:
        db_table = u'project_news'
    def __unicode__(self):
        return self.news_name


class ProjectNewsCategories(models.Model):
    categories_id = models.IntegerField(primary_key=True)
    categories_name = models.CharField(max_length=256)
    add_time = models.IntegerField()
    edit_time = models.IntegerField()
    class Meta:
        db_table = u'project_news_categories'
    def __unicode__(self):
        return self.categories_name</pre> 因為這檔案內容是依據 manage.py inspectdb 所產生的，系統並非知道我們所有 table 的關聯性，所以必須設定改掉部份關聯性，可以參考官方網站的教學 

[ForeignKey][17]，介紹就到此了，後面有 template 的教學，不過就比較容易一點，就靠大家去摸索了，課程還蠻豐富的，認真玩，可以學到很多東西。 可以去下載課程講義喔：[Web Framework- Django -初階 (講者：陳建玎)][5]

 [1]: https://www.flickr.com/photos/appleboy/3475465970/ "django-logo-negative_1236046419 (by appleboy46)"
 [2]: http://phorum.study-area.org/index.php
 [3]: http://whoswho.openfoundry.org
 [4]: http://www.python.org/
 [5]: http://whoswho.openfoundry.org/workshop/details/21.html
 [6]: http://codeigniter.com/
 [7]: http://www.codeigniter.com.tw/
 [8]: http://www.codeigniter.com.tw/forums
 [9]: https://www.flickr.com/photos/appleboy/3474957475/ "django (by appleboy46)"
 [10]: https://www.flickr.com/photos/appleboy/3475934172/ "django_01 (by appleboy46)"
 [11]: http://of.openfoundry.org/projects/442/kwiki
 [12]: https://www.flickr.com/photos/appleboy/3478713850/ "Django_2 (by appleboy46)"
 [13]: https://www.flickr.com/photos/appleboy/3478773086/ "Django_3 (by appleboy46)"
 [14]: https://www.flickr.com/photos/appleboy/3478773166/ "Site administration - Django site admin_1240799902399 (by appleboy46)"
 [15]: https://www.flickr.com/photos/appleboy/3478773262/ "Select project news to change - Django site admin_1240799942489 (by appleboy46)"
 [16]: https://www.flickr.com/photos/appleboy/3478773332/ "Change project news - Django site admin_1240799962251 (by appleboy46)"
 [17]: http://docs.djangoproject.com/en/dev/ref/models/fields/#django.db.models.ForeignKey