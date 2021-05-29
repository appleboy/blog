---
title: '[PHP]如何把 Yahoo! BBAuth 加入網站入口認證'
author: appleboy
type: post
date: 2008-09-25T16:33:49+00:00
url: /2008/09/php如何把-yahoo-bbath-加入網站入口認證/
views:
  - 8307
bot_views:
  - 1469
dsq_thread_id:
  - 247452136
categories:
  - Linux
  - Network
  - php
  - www
tags:
  - API
  - BBAuth
  - Linux
  - php
  - Yahoo

---
最近很紅的一個 [Yahoo API][1]：[Browser-Based Authentication][2]，這是目前蠻多網站開始支援的認證之一，在 [XDite][3] 網站看到他們去參加 [Yahoo Open Hack Day][4] 的參賽作品：「[和多繽紛樂][5]」[XDite 網站說明][6]，裡面就有提供 [OpenID][7] 以及 [Yahoo BBAuth 登入方式][2]，等於是說目前你有 Yahoo 帳號或者是 OpenID 的帳號都可以直接進去 [和多繽紛樂][5] 做登入動作，這對於有使用者不使用註冊這麼多網站，也記太多帳號密碼而煩惱，而 [Browser-Based Authentication][2] 也提供了 Single Sign-On (SSO) 給大家使用，底下是大概講解一下 [Yahoo BBAuth][2] 是如何運作： [<img src="https://i2.wp.com/farm4.static.flickr.com/3119/2887916878_330ea569bb.jpg?w=840&#038;ssl=1" border="0" alt="bbauth" data-recalc-dims="1" />][8] <!--more--> 上面那張圖大概就可以看了很清楚，首先要登入你的網站的時候，這時候你就可以產生一個 Yahoo 登入網址，然後把使用者轉向到 Yahoo 認證的網頁，然後經過雅虎認證之後，他會在把網頁導向你所想要的網址來進行認證，當然雅虎只提供認證部份，他不提供使用者的任何資料，所以認證成功，雅虎只會給您 hash 的一個值，然後你必須把這個值存到資料庫裡面，以便下次在進行認證的時候可以使用，所以基本上 Yahoo 只有幫忙認證部份而已喔。 其實要使用這個功能相當方便，

[BBAuth][9] 這個網站就已經有提供程式碼現成的給您使用修改了，首先當然你要先對你的網站給雅虎做認證用的： 1. 到這網頁來進行註冊的動作：[點我][10] [<img src="https://i1.wp.com/farm4.static.flickr.com/3073/2887111097_ee4b98a21e.jpg?w=840&#038;ssl=1" border="0" alt="2" data-recalc-dims="1" />][11] 大家看到這個圖片，大概知道怎麼填了吧 Authentication method：這個溝選 Browser Based Authentication Web Application URL：這個填你的網站網址 http://XXX.XXX.XXX.XXX/ 即可 BBAuth Success URL：這個就是要填寫當雅虎認證好之後，他會導向哪一個網址，這個確實填好喔～ 接下來就是按下一步了：會出現 Domain Confirmation 認證 [<img src="https://i0.wp.com/farm4.static.flickr.com/3093/2887971036_b4c2e3bd57.jpg?w=840&#038;ssl=1" border="0" alt="3" data-recalc-dims="1" />][12] 他意思是要你放一個檔案在根目錄：現在是要放 ydn8t9ZpE.html，然後這個檔案裡面寫上底下的字： 

> \# a we are now civil war engaged in testing great 這樣再進行確認就可以完成了，然後進到下面了： [<img src="https://i1.wp.com/farm4.static.flickr.com/3281/2887149345_ca9838d740.jpg?w=840&#038;ssl=1" border="0" alt="4" data-recalc-dims="1" />][13] 這樣大致上就成功了，那再來可以到 [Yahoo BBAuth 中文官方網站][9]，裡面有提供 [Quickstart Package here][14]，這裡面提供了程式碼，相當完整，都幫您寫好了喔 

<pre class="brush: php; title: ; notranslate" title="">// test.php -- Test Yahoo! Browser-Based Authentication
// A simple auth exmaple.
// Author: Jason Levitt
// Date: November 20th, 2006
// Version 1.0
//

// Edit these. Change the values to your Application ID and Secret
// 這裡就填入剛剛申請的 appid 跟 secret
define("APPID", 'ULAxDezIkY3iAUOsWxxxxxxxxxxxxxxxxxx');
define("SECRET", 'adff9f0b072cb159d4exxxxxxxxxxxx');

// Include the proper class file
// 確定目前系統的 php 版本，分別 include 不同的 class 檔
$v = phpversion();
if ($v[0] == '4') {
	include("includes/ybrowserauth.class.php4");
} elseif ($v[0] == '5') {
	include("includes/ybrowserauth.class.php5");
} else {
	die('Error: could not find the bbauth PHP class file.');
}
// 進行認證的 function
function CreateContent() {

	$authObj = new YBrowserAuth(APPID, SECRET);

	// If Yahoo! isn't sending the token, then we aren't coming back from an
	// authentication attempt
       // 雅虎認證靠得是這個 token 如果亂改就不能認證了
	if (empty($_GET["token"])) {
		// You can send some data along with the authentication request
		// In this case, the data is the string 'some_application_data'
               // 你可以傳遞參數寫在 some_application_data 這個欄位
		echo 'You have not signed on using BBauth yet<br /><br />';
		echo '<a href="'.$authObj->getAuthURL('some_application_data', true).'">Click here to authorize</a>';
		return;
	}

	// Validate the sig
	if ($authObj->validate_sig()) {
		echo '

<h2>
  BBauth authentication Successful
</h2>';
                // 回傳 userhash 值，來達到認證，當然必須寫回資料，等待下次的認證使用
		echo '

<h3>
  The user hash is: '.$authObj->userhash.'
</h3>';
        echo '

<b>appdata value is:</b> '. $authObj->appdata . '<br />';
	} else {
		die('

<h1>
  BBauth authentication Failed
</h1> Possible error msg is in $sig_validation_error:

<br />'. $authObj->sig_validation_error);
	}

	return;
}</pre> 大致上這樣就可以了，當然這是他們給的範例，如果搭配網站，有兩種方式，一種就是註冊網站，另一種就是利用 yahoo 的認證進入，其實現在網站提供這個都還不賴啦，很方便，又安全。

 [1]: http://tw.developer.yahoo.com/home.html
 [2]: http://developer.yahoo.com/auth/
 [3]: http://blog.xdite.net/
 [4]: http://hackday.ithome.com.tw/yahoo/
 [5]: http://bingo.handlino.com/
 [6]: http://blog.xdite.net/?p=709
 [7]: http://openid.net/
 [8]: https://www.flickr.com/photos/10526457@N00/2887916878/ "bbauth"
 [9]: http://tw.developer.yahoo.com/auth.html
 [10]: https://developer.yahoo.com/wsregapp/index.php
 [11]: https://www.flickr.com/photos/10526457@N00/2887111097/ "2"
 [12]: https://www.flickr.com/photos/10526457@N00/2887971036/ "3"
 [13]: https://www.flickr.com/photos/10526457@N00/2887149345/ "4"
 [14]: http://developer.yahoo.com/auth/quickstart/bbauth_quickstart.zip