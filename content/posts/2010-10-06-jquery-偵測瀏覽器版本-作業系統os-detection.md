---
title: jQuery 偵測瀏覽器版本, 作業系統(OS detection)
author: appleboy
type: post
date: 2010-10-06T03:32:46+00:00
url: /2010/10/jquery-偵測瀏覽器版本-作業系統os-detection/
views:
  - 3444
bot_views:
  - 228
dsq_thread_id:
  - 246692184
categories:
  - AJAX
  - javascript
  - jQuery
tags:
  - javascript
  - jQuery

---
**update: 簡易版的偵測 iphone/ipod time: 23:32** [jQuery][1] 真是一個相當方便的 javascript framework，最近在弄嵌入式系統時候需要去偵測瀏覽器 user agent，就類似下此訊息 "<span style="color:red"><strong>Mozilla/4.0 (compatible; MSIE 4.01; Windows 95)</strong></span>"，原本打算直接用 C 語言內建的 <span style="color:green"><strong>getenv("HTTP_USER_AGENT")</strong></span> 來做掉，不過後來想想，直接在 UI 那邊，利用 jQuery 來偵測瀏覽器版本、系統OS，這樣就解決了，上網找到有人寫了 [jQuery browser and OS detection plugin][2]，利用底下語法就可以知道一些 user agent 裡面的資料 

<pre class="brush: xml; title: ; notranslate" title="">

    

<div id="os">
  
</div>
    

<div id="browser">
  
</div>
    

<div id="version">
  
</div>
    

<div id="d_width">
  
</div>
    

<div id="d_height">
  
</div>
    
    
    


</pre>

<!--more--> 此 plugin 利用了 

[JavaScript Navigator Object][3] 來做到全部的偵測，在 Navigator Object 裡面有 userAgent, platform, appVersion 等資料可以供您使用，在搭配 indexOf 來找尋字串，瀏覽器版本用 [JavaScript parseFloat() Function][4] 來取得，這樣就大致完成，底下附上 jQuery client js 程式碼 

<pre class="brush: jscript; title: ; notranslate" title="">(function() {

	var BrowserDetect = {
		init: function () {
            this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
			this.version = this.searchVersion(navigator.userAgent)
				|| this.searchVersion(navigator.appVersion)
				|| "an unknown version";
			this.OS = this.searchString(this.dataOS) || "an unknown OS";
		},
		searchString: function (data) {
			for (var i=0;i&lt;data.length;i++)	{
				var dataString = data[i].string;
				var dataProp = data[i].prop;
				this.versionSearchString = data[i].versionSearch || data[i].identity;
                if (dataString) {
					if (dataString.indexOf(data[i].subString) != -1)
						return data[i].identity;
				}
				else if (dataProp)
					return data[i].identity;
			}
		},
		searchVersion: function (dataString) {
            console.log(this.versionSearchString);
            var index = dataString.indexOf(this.versionSearchString);
			if (index == -1) return;
			console.log(dataString.substring(index+this.versionSearchString.length+1));
			return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
		},
		dataBrowser: [
			{
				string: navigator.userAgent,
				subString: "Chrome",
				identity: "Chrome"
			},
			{ 	string: navigator.userAgent,
				subString: "OmniWeb",
				versionSearch: "OmniWeb/",
				identity: "OmniWeb"
			},
			{
				string: navigator.vendor,
				subString: "Apple",
				identity: "Safari",
				versionSearch: "Version"
			},
			{
				prop: window.opera,
				identity: "Opera"
			},
			{
				string: navigator.vendor,
				subString: "iCab",
				identity: "iCab"
			},
			{
				string: navigator.vendor,
				subString: "KDE",
				identity: "Konqueror"
			},
			{
				string: navigator.userAgent,
				subString: "Firefox",
				identity: "Firefox"
			},
			{
				string: navigator.vendor,
				subString: "Camino",
				identity: "Camino"
			},
			{		// for newer Netscapes (6+)
				string: navigator.userAgent,
				subString: "Netscape",
				identity: "Netscape"
			},
			{
				string: navigator.userAgent,
				subString: "MSIE",
				identity: "Explorer",
				versionSearch: "MSIE"
			},
			{
				string: navigator.userAgent,
				subString: "Gecko",
				identity: "Mozilla",
				versionSearch: "rv"
			},
			{ 		// for older Netscapes (4-)
				string: navigator.userAgent,
				subString: "Mozilla",
				identity: "Netscape",
				versionSearch: "Mozilla"
			}
		],
		dataOS : [
			{
				string: navigator.platform,
				subString: "Win",
				identity: "Windows"
			},
			{
				string: navigator.platform,
				subString: "Mac",
				identity: "Mac"
			},
			{
				string: navigator.userAgent,
				subString: "iPhone",
				identity: "iPhone/iPod"
		    },
			{
				string: navigator.platform,
				subString: "Linux",
				identity: "Linux"
			}
		]

	};

	BrowserDetect.init();

	window.$.client = {
        os : BrowserDetect.OS,
        browser : BrowserDetect.browser,
        version : BrowserDetect.version,
    };

})();
[/code]

補充簡易版的偵測 iphone/ipod (<a href="http://jquery-howto.blogspot.com/2010/09/iphone-ipod-detection-using-jquery.html">Javascript code to detect iPhone and iPod browsers</a>)
function isiPhone(){
    return (
        (navigator.platform.indexOf("iPhone") != -1) ||
        (navigator.platform.indexOf("iPod") != -1)
    );
}
if(isiPhone()){
    window.location = "mob.example.com";
}</pre>

 [1]: http://jquery.com/
 [2]: http://www.mengu.net/post/jquery-os-detection
 [3]: http://www.comptechdoc.org/independent/web/cgi/javamanual/javanavigator.html
 [4]: http://www.w3schools.com/jsref/jsref_parseFloat.asp