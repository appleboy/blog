---
title: '[教學] phpBB3 使用者簽名檔 url 連結加上 rel=”nofollow”'
author: appleboy
type: post
date: 2010-06-10T13:29:02+00:00
url: /2010/06/教學-phpbb3-使用者簽名檔-url-連結加上-relnofollow/
views:
  - 3446
bot_views:
  - 453
dsq_thread_id:
  - 246710777
categories:
  - php
tags:
  - php
  - phpBB3

---
基於 [Moztw 討論區][1] 有大陸使用者註冊之後，在簽名檔加入一些廣告連結，為了降低 Google Page Rank，所以我們必須指示搜尋引擎「不要前往此網頁上的連結」或是「不要前往此連結」，可以參考 [關於 rel="nofollow"][2]，[phpBB3][3] 編輯三個檔案就可以了，此修改不影響<span style="color:red">文章內容</span>，只有針對<span style="color:red">簽名檔</span>作用，底下是 patch 程式碼，可以參考看看 <span style="color:green">includes/bbcode.php</span> 

<pre class="brush: diff; title: ; notranslate" title="">--- phpBB3/includes/bbcode.php  2010-03-06 04:37:23.000000000 +0800
+++ www/includes/bbcode.php     2010-06-10 20:58:02.000000000 +0800
@@ -2,7 +2,8 @@
 /**
 *
 * @package phpBB3
-* @version $Id$
+* @version $Id: bbcode.php 9461 2009-04-17 15:23:17Z acydburn $
+* @log 2010-06-10 appleboy $
 * @copyright (c) 2005 phpBB Group
 * @license http://opensource.org/licenses/gpl-license.php GNU Public License
 *
@@ -48,7 +49,7 @@
        /**
        * Second pass bbcodes
        */
-       function bbcode_second_pass(&$message, $bbcode_uid = '', $bbcode_bitfield = false)
+       function bbcode_second_pass(&$message, $bbcode_uid = '', $bbcode_bitfield = false, $bbcode_is_sig = false)
        {
                if ($bbcode_uid)
                {
@@ -110,6 +111,13 @@
                                                }

                                                $message = preg_replace($preg['search'], $preg['replace'], $message);
+
+                                               /*
+                                                * 2010.06.10 add search nofollow module by appleboy
+                                                */
+                                               $replace = ($bbcode_is_sig === true) ? 'rel="external nofollow"' : '';
+                                               $message = preg_replace("/\{NOFOLLOW\}/i", $replace, $message);
+
                                                $preg = array('search' => array(), 'replace' => array());
                                        }
                                }</pre>

<span style="color:green">styles/Moztw-2009-1.0.6/template/bbcode.html</span> 

<pre class="brush: diff; title: ; notranslate" title="">--- phpBB3/styles/subsilver2/template/bbcode.html       2010-03-06 04:37:24.000000000 +0800
+++ www/styles/Moztw-2009-1.0.6/template/bbcode.html    2010-06-10 17:20:32.000000000 +0800
@@ -52,7 +52,7 @@

 <!-- BEGIN img -->

<img src="{URL}" alt="{L_IMAGE}" /><!-- END img -->

-

<!-- BEGIN url -->

<a href="{URL}" class="postlink">{DESCRIPTION}</a><!-- END url -->
+

<!-- BEGIN url -->&lt;a href="{URL}" class="postlink" {NOFOLLOW}>{DESCRIPTION}&lt;/a>

<!-- END url -->

 

<!-- BEGIN email -->

<a href="mailto:{EMAIL}">{DESCRIPTION}</a><!-- END email --></pre>

<span style="color:green">www/viewtopic.php</span> 

<pre class="brush: diff; title: ; notranslate" title="">--- phpBB3/viewtopic.php        2010-03-06 04:37:23.000000000 +0800
+++ www/viewtopic.php   2010-06-10 20:27:06.000000000 +0800
@@ -1342,7 +1278,8 @@

                if ($user_cache[$poster_id]['sig_bbcode_bitfield'])
                {
-                       $bbcode->bbcode_second_pass($user_cache[$poster_id]['sig'], $user_cache[$poster_id]['sig_bbcode_uid'], $user_cache[$pos
ter_id]['sig_bbcode_bitfield']);
+                       // 2010.06.10 add search nofollow module by appleboy
+                       $bbcode->bbcode_second_pass($user_cache[$poster_id]['sig'], $user_cache[$poster_id]['sig_bbcode_uid'], $user_cache[$pos
ter_id]['sig_bbcode_bitfield'], true);
                }

                $user_cache[$poster_id]['sig'] = bbcode_nl2br($user_cache[$poster_id]['sig']);</pre>

 [1]: http://forum.moztw.org/
 [2]: http://www.google.com/support/webmasters/bin/answer.py?hl=b5&answer=96569
 [3]: http://www.phpbb.com/