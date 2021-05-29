---
title: '[Python] OSSF::自由軟體鑄造場 Python network programming -進階'
author: appleboy
type: post
date: 2009-05-04T13:58:49+00:00
url: /2009/05/python-ossf自由軟體鑄造場-python-network-programming-進階/
views:
  - 7132
bot_views:
  - 408
dsq_thread_id:
  - 246733887
categories:
  - Python
tags:
  - OSSF
  - Python

---
今天跑來聽 [OSSF::自由軟體鑄造場][1] 舉辦的 [Python network programming -進階][2] 課程，紀錄上課的心得，以及講師提到的一堆重點整理，分享給大家，收穫實在是太多了，本身在南部能聽到的課程就很少，一看到有開課程，就非常開心報名參加，講師對於上課準備的講義也很用心，學習到平常看書學不到的經驗跟實作。 **1. 字串處理函式** 

<pre class="brush: python; title: ; notranslate" title=""># 字串轉換小寫
string.lower
# 字串轉換大寫
string.upper
# 切割字串
string.split
# 合併字串
string.join
# 找尋字串
string.find</pre>

<!--more--> 底下來一個範例： 

<pre class="brush: python; title: ; notranslate" title="">import string
# 切割字串
print str.split(str.lower(str.upper("hi appleboy")))
# 合併 array
print str.join("",str.split("hi appleboy"))
# 找尋字串
print str.find("hi appleboy", "apple")
#
# 字串替換 template
s = string.Template("$who likes $what")
print s.substitute(who='appleboy', what='eat apple')
</pre>

**2. 日期處理** 

<pre class="brush: python; title: ; notranslate" title="">import time
from datetime import date
from datetime import datetime
# 時間
d = date(2005, 7, 14)
print d.isoformat()
print date.today().isoformat()
print d - date.today()</pre> 這裡講師有提到說，在 import module 的時候，希望有用到的 module 在 import 進來就可以了，這樣可以增進效能，也可以避免不需要的 load，在很多 MVC 裡面，大部分很多套件都會預先載入，可是我們在寫程式真的有用到嗎，講師提到 java，當我們想要 System.output 輸出，載入的 module 就很多，造成系統讀取速度降低阿。 

**3. Random 亂數處理** 可以參考官方網站文件：<http://docs.python.org/library/random.html> **4. bsddb — Interface to Berkeley DB library** [教學網站][3] bsddb module 提供一個 interface 介面來連接 Berkeley DB，使用者可以隨意新增 ash、btree 或 record，可以利用 [pickle.dumps()][4] 或者 [marshal.dumps()][5] 儲存。 python 預設沒有安裝這個 module，底下可以利用 FreeBSD ports 安裝 

<pre class="brush: bash; title: ; notranslate" title=""># Python bindings to the Berkeley DB library
cd /usr/ports/databases/py-bsddb; make install clean</pre> 給一個範例： 

<pre class="brush: python; title: ; notranslate" title="">import bsddb
db = bsddb.btopen('/tmp/spam.db', 'c')
for i in range(10): 
    db['%d'%i] = '%d'% (i*i)
# 印出第四筆資料
print db['3']
# 印出所有 key 值
print db.keys()
# 輸出 ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
# for 迴圈把 key & value 列出來
for k, v in db.iteritems():
    print k, v</pre>

**5. Regular Expression** 直接舉例，分別取出 IP Address 四個欄位數字 

<pre class="brush: python; title: ; notranslate" title="">import re
phonePattern = re.compile(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$')
a = phonePattern.search('140.123.107.249').groups()
for v in a:
    print v</pre> 投影片資料： 

<pre class="brush: bash; title: ; notranslate" title="">* ^ matches the beginning of a string.
    * $ matches the end of a string.
    * \b matches a word boundary.
    * \d matches any numeric digit.
    * \D matches any non-numeric character.
    * x? matches an optional x character 
      (in other words, it matches an x zero or one times).
    * x* matches x zero or more times.
    * x+ matches x one or more times.
    * x{n,m} matches an x character at least n times, 
       but not more than m times.
    * (a|b|c) matches either a or b or c.
    * (x) in general is a remembered group. 
       You can get the value of what matched by using the 
       groups() method of the object returned by re.search.</pre> 如果您在單一程式大量重複利用 regular expression，那可以用 re.compile(pattern[, flags]) object 來讓程式更有效率，學習 Regular Expression 好處很多，可以幫助您解決字串處理，擷取您想要的字串，底下推薦一些網站給大家： 

  * [組成 Regular Expression 的元素][6]
  * [RegExr: Online Regular Expression Testing Tool][7] 6. 

**zlib(gzip) & bz2** 基本的壓縮介紹，[gzip][8] 速度優於 [bz2][9]，適合用於壓縮檔案在網路傳輸方面，那 bz2 適合用在系統備份部份，可以把檔案壓縮更小，其實用的地方不太一樣，各有優缺點，那 apache2 就有提供 [mod_deflate][10] 增進傳輸效能，大量的 request 如果經過 mod_deflate 壓縮，可以大大減少網路傳輸流量。 最後當然就是介紹 python 怎麼寫抓取網頁 tag 部份，以及 Unicode 中文編碼的一些介紹，相當不錯，老師給的範例，等於是提供一隻小型的程式，可以當作指令來用，也有寫 help 用法： 

<pre class="brush: python; title: ; notranslate" title="">def help():
	print ("Usage: %s [Option] [Location]") % os.path.basename(sys.argv[0])
	print ("Option: ")
	print ("\t%2s, %-25s %s" % ("-h","--help","show this usage message."))
	print ("\t%2s, %-25s %s" % ("-v","--version","print version number."))
	print ("\t%2s, %-25s %s" % ("-c","--csv","print result in csv."))
	print ("Location: ")
	for x in allpart.keys():
		print ("\t%-12s"%x)</pre> 這隻程式包含了整個 python 寫程式的基本功能，看完這個 code 可以大上把老師這次上課跟上一堂課程整合在一起，包含 thread、class…等，那底下是老師寫的範例，抓取各地溫度，輸出成 csv 檔案，以及 unicode 的處理： 

<pre class="brush: python; title: ; notranslate" title="">#!/usr/bin/env python
#
#	Copyleft, No Right Reserved.
#
#				kevinwatt 2006/04/25
#
import urllib
import os,sys,re,string
import time
import threading
version="cwb.py version 0426"
TIMEOUT=1.0*10 # timeout for the operation in seconds
MAX_THREADS=4 # max thread.

Taipei=['Keelung','Taipei','Yangmingshan','Taoyuan','Sinwu','Hsinchu','Guanwu','Sanyi','Jhunan']
Tainan=['Tainan','Kaohsiung','Jiasian','Sandimen','Hengchun']
Yilan=['Yilan','Su-ao','Taipingshan','Hualien','Yuli','Chenggong','Taitung','Dawu','Lanyu']
Taichung=['Taichung','Wuci','Lishan','Yuanlin','Lugang','Sun-Moon-Lake','Lushan','Hehuan-Mountain','Huwei','Caoling','Chiayi','Alishan','Yushan']
Penghu=['Penghu','Kinmen','Matsu']
allpart={'Taipei': Taipei, 'Taichung':Taichung, 'Tainan':Tainan, 'Yilan':Yilan, 'Penghu':Penghu}
listtitle=['zone','datetime','rep','temp','direct','ane','max_ane','km','humidity','hPa','Rmm','uvi']

class cwb(threading.Thread):
    "Get weather information from www.cwb.gov.tw"
    def __init__(self,zonename):
        threading.Thread.__init__(self)
        self.zonename=zonename
        self.reg=re.compile('<([^>]|\n)*>|<br />|<BR />|&nbsp;|&nbsp')
        self.retab=re.compile('tabletype1-2')
        self.reconvspace=re.compile('&nbsp;|&nbsp')

    def run(self):
        self.contents = self.getinfo()

    def urlcontent(self):
        try:
            b = urllib.urlopen("http://www.cwb.gov.tw/pda/observe/"+self.zonename+".htm",proxies={}).read()
        except:
		    b = "Connection false"
		    sys.exit(0)
        return b

    def getinfo(self):
    	b=unicode(self.urlcontent(), "cp950")
    	list=[]
    	firsttarget="tabletype1-1"
    	b=b[b.find(firsttarget)+len(firsttarget)+2:]
    	b=b[:b.find('</table>')]
    	b=re.sub("\n+", "\n", self.reconvspace.sub(" ",self.reg.sub("",self.retab.sub("\>--",b))))
        conlist=string.split(b,"\n")
    	info=0
    	for x in conlist:
    		if x[0:2]=='--' and info<2:
    			info+=1 # list[1] is data time.
    			list.append(x[4:])
    		elif x[0:2]=='--':
    			list.append(re.sub('\s+','', x[4:]))
    	return list

def help():
	print ("Usage: %s [Option] [Location]") % os.path.basename(sys.argv[0])
	print ("Option: ")
	print ("\t%2s, %-25s %s" % ("-h","--help","show this usage message."))
	print ("\t%2s, %-25s %s" % ("-v","--version","print version number."))
	print ("\t%2s, %-25s %s" % ("-c","--csv","print result in csv."))
	print ("Location: ")
	for x in allpart.keys():
		print ("\t%-12s"%x)

def count_active(tail):
    """ returns the number of Getter threads that are alive """
    num_active = 0
    for g in tail:
        if g.isAlive():
            num_active += 1
    return num_active

def listprint(list,style):
	if style=="c":
		i=1
		for x in list:
			if len(list)==i and i==12:
				print ('"%s"' % x)
			elif len(list)==i and i<12:
				print ('"%s",""' % x)
			else:
				print ('"%s",' % x),
			i+=1
	else:
		for x in list:
			print ("%-8s" % x),
		print

if len(sys.argv) == 1:
	help()
	sys.exit(2) # common exit code for syntax error
else:
	if sys.argv[1:]:
		arglist=sys.argv[1:]
		getargv=arglist[0]
		if allpart.has_key(getargv):
			location=allpart[getargv]
		elif allpart.has_key(arglist[len(arglist)-1]):
			location=allpart[arglist[len(arglist)-1]]

		if arglist[0:] in (['--help'], ['-h'], ['--usage'], ['-?']):
			help()
			sys.exit(0)

		if arglist[0:] in (['-v'],['--version']):
			print version
			sys.exit(0)

		if arglist[0] in ('-c','--csv') and len(arglist)>1:
			style="c"
		else:
			style="nor"

		tail=[]
		try:    # get location
			len(location)
		except:
			print "Error: Could not find location"
			help()
			sys.exit(2)

		for zone in location:
			while count_active(tail) >= MAX_THREADS:
				#print "too many active, others wait here."
				time.sleep(1)
			g=cwb(zone)
			tail.append(g)
			g.start() # execute cwb.run()
		#print "there are",threading.activeCount()-1,"connecton thread started"	

		listprint(listtitle,style)
		for waterlist in tail:
			waterlist.join(TIMEOUT)
			# print waterlist.getName()+":",
			listprint(waterlist.contents,style)</pre>

 [1]: http://www.openfoundry.org/
 [2]: http://whoswho.openfoundry.org/workshop/details/22.html
 [3]: http://docs.python.org/library/bsddb.html
 [4]: http://docs.python.org/library/marshal.html#marshal.dumps
 [5]: http://docs.python.org/library/pickle.html#pickle.dumps
 [6]: http://phi.sinica.edu.tw/aspac/reports/94/94019/ch2.html
 [7]: http://www.gskinner.com/RegExr/
 [8]: http://docs.python.org/library/gzip.html?highlight=gzip#module-gzip
 [9]: http://docs.python.org/library/bz2.html?highlight=bz2#one-shot-de-compression
 [10]: http://httpd.apache.org/docs/2.2/mod/mod_deflate.html