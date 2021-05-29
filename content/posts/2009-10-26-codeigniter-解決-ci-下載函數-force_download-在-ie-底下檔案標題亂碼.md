---
title: '[CodeIgniter] 解決 CI 下載函數 force_download 在 IE 底下檔案標題亂碼'
author: appleboy
type: post
date: 2009-10-26T06:21:43+00:00
url: /2009/10/codeigniter-解決-ci-下載函數-force_download-在-ie-底下檔案標題亂碼/
views:
  - 4605
bot_views:
  - 1037
dsq_thread_id:
  - 246815540
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
<img src="https://i2.wp.com/codeigniter.com/images/design/ci_logo2.gif?w=840" alt="CodeIgniter" data-recalc-dims="1" /> [CodeIgniter][1] 底下提供了 [force_download][2] 函數，讓使用者可以直接下載檔案，但是會遇到中文的問題，[IE][3] 底下開起來檔名會是亂碼，force_download('filename', 'data') 如果 filename 使用中文，測試 [FireFox][4] 跟 [Chrome][5] 都是沒問題的，唯獨 IE 開起來就是有問題，所以麻煩請修改 <span style="color: #008000;"><strong>helpers/download_helper.php </strong></span> 這隻程式。 

<pre class="brush: php; title: ; notranslate" title="">if ( ! function_exists('force_download'))
{
	function force_download($filename = '', $data = '')
	{
		if ($filename == '' OR $data == '')
		{
			return FALSE;
		}

		// Try to determine if the filename includes a file extension.
		// We need it in order to set the MIME type
		if (FALSE === strpos($filename, '.'))
		{
			return FALSE;
		}
	
		// Grab the file extension
		$x = explode('.', $filename);
		$extension = end($x);

		// Load the mime types
		@include(APPPATH.'config/mimes'.EXT);
	
		// Set a default mime if we can't find it
		if ( ! isset($mimes[$extension]))
		{
			$mime = 'application/octet-stream';
		}
		else
		{
			$mime = (is_array($mimes[$extension])) ? $mimes[$extension][0] : $mimes[$extension];
		}
	
		// Generate the server headers
		if (strstr($_SERVER['HTTP_USER_AGENT'], "MSIE"))
		{
			header('Content-Type: "'.$mime.'"');
			header('Content-Disposition: attachment; filename="'.iconv('utf-8', 'big5', $filename).'"');
			header('Expires: 0');
			header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
			header("Content-Transfer-Encoding: binary");
			header('Pragma: public');
			header("Content-Length: ".strlen($data));
		}
		else
		{
			header('Content-Type: "'.$mime.'"');
			header('Content-Disposition: attachment; filename="'.$filename.'"');
			header("Content-Transfer-Encoding: binary");
			header('Expires: 0');
			header('Pragma: no-cache');
			header("Content-Length: ".strlen($data));
		}
	
		exit($data);
	}
}</pre> 裡面利用了 iconv 把 utf-8 編碼，改成 big5，這樣在 IE 底下就不會出現問題了 

<pre class="brush: php; title: ; notranslate" title="">header('Content-Disposition: attachment; filename="'.iconv('utf-8', 'big5', $filename).'"');</pre>

 [1]: http://codeigniter.com/
 [2]: http://codeigniter.com/user_guide/helpers/download_helper.html
 [3]: http://www.microsoft.com/taiwan/windows/internet-explorer/
 [4]: http://moztw.org/firefox/
 [5]: http://www.google.com/chrome/