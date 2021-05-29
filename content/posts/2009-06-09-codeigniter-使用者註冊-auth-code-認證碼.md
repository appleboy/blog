---
title: '[CodeIgniter] 使用者註冊 auth code 亂數認證碼圖片'
author: appleboy
type: post
date: 2009-06-09T14:38:39+00:00
url: /2009/06/codeigniter-使用者註冊-auth-code-認證碼/
views:
  - 9450
bot_views:
  - 560
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
我想這已經是網站最基本的技術，防止機器人大量註冊，或者是灌爆留言板，之前寫了兩篇製作認證碼的教學：[[PHP]製作類似 google 網頁認證碼][1]，[[PHP] 好用的留言板 驗證碼 功能][2]，這篇是要寫如何實做把[第一篇教學][1]整合到 [CodeIgniter][3] 系統裡面，來筆記一下，以後用到就相當方便了，CodeIgniter 在 path 路徑上面有小 bug，查了國外討論區發現了這篇 [Path to CSS doesn’t work a second time][4]，不過這並沒有解決我的問題，主機的網址是 <span style="color: #0000ff;">http://xxxxx.xxx/path/</span>，所有的 CI 檔案都是放在 path 目錄底下，包含圖片是 <span style="color: #0000ff;">http://xxxxx.xxx/path/images/</span>，在 View 裡面基本上只要寫 <span style="color: #008000;"><img src='/images/xx.gif'></span> 這樣就可以顯示圖片了，但是要改成 <span style="color: #008000;"><img src='/path/images/xx.gif'></span> 才能，但是我的 index.php 是放在 /path/ 裡面，以絕對路徑跟相對路徑來想，都是不太合理的，所以後來用 <span style="color: #ff0000;"><img src="<?=base_url();?>public/images/find.png" alt="" /></span> 來解決，不過這是暫時的問題，我比較龜毛，喜歡寫短一點的 code。 如何裝上類似 google 的認證碼呢，首先打開 index.php 檔案 

<pre class="brush: php; title: ; notranslate" title="">/* 算出 index.php 根目錄 */
define('Document_root',dirname(__FILE__));
</pre>

<!--more--> 建立 Controller：vcode.php 檔案，程式碼如下： 

<pre class="brush: php; title: ; notranslate" title=""><?php
class Vcode extends Controller {

  var $mode;          // 1.文字模式, 2.字母模式, 3.文字字母混合模式, 4.其他文字字母優化模式
  var $v_num;         // 驗證碼個數
  var $img_w;         // 圖像寬度
  var $img_h;         // 圖像高度
  var $int_pixel_num; // 干擾像數個數
  var $int_line_num;  // 干擾線條數量
  var $font_dir;      // 字型文件路徑
  var $border;        // 圖像邊框
  var $borderColor;   // 圖像邊框顏色
  
  function __construct()
  {
    parent::Controller(); 
		//session_start();
		
  }
  function index()
  {
    $this->getCode('');
  }
  function getCode($time)
  {
    $this->SetImage(4,5,100,50,60,0);
  }
  function SetImage($mode, $v_num, $img_w, $img_h, $int_pixel_num, $int_line_num, $font_dir = '/tool/font', $border=false, $borderColor='0,0,0')
  {
      $this -> mode = $mode;
      $this -> v_num = $v_num;
      $this -> img_w = $img_w;
      $this -> img_h = $img_h;
      $this -> int_pixel_num = $int_pixel_num;
      $this -> int_line_num = $int_line_num;
      $this -> font_dir = Document_root . $font_dir;
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
      for($i = 0; $i &lt; $this-> v_num; $i++){  
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
      //imagettftext ($im, 24, mt_rand(-6, 6), 10, $this -> img_h * 0.6, $color, $font, $v_code);
      imagettftext ($im, 24, 0, 10, $this -> img_h * 0.6, $color, $font, $v_code);
      // 干擾線條
      for($i = 0; $i &lt; $this -> int_line_num; $i++){
          $rand_color_line = $color;
          imageline($im, mt_rand(2,intval($this -> img_w/3)), mt_rand(10,$this -> img_h - 10), mt_rand(intval($this -> img_w - ($this -> img_w/3) + 50),$this -> img_w), mt_rand(0,$this -> img_h), $rand_color_line);
      }

      $ranum = mt_rand(0, 1);
      $dis_range = mt_rand(8, 12);
      $distortion_im = imagecreatetruecolor ($this -> img_w * 1.5 ,$this -> img_h);        
      imagefill($distortion_im, 0, 0, imagecolorallocate($distortion_im, 255, 255, 255));
      for ($i = 0; $i &lt; $this -> img_w + 50; $i++) {
          for ($j = 0; $j &lt; $this -> img_h; $j++) {
              $rgb = imagecolorat($im, $i, $j);
              if($ranum == 0){
                  if( (int)($i+40+cos($j/$this -> img_h * 2 * M_PI) * 10) &lt;= imagesx($distortion_im) && (int)($i+20+cos($j/$this -> img_h * 2 * M_PI) * 10) >=0 ) {
                      imagesetpixel ($distortion_im, (int)($i+10+cos($j/$this -> img_h * 2 * M_PI - M_PI * 0.4) * $dis_range), $j, $rgb);
                  }
              }else{
                  if( (int)($i+40+sin($j/$this -> img_h * 2 * M_PI) * 10) &lt;= imagesx($distortion_im) && (int)($i+20+sin($j/$this -> img_h * 2 * M_PI) * 10) >=0 ) {
                      imagesetpixel ($distortion_im, (int)($i+10+sin($j/$this -> img_h * 2 * M_PI - M_PI * 0.4) * $dis_range), $j, $rgb);
                  }
              }
          }
      }

      // 干擾像素
      for($i = 0; $i &lt; $this -> int_pixel_num; $i++){
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
      $this->session->set_userdata('vCode', $v_code."|".$time);
      //$_SESSION['vCode'] = $v_code."|".$time; // 把驗證碼與時間賦與給 $_SESSION[vCode], 時間欄位可以驗證是否超時

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
</pre> 顯示認證碼：在您想要的 Controller 裡面加入： 

<pre class="brush: php; title: ; notranslate" title="">#
# 加入 image
$data['image'] = '<img id="auth_code" src="'.base_url().'vcode" />';
#
# 放入 Viewer 裡面
$this->load->view('profile/register',$data);</pre> 打開 views/profile/register.php 加入 jQuery javascript，可以自動刷新圖片 

<pre class="brush: jscript; title: ; notranslate" title="">$("#auth_code").click(function(){
	genCode();
});
function genCode(){
  vNum = Math.random()
  vNum = Math.round(vNum*10)
	$("#auth_code").attr("src", "<?=base_url()?>vcode/getCode/"+ vNum);
}</pre> 在 html 寫入您要顯示的地方 

<pre class="brush: php; title: ; notranslate" title=""><?=$image?></pre> 大致上完成了，不難，因為稍微改一下 vcode.php 的部份，記得調整 font 的目錄，並且放上要顯示的字型就可以了。

 [1]: http://blog.wu-boy.com/2009/01/05/701/
 [2]: http://blog.wu-boy.com/2008/10/28/572/
 [3]: http://www.codeigniter.com.tw/
 [4]: http://codeigniter.com/forums/viewthread/63915/