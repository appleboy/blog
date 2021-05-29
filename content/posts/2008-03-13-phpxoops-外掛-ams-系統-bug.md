---
title: '[PHP][Xoops] 外掛 AMS 系統 bug ?'
author: appleboy
type: post
date: 2008-03-13T14:40:01+00:00
url: /2008/03/phpxoops-外掛-ams-系統-bug/
views:
  - 2628
bot_views:
  - 448
dsq_thread_id:
  - 254348908
categories:
  - php
  - www

---
上學期接任 [CN Journal][1] 組刊管理者，上任網管阿伯，留下一堆bug給我解決，不過還好去 trace 一下 AMS 的 code 之後發現一些 code 怪怪的，也不知道是不是 AMS 系統的問題 

> [BUG1]Preview button funcation error 修改AMS的編輯模組改為Koivi Editor，即可以解決無法正常預覽的功能 [BUG2]面板線上修改功能，只能看不能修改 這個問題是編寫該文章的作者，如要再次編輯修改該文章內容，需指定版本控制，否則無法修改 [BUG3]線上編輯有問題會PO上去出現空格過多(</br>)<預覽跟po上去網頁不同> 建議先轉換成html複製在筆記本上編輯,編好在貼回去比較安全 [BUG4]封面下文字(前言)無法對齊有不規律跳行或莫名的空格 建議把前言文字先用筆記本貼成一排然後在貼到編輯區裏,即可恢復你想要的排版  如果只要有裝 AMS 跟 使用他內建的編輯器 Koivi 會出現很多斷行問題，因為他使用 html 編輯，所以按一次 enter 之後，他會出現 <br />一次，然後系統又使用 nl2br，所以等於斷行兩次，當然我檢查了一下 AMS 裡面的 code 修改：modules/AMS/class/class.newsstory.php 

<pre class="brush: php; title: ; notranslate" title="">function hometext($format="Show")
{
    $myts =&#038; MyTextSanitizer::getInstance();
    $html = 1;
    $smiley = 1;
    $xcodes = 1;
    if ( $this->nohtml() ) {
        $html = 0;
    }
    if ( $this->nosmiley() ) {
        $smiley = 0;
    }
    switch ( $format ) {
        case "Show":
        $hometext = $myts->displayTarea($this->hometext,$html,$smiley,$xcodes);
        break;
        case "Edit":
        $hometext = $myts->htmlSpecialChars($this->hometext);
        break;
        case "Preview":
        $hometext = $myts->previewTarea($this->hometext,$html,$smiley,$xcodes);
        break;
        case "InForm":
        $hometext = $myts->htmlSpecialChars( $myts->stripSlashesGPC($this->hometext));
        break;
        case "N":
        $hometext = stripslashes($this->hometext);
        break;
    }
    return $hometext;
}
</pre>

<!--more--> 改成，下面這樣 

<pre class="brush: php; title: ; notranslate" title="">function hometext($format="Show")
{
    $myts =&#038; MyTextSanitizer::getInstance();
    $html = 1;
    $smiley = 1;
    $xcodes = 1;
    if ( $this->nohtml() ) {
        $html = 0;
        $br = 1;
    }
    else  {
        $br = 0;
    }
    if ( $this->nosmiley() ) {
        $smiley = 0;
    }
    switch ( $format ) {
        case "Show":
        $hometext = $myts->displayTarea($this->hometext,$html,$smiley,$xcodes, "", $br);
        break;
        case "Edit":
        $hometext = $myts->htmlSpecialChars($this->hometext);
        break;
        case "Preview":
        $hometext = $myts->previewTarea($this->hometext,$html,$smiley,$xcodes, "", $br);
        break;
        case "InForm":
        $hometext = $myts->htmlSpecialChars( $myts->stripSlashesGPC($this->hometext));
        break;
        case "N":
        $hometext = stripslashes($this->hometext);
        break;
    }
    return $hometext;
}
</pre> 還有 $bodytext 

<pre class="brush: php; title: ; notranslate" title="">function bodytext($format="Show")
{
  $myts =&#038; MyTextSanitizer::getInstance();
  $html = 1;
  $smiley = 1;
  $xcodes = 1;
  if ( $this->nohtml() ) {
      $html = 0;
  }
  if ( $this->nosmiley() ) {
      $smiley = 0;
  }
  switch ( $format ) {
      case "Show":
      $bodytext = $myts->displayTarea($this->bodytext,$html,$smiley,$xcodes,);
      break;
      case "Edit":
      $bodytext = $myts->htmlSpecialChars($this->bodytext);
      break;
      case "Preview":
      $bodytext = $myts->previewTarea($this->bodytext,$html,$smiley, $xcodes);
      break;
      case "InForm":
      $bodytext = $myts->htmlSpecialChars($myts->stripSlashesGPC($this->bodytext));
      break;
      case "N":
      $bodytext = stripslashes($this->bodytext);
      break;
  }
  return $bodytext;
}
</pre> 改成 

<pre class="brush: php; title: ; notranslate" title="">function bodytext($format="Show")
{
  $myts =&#038; MyTextSanitizer::getInstance();
  $html = 1;
  $smiley = 1;
  $xcodes = 1;
  if ( $this->nohtml() ) {
      $html = 0;
      $br = 1;
  }
  else  {
      $br = 0;
  }
  if ( $this->nosmiley() ) {
      $smiley = 0;
  }
  switch ( $format ) {
      case "Show":
      $bodytext = $myts->displayTarea($this->bodytext,$html,$smiley,$xcodes, "", $br);
      break;
      case "Edit":
      $bodytext = $myts->htmlSpecialChars($this->bodytext);
      break;
      case "Preview":
      $bodytext = $myts->previewTarea($this->bodytext,$html,$smiley, $xcodes, "", $br);
      break;
      case "InForm":
      $bodytext = $myts->htmlSpecialChars($myts->stripSlashesGPC($this->bodytext));
      break;
      case "N":
      $bodytext = stripslashes($this->bodytext);
      break;
  }
  return $bodytext;
}
</pre>

 [1]: http://journal.cn.ee.ccu.edu.tw/