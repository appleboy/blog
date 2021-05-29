---
title: '[blog] wordpress外掛 Def-Link'
author: appleboy
type: post
date: 2007-02-05T16:11:58+00:00
url: /2007/02/blog-wordpress外掛-def-link/
views:
  - 3273
bot_views:
  - 1022
dsq_thread_id:
  - 262899199
categories:
  - blog
  - wordpress

---
這個外掛是我非常想要的，因為每次再寫文章的時候，如果要加上Link的話，很麻煩，還要自己手動增加，所以我就在網路上找到了一篇　[**[文章編輯]自動轉換特定文字為鍊結**][1]　這一篇有介紹了一些WordPress的外掛，當然我最喜歡簡單的外掛Def-Link這個外掛，重點是他很容易，又很好用

<!--more-->

  * 安裝方式  
    > **Compatibility**
    > 
    >   * WordPress 1.5 or later
    > 
    > **Installation**
    > 
    >   1. Download the plugin (v. 1.4): <a href="http://www.bedeng.com/downloads/def-link.php.txt" target="_blank"><font color="#de3a3a">def_link.php.txt</font></a> and <a href="http://www.bedeng.com/downloads/def-link-manage.php.txt" target="_blank"><font color="#de3a3a">def_link-manage.php.txt</font></a>
    >   2. Rename def-link.php.txt to def-link.php and put it into <font color="#0000ff"><strong><br /> wp-content/plugins/</strong></font> directory
    >   3. Rename def-link-manage.php.txt to def_link-manage.php and put it into  
    >     <font color="#0000ff"><strong>wp-admin/ </strong></font>directory
    >   4. Activate the plugin from WordPress administration menu.
    > 
    > **Usage**
    > 
    >   * Enter menu Administration->Manage->Def-Link You can add, edit or delete the definition, link or custom here

不過話說剛開始安裝好的時候，並不支援中文，只支援英文，所以我在網路上找到下面一篇文章

<a title="http://wordpress.org/" style="cursor: help; border-bottom: #000000 1px dashed" href="http://wordpress.org/" target="_blank">WordPress</a> Plugin: <a title="http://riyo.bedeng.com/2006/02/23/wp-plugin-def-link/" style="cursor: help; border-bottom: #000000 1px dashed" href="http://riyo.bedeng.com/2006/02/23/wp-plugin-def-link/" target="_blank">Def-Link</a> 中文的兼容性 : [連結][2]

不過他這個方法不適合用在 WordPress 2.0.7

所以我自己修改如下

<pre class="brush: php; title: ; notranslate" title="">#編輯 def-link.php 中
$ccompare="\b$odl->cname\b";
#替換成
$ccompare=$odl->cname;
#找到：
$ccompare="/\b".$achange[$m][name]."\b/i";
#替換成：
$ccompare="/".$achange[$m][name]."/i";
</pre>

[patch檔案][3] 

<pre class="brush: diff; title: ; notranslate" title="">--- def-link.php.txt	2006-03-10 04:47:39.000000000 +0800
+++ def-link.php	2007-02-05 09:34:33.000000000 +0800
@@ -12,9 +12,9 @@
 	$sql = 'SELECT * FROM DefLink';
 	$query = mysql_query($sql);
 	$n=0; 
-//	if (mysql_num_rows($query)>0){
+	if (mysql_num_rows($query)>0){
 		while ($odl = mysql_fetch_object($query)){
-			$ccompare="\b$odl->cname\b";
+			$ccompare=$odl->cname;
 			if(preg_match("/$ccompare/i",strip_tags($intext))) {
 				$achange[$n][name]=$odl->cname;
 				$achange[$n][deflink]=$odl->cdeflink;
@@ -31,7 +31,7 @@
 	
 		$m=0;
 		while($m<$n) {
-			$ccompare="/\b".$achange[$m][name]."\b/i";	
+			$ccompare="/".$achange[$m][name]."/i";	
 				if($achange[$m][flag]==2) {
 					$a2[$m]=$achange[$m][deflink];
 					$intext= preg_replace("$ccompare","#%%$m%%#",$intext);
@@ -42,7 +42,7 @@
 		}	
 		$m=0;
 		while($m<$n) {
-			$ccompare="/\b".$achange[$m][name]."\b/i";	
+			$ccompare="/".$achange[$m][name]."/i";	
 				if($achange[$m][flag]==1) {
 					$a1[$m]="<a href=\"".$achange[$m][deflink]."\" target=\"_blank\">".$achange[$m][name]."</a>";
 					$intext= preg_replace("$ccompare","@%%$m%%@",$intext);
@@ -53,7 +53,7 @@
 		}	
 		$m=0;
 		while($m<$n) {
-			$ccompare="/\b".$achange[$m][name]."\b/i";	
+			$ccompare="/".$achange[$m][name]."/i";	
 				if($achange[$m][flag]==0) {
 					$intext= preg_replace("$ccompare","<a style=\"border-bottom: 1px dashed #000000; cursor: help;\" title=\"".$achange[$m][deflink]."\">".$achange[$m][name]."</a>",$intext);
 				}
@@ -72,7 +72,7 @@
 			$intext= preg_replace("/@%%$m%%@/",$a1[$m],$intext);			
 			$m++;
 		} 	
-//	}
+	}
 return $intext;
 }
 
@@ -104,10 +104,10 @@
 		// Create it if it's not there
         if ($results == 0){
             $sql = "CREATE TABLE `DefLink` (".
-				   "`nid` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,".
-				   "`cname` VARCHAR( 50 ) NOT NULL ,".
-				   "`cdeflink` VARCHAR( 255 ) NOT NULL ,".
-				   "`nflag` SMALLINT( 1 ) NOT NULL DEFAULT '0')";
+				   "`nid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,".
+				   "`cname` VARCHAR(50) NOT NULL ,".
+				   "`cdeflink` VARCHAR(255) NOT NULL ,".
+				   "`nflag` SMALLINT(1) NOT NULL DEFAULT '0', PRIMARY KEY (nid)) TYPE=InnoDB";
 			$results = $wpdb->query($sql);
         }
 }
@@ -132,4 +132,5 @@
 
 add_action('admin_menu', 'yo_AddToDefinitionsToManage');
 add_filter('the_content', 'yo_redefine');
</pre>

 [1]: http://www.robbin.cc/vb/showthread.php?t=103
 [2]: http://www.68age.com/blog/?p=107
 [3]: http://blog.wu-boy.com/diff-def-link.patch.txt