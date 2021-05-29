---
title: '[無名小站]利用unix指令 wget 抓取 wretch 圖檔'
author: appleboy
type: post
date: 2008-08-23T04:43:03+00:00
url: /2008/08/無名小站利用unix指令-wget-抓取-wretch-圖檔/
views:
  - 5815
bot_views:
  - 688
dsq_thread_id:
  - 246888022
categories:
  - Linux
  - php
  - www
tags:
  - Linux
  - php
  - 無名小站

---
囧～其實用 wget 就可以迅速抓到 [無名小站][1] 的圖放到自己的伺服器上面，當然之前 [ptt][2] 的 php 版也有提供利用 curl 的方式來抓取圖，但是還要另寫另一隻讀圖程式，程式碼如下： 感謝 tsangbor＠ptt.cc 提供 DEMO: http://download.easygame.com.tw/get\_wretch\_img.php 輸入框請輸入 無名網友的相本 如： http://www.wretch.cc/album/album.php?id=qsplmiki&book=130 程式碼： <!--more-->

<pre class="brush: php; title: ; notranslate" title=""><?php
 
 
if( $_POST['album'] )
{
	$album = trim($_POST['album']);
	$showall = trim($_POST['showall']);
 
	$tmp = fetchWebSource($album, $showall);
 
		$pattern = "/<img src=\"(.*?)\"/";
		preg_match_all($pattern,$tmp,$result);
 
		foreach( $result[1] as $k => $v )
		{
			$img = str_replace("/thumbs/t","/", $v);
			echo '

<img src="/show.php?'.urlencode($img).'" /><br />'; //這段是直接輸出img,不過因為無名擋外部讀檔,所以還要再寫一個PHP專門讀取圖檔.
		}
 
}
 
function fetchWebSource($url, $showall=0)
{
	$ch=curl_init();
	curl_setopt($ch, CURLOPT_URL,$url);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_REFERER, "http://www.wretch.cc/");
	curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Accept-Language: en-GB,zh-tw;q=0.5"));
	curl_setopt($ch, CURLOPT_HTTPHEADER, Array("UA-CPU: x86"));
	curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Accept-Encoding: gzip, deflate"));
	curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Connection: Keep-Alive"));
	curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; InfoPath.2; FDM; .NET CLR 1.1.4322)");
	if( $showall )
		curl_setopt($ch, CURLOPT_COOKIE, "showall=1; a_page=1; lang=zh-tw");
 
	$result = curl_exec($ch);
	curl_close($ch);
 
	return $result;	
}
?>
 


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</pre> 嗯嗯 然後我自己利用 unix 系統指令 wget 加上 referer 的參數，也很快，大家看看就好： 

<pre class="brush: php; title: ; notranslate" title=""><?
$wget = exec(escapeshellcmd("which wget"));
$referer = "http://www.wretch.cc/";

function rmkdir($path, $mode = 0755) {
    $path = rtrim(preg_replace(array("/\\\\/", "/\/{2,}/"), "/", $path), "/");
    $e = explode("/", ltrim($path, "/"));
    if(substr($path, 0, 1) == "/") {
        $e[0] = "/".$e[0];
    }
    $c = count($e);
    $cp = $e[0];
    for($i = 1; $i < $c; $i++) {
        if(!is_dir($cp) &#038;&#038; !@mkdir($cp, $mode)) {
            return false;
        }
        $cp .= "/".$e[$i];
    }
    return @mkdir($path, $mode);
}

function get_wretch_picture($dir, $url)
{
  global $wget, $referer;
  if(!file_exists($dir))
  {
    rmkdir($dir);
  }
  $file = basename($url);
  if(!file_exists($dir . '/' . $file))
  {
    $cmd = $wget . " --referer=" . $referer . " -O " . $dir . '/' . $file . " " . $url;
    shell_exec($cmd);  
  }
  echo "<img src='".$dir . '/' . $file."'>";
}

get_wretch_picture("./wretch/2008.07.23", "http://f6.wretch.yimg.com/appleboy/1/1139150376.jpg");
?></pre> get\_wretch\_picture(&#8220;參數一&#8221;, &#8220;參數二&#8221;) 參數一：放您要存放資料夾 參數二：放無名小站圖片的網址

 [1]: http://www.wretch.cc/
 [2]: http://www.ptt.cc