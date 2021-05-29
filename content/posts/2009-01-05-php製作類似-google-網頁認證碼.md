---
title: '[PHP]製作類似 google 網頁認證碼'
author: appleboy
type: post
date: 2009-01-05T15:36:25+00:00
url: /2009/01/php製作類似-google-網頁認證碼/
views:
  - 10631
bot_views:
  - 953
runphp:
  - 1
dsq_thread_id:
  - 246692770
categories:
  - php
tags:
  - php

---
我在 [網站製作學習誌][1] 發現一篇 [[Web] 連結分享][2] 裡面有一篇：[用php做出類似Google的字詞驗證圖片][3]，這一篇寫的不錯，跟我之前寫的一篇：[[PHP] 好用的留言板 驗證碼 功能][4]，驗證碼的強度還要更好，畢竟這樣比較不會被破解，然而這篇加上許多干擾的驗證，也選用了比較複雜的字型來提供給網站驗證部份，在 google 的登入系統部份，剛開始都是給使用者方便，不會跑出驗證碼的部份，可是只要輸入幾次錯誤的帳號密碼之後，google 的驗證碼就會跑出來了，而這個很類似 google 的驗證碼提供給大家使用，當然也感謝原作者，因為在Google字詞驗證與 [CAPTCHA][5] 都已經相繼被破解，這消息我不知道從哪裡來的，在 [這裡][3] 有提到，詳細情祥可能要網路查查了 那在這個 php class 說明以及 code 如下，相信都寫的很清楚： html 認證部份： 

<pre class="brush: xml; title: ; notranslate" title="">



Type the characters you see in the picture below. <br />
<img src="verify_image.php" alt="點此刷新驗證碼" name="verify_code" width="150" height="60" border="0" id="verify_code"
onclick="document.getElementById('verify_code').src='verify_image.php?' + Math.random();" style="FILTER: wave(add=0,freq=3,lightstrength=50,phase=0,strength=3);cursor:pointer;" /><br />


</pre>

<!--more--> verify_image.php 的 code： 

<pre class="brush: php; title: ; notranslate" title=""><?php
	session_start();   // if header already send, change output_buffering = On at php.ini.
?>


<?php
$vi = new vCodeImage();
$vi -> SetImage(2,7,130,60,120,1);

class vCodeImage
{
	var $mode;			// 1.文字模式, 2.字母模式, 3.文字字母混合模式, 4.其他文字字母優化模式
	var $v_num;			// 驗證碼個數
	var $img_w;			// 圖像寬度
	var $img_h;			// 圖像高度
	var $int_pixel_num; // 干擾像數個數
	var $int_line_num;	// 干擾線條數量
	var $font_dir;		// 字型文件路徑
	var $border;		// 圖像邊框
	var $borderColor;	// 圖像邊框顏色

	function SetImage($mode, $v_num, $img_w, $img_h, $int_pixel_num, $int_line_num, $font_dir='font', $border=false, $borderColor='0,0,0')
	{
		if(!isset($_SESSION['vCode'])){
			session_register('vCode');
		}
		$_SESSION['vCode'] = "";

		$this -> mode = $mode;
		$this -> v_num = $v_num;
		$this -> img_w = $img_w;
		$this -> img_h = $img_h;
		$this -> int_pixel_num = $int_pixel_num;
		$this -> int_line_num = $int_line_num;
		$this -> font_dir = $font_dir;
		$this -> border = $border;
		$this -> borderColor = $borderColor;
		$this -> GenerateImage();
	}

	function GetChar($mode)
	{
		if($mode == "1"){
			$ychar = "0,1,2,3,4,5,6,7,8,9";
		}else if($mode == "2"){
			$ychar = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z";
		}else if($mode == "3"){
			$ychar = "0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z";
		}else{
			$ychar = "3,4,5,6,7,8,9,a,b,c,d,h,k,p,r,s,t,w,x,y";
		}
		return $ychar;
	}
 
	function RandColor($rs, $re, $gs, $ge, $bs, $be)
	{
		$r = mt_rand($rs, $re);
		$g = mt_rand($gs, $ge);
		$b = mt_rand($bs, $be);
		return array($r, $g, $b);
	}
 
	function GenerateImage()
	{
		$fonts = scandir($this -> font_dir);
		$ychar = $this -> GetChar($this -> mode);
		$list = explode(",", $ychar);
		$cmax = count($list) - 1;
		$fmax = count($fonts) - 2;
		$fontrand = mt_rand(2, $fmax);
		$font = $this -> font_dir."/".$fonts[$fontrand];

		// 驗證碼
		$v_code = "";
		for($i = 0; $i < $this-> v_num; $i++){	
			$randnum = mt_rand(0, $cmax);
			$this_char = $list[$randnum];
			$v_code .= $this_char;
		}

		// 扭曲圖形
		$im = imagecreatetruecolor ($this -> img_w + 50, $this -> img_h);
		$color = imagecolorallocate($im, 32, 81, 183);
		$ranum = mt_rand(0, 2);
		if($ranum == 0){
			$color = imagecolorallocate($im, 32, 81, 183);
		}else if($ranum == 1){
			$color = imagecolorallocate($im, 17, 158, 20);
		}else{
			$color = imagecolorallocate($im, 196, 31, 11);
		}
		imagefill($im, 0, 0, imagecolorallocate($im, 255, 255, 255) );
		imagettftext ($im, 24, mt_rand(-6, 6), 10, $this -> img_h * 0.6, $color, $font, $v_code);

		// 干擾線條
		for($i = 0; $i < $this -> int_line_num; $i++){
			$rand_color_line = $color;
			imageline($im, mt_rand(2,intval($this -> img_w/3)), mt_rand(10,$this -> img_h - 10), mt_rand(intval($this -> img_w - ($this -> img_w/3) + 50),$this -> img_w), mt_rand(0,$this -> img_h), $rand_color_line);
		}

		$ranum = mt_rand(0, 1);
		$dis_range = mt_rand(8, 12);
		$distortion_im = imagecreatetruecolor ($this -> img_w * 1.5 ,$this -> img_h);        
		imagefill($distortion_im, 0, 0, imagecolorallocate($distortion_im, 255, 255, 255));
		for ($i = 0; $i < $this -> img_w + 50; $i++) {
			for ($j = 0; $j < $this -> img_h; $j++) {
				$rgb = imagecolorat($im, $i, $j);
				if($ranum == 0){
					if( (int)($i+40+cos($j/$this -> img_h * 2 * M_PI) * 10) <= imagesx($distortion_im) &#038;&#038; (int)($i+20+cos($j/$this -> img_h * 2 * M_PI) * 10) >=0 ) {
						imagesetpixel ($distortion_im, (int)($i+10+cos($j/$this -> img_h * 2 * M_PI - M_PI * 0.4) * $dis_range), $j, $rgb);
					}
				}else{
					if( (int)($i+40+sin($j/$this -> img_h * 2 * M_PI) * 10) <= imagesx($distortion_im) &#038;&#038; (int)($i+20+sin($j/$this -> img_h * 2 * M_PI) * 10) >=0 ) {
						imagesetpixel ($distortion_im, (int)($i+10+sin($j/$this -> img_h * 2 * M_PI - M_PI * 0.4) * $dis_range), $j, $rgb);
					}
				}
			}
		}

		// 干擾像素
		for($i = 0; $i < $this -> int_pixel_num; $i++){
			$rand_color_pixel = $color;
			imagesetpixel($distortion_im, mt_rand() % $this -> img_w + 20, mt_rand() % $this -> img_h, $rand_color_pixel);
		}

		// 繪製邊框
		if($this -> border){
			$border_color_line = $color;
			imageline($distortion_im, 0, 0, $this -> img_w, 0, $border_color_line); // 上橫
			imageline($distortion_im, 0, 0, 0, $this -> img_h, $border_color_line); // 左豎
			imageline($distortion_im, 0, $this -> img_h-1, $this -> img_w, $this -> img_h-1, $border_color_line); // 下橫
			imageline($distortion_im, $this -> img_w-1, 0, $this -> img_w-1, $this -> img_h, $border_color_line); // 右豎
		}

		imageantialias($distortion_im, true); // 消除鋸齒

		$time = time();
		$_SESSION['vCode'] = $v_code."|".$time; // 把驗證碼與時間賦與給 $_SESSION[vCode], 時間欄位可以驗證是否超時

		// 生成圖像給瀏覽器
		if (function_exists("imagegif")) {
			header ("Content-type: image/gif");
			imagegif($distortion_im);
		}else if (function_exists("imagepng")) {
			header ("Content-type: image/png");
			imagepng($distortion_im);
		}else if (function_exists("imagejpeg")) {
			header ("Content-type: image/jpeg");
			imagejpeg($distortion_im, "", 80);
		}else if (function_exists("imagewbmp")) {
			header ("Content-type: image/vnd.wap.wbmp");
			imagewbmp($distortion_im);
		}else{
		  die("No Image Support On This Server !");
		}

		imagedestroy($im);
		imagedestroy($distortion_im);
	}
}
?></pre> 傳到認證網頁： 因為 session 部份加入了時間部份，所以先用 explode 先隔開 

<pre class="brush: php; title: ; notranslate" title=""><?php
	session_start();
	$ara = explode("|", $_SESSION['vCode']);
	if($ara[0] == $_POST['code']){
		echo("Verify Success. code is ".$ara[0]);
	}else{
		echo("Verify failed. correct code is ".$ara[0].", you typed ".$_POST['code']);
	}
?></pre> 測試網站： 

<http://blog.wu-boy.com/wp-content/PHP/verify/verify.html> 參考網站： <http://samsharehome.blogspot.com/2008/12/phpgoogle.html>

 [1]: http://blog.roodo.com/jaceju/
 [2]: http://blog.roodo.com/jaceju/archives/8015459.html
 [3]: http://samsharehome.blogspot.com/2008/12/phpgoogle.html
 [4]: http://blog.wu-boy.com/2008/10/28/572/
 [5]: http://caca.zoy.org/wiki/PWNtcha