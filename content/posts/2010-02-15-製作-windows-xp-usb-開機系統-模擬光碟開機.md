---
title: 製作 Windows XP USB 開機系統 (模擬光碟開機)
author: appleboy
type: post
date: 2010-02-15T08:37:03+00:00
url: /2010/02/製作-windows-xp-usb-開機系統-模擬光碟開機/
views:
  - 24637
bot_views:
  - 592
dsq_thread_id:
  - 246689429
categories:
  - windows
tags:
  - USB
  - windows

---
最近幫朋友重灌一台電腦，發現他是 [HP Mini 1109TU][1]，沒有內建光碟機，然後朋友又沒買外接式光碟機，所以只好趕快上網找如何製作 Windows XP USB 系統，如果是 Linux 系列就好辦了，網路上找到[一堆關於 Linux 教學文件][2]，後來在 [mobile01][3] 找到一篇：『[[教學]將USB 隨身碟 製成 XP 的安裝碟 (模擬CD-ROM)][4]』，裡面的安裝過程我全部測試過了，可以正常運作，利用 USB 安裝 XP 真的還蠻快的，少了 CD-Rom 的讀取，USB 真的安裝相當快速，不過大家在上面下載的安裝程式，它會先將您的 USB 進行 Fat32 格式化，然後複製 XP 光碟內容到 USB 隨身碟，在設定複製內容到 USB 的同時，請不要將 USB 掛載到 D 槽，因為看了一下程式碼 usb_prep8.cmd 裡面有一段設定 USB 開機選項： 

<pre class="brush: bash; title: ; notranslate" title="">:_getusb
set _ok=
echo.
echo  Please give Target USB-Drive Letter e.g type U
ECHO.
set /p _ok= Enter Target USB-Drive Letter: 
set _ok=!_ok:~0,1!
if not exist !_ok!:\nul (
  echo.
  echo  ***** Target USB-Drive !_ok!: does NOT Exist *****
  echo.
  pause
  goto _main
)

FOR %%i IN (E F G H I J K L M N O P Q R S T U V W X Y e f g h i j k l m n o p q r s t u v w x y) DO IF "%%i" == "!_ok!" SET usbdrive=!_ok!:

if "%usbdrive%" == "" ( 
        echo.
        echo  ***** !_ok!: is not a valid Drive *****
        echo.
	pause
	goto _main
)</pre> 在 for 的迴圈裡面，並沒有寫到 D 這個代碼，所以自己把它補上去吧，這樣就可以正常複製光碟內容到 USB 裡面了。

 [1]: http://h50178.www5.hp.com/support/NQ202PA/faqs/114163.html?jumpid=reg_R1002_TWZH
 [2]: http://wiki.ubuntu-tw.org/index.php?title=UNetbootin%EF%BC%9A%E5%8F%AF%E8%A3%BD%E4%BD%9C_Linux_Live_USB_%E7%9A%84%E7%A8%8B%E5%BC%8F
 [3]: http://www.mobile01.com
 [4]: http://www.mobile01.com/topicdetail.php?f=159&t=665722