---
title: '[CodeIgniter] 簡單擷取 html 原始碼(PHP Simple HTML DOM Parser)'
author: appleboy
type: post
date: 2010-09-29T06:15:28+00:00
url: /2010/09/codeigniter-簡單擷取-html-原始碼php-simple-html-dom-parser/
views:
  - 4088
bot_views:
  - 246
dsq_thread_id:
  - 246845269
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
來介紹一套解析 html 原始碼的 open source: [PHP Simple HTML DOM Parser][1]，這套程式可以讓您任意對原始碼進行擷取操作，抓取一些您需要的資訊，在搭配 preg\_match 跟 preg\_match_all 函數來使用，使用方法可以參考線上 [Document][2]，簡單的範例如下(參考官方網站): 

<pre class="brush: php; title: ; notranslate" title="">// Create a DOM object from a string
$html = str_get_html('Hello!');

// Create a DOM object from a URL
$html = file_get_html('http://www.google.com/');

// Create a DOM object from a HTML file
$html = file_get_html('test.htm');</pre> 程式提供了三種讓您讀取原始碼，您可以直接丟 $string 或者是網址列，或者是檔案都可以，如果使用過 jQuery 您會發現在擷取 dom 的寫法很像，參考使用說明都寫得很清楚，由於 

[CodeIgniter][3] 沒有此功能，所以我把程式改了一下 porting 到 CI 的 libraries 資料夾裡面，Patch 檔案 <!--more--> 附上 Patch 檔案: 

<pre class="brush: bash; title: ; notranslate" title="">--- simplehtmldom/simple_html_dom.php   2008-12-15 02:56:56.000000000 +0800
+++ application/libraries/Simple_html_dom.php  2010-09-29 14:09:11.000000000 +0800
@@ -1,4 +1,4 @@
-<?php
+<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
 /*******************************************************************************
 Version: 1.11 ($Rev: 175 $)
 Website: http://sourceforge.net/projects/simplehtmldom/
@@ -30,56 +30,6 @@
 define('HDOM_INFO_OUTER',   6);
 define('HDOM_INFO_ENDSPACE',7);

-// helper functions
-// -----------------------------------------------------------------------------
-// get html dom form file
-function file_get_html() {
-    $dom = new simple_html_dom;
-    $args = func_get_args();
-    $dom->load(call_user_func_array('file_get_contents', $args), true);
-    return $dom;
-}
-
-// get html dom form string
-function str_get_html($str, $lowercase=true) {
-    $dom = new simple_html_dom;
-    $dom->load($str, $lowercase);
-    return $dom;
-}
-
-// dump html dom tree
-function dump_html_tree($node, $show_attr=true, $deep=0) {
-    $lead = str_repeat('    ', $deep);
-    echo $lead.$node->tag;
-    if ($show_attr && count($node->attr)>0) {
-        echo '(';
-        foreach($node->attr as $k=>$v)
-            echo "[$k]=>\"".$node->$k.'", ';
-        echo ')';
-    }
-    echo "\n";
-
-    foreach($node->nodes as $c)
-        dump_html_tree($c, $show_attr, $deep+1);
-}
-
-// get dom form file (deprecated)
-function file_get_dom() {
-    $dom = new simple_html_dom;
-    $args = func_get_args();
-    $dom->load(call_user_func_array('file_get_contents', $args), true);
-    return $dom;
-}
-
-// get dom form string (deprecated)
-function str_get_dom($str, $lowercase=true) {
-    $dom = new simple_html_dom;
-    $dom->load($str, $lowercase);
-    return $dom;
-}
-
-// simple html dom node
-// -----------------------------------------------------------------------------
 class simple_html_dom_node {
     public $nodetype = HDOM_TYPE_TEXT;
     public $tag = 'text';
@@ -476,9 +426,8 @@
     function previousSibling() {return $this->prev_sibling();}
 }

-// simple html dom parser
-// -----------------------------------------------------------------------------
-class simple_html_dom {
+class Simple_html_dom
+{
     public $root = null;
     public $nodes = array();
     public $callback = null;
@@ -515,13 +464,60 @@
                 $this->load_file($str);
             else
                 $this->load($str);
-        }
+        }
     }

     function __destruct() {
         $this->clear();
     }

+    // get html dom form file
+    function file_get_html()
+    {
+        $args = func_get_args();
+        $this->load(call_user_func_array('file_get_contents', $args), true);
+        return $this;
+    }
+
+    // get html dom form string
+    function str_get_html($str, $lowercase=true)
+    {
+        $this->load($str, $lowercase);
+        return $this;
+    }
+
+    // dump html dom tree
+    function dump_html_tree($node, $show_attr=true, $deep=0)
+    {
+        $lead = str_repeat('    ', $deep);
+        echo $lead.$node->tag;
+        if ($show_attr && count($node->attr)>0) {
+            echo '(';
+            foreach($node->attr as $k=>$v)
+                echo "[$k]=>\"".$node->$k.'", ';
+            echo ')';
+        }
+        echo "\n";
+
+        foreach($node->nodes as $c)
+            $this->dump_html_tree($c, $show_attr, $deep+1);
+    }
+
+    // get dom form file (deprecated)
+    function file_get_dom()
+    {
+        $args = func_get_args();
+        $this->load(call_user_func_array('file_get_contents', $args), true);
+        return $this;
+    }
+
+    // get dom form string (deprecated)
+    function str_get_dom($str, $lowercase=true)
+    {
+        $this->load($str, $lowercase);
+        return $this;
+    }
+
     // load html from string
     function load($str, $lowercase=true) {
         // prepare
@@ -971,5 +967,4 @@
     function getElementByTagName($name) {return $this->find($name, 0);}
     function getElementsByTagName($name, $idx=-1) {return $this->find($name, $idx);}
     function loadFile() {$args = func_get_args();$this->load(call_user_func_array('file_get_contents', $args), true);}
-}
-?>
\ No newline at end of file
+}
\ No newline at end of file
</pre> 在 CI Controller 底下使用方法： 

<pre class="brush: php; title: ; notranslate" title="">$this->load->library("simple_html_dom");
$box_url = "http://mlb.mlb.com/news/boxscore.jsp?gid=2010_09_28_phimlb_wasmlb_1";
/* load url */
$dom = $this->simple_html_dom->file_get_dom($box_url);
$result = $dom->find('div#datenav');
foreach($result as $v)
{
    preg_match_all("/&lt;option\s+value=\"([^>]+)\">/",$v->outertext, $team_game);
    print_r($team_game);
}</pre>

 [1]: http://simplehtmldom.sourceforge.net/
 [2]: http://simplehtmldom.sourceforge.net/manual.htm
 [3]: http://codeigniter.com