---
title: '[jQuery] AjaxFileUpload : Multiple File Upload plugin'
author: appleboy
type: post
date: 2010-04-13T06:42:48+00:00
url: /2010/04/jquery-ajaxfileupload-multiple-file-upload-plugin/
views:
  - 13446
bot_views:
  - 527
dsq_thread_id:
  - 246707115
categories:
  - javascript
  - jQuery
tags:
  - javascript
  - jQuery

---
最近 survey 一些 AJAX upload plugin by [jQuery][1]，或者是一些網路知名 upload opensource: [SWFUpload][2], 以及目前很強大的 [Plupload][3]，先來說明 <a href="http://www.phpletter.com/Demo/AjaxFileUpload-Demo/" target="_blank">AjaxFileUpload</a> 這個 jQuery Plugin 單一檔案上傳，如果想要簡單方便的單一上傳，我很推薦這個，搭配回傳的 json type 吐出錯誤訊息還蠻好用的，雖然作者給單一上傳的說明，不過還是可以將它改成多檔上傳，也就是多增加 input type="file" 就可以了，底下介紹一下怎麼實作單一檔案或者是多檔案上傳。 

### 單一檔案上傳 先 include AjaxFileUpload javascript 

<pre class="brush: xml; title: ; notranslate" title=""></pre> html: 

<pre class="brush: xml; title: ; notranslate" title=""></pre> jQuery code: 

<pre class="brush: jscript; title: ; notranslate" title="">function ajaxFileUpload()
{
	//這部份可以省略，或者是撰寫當 ajax 開始啟動需讀取圖片，完成之後移除圖片
	$("#loading")
	.ajaxStart(function(){
		$(this).show();
	})
	.ajaxComplete(function(){
		$(this).hide();
	});
	
  /*
    prepareing ajax file upload
    url: the url of script file handling the uploaded files
    fileElementId: the file type of input element id and it will be the index of  $_FILES Array()
    dataType: it support json, xml
    secureuri:use secure protocol
    success: call back function when the ajax complete
    error: callback function when the ajax failed
  */
	$.ajaxFileUpload
	(
		{
			url:'doajaxfileupload.php', 
			secureuri:false,
			fileElementId:'fileToUpload',
			dataType: 'json',
			success: function (data, status)
			{
				if(typeof(data.error) != 'undefined')
				{
					if(data.error != '')
					{
						alert(data.error);
					}else
					{
						alert(data.msg);
					}
				}
			},
			error: function (data, status, e)
			{
				alert(e);
			}
		}
	)
	
	return false;

}</pre> 注意 fileElementId 對應到 input file 裡面的 ID 值，取 name 是後端程式需要用到，例如 PHP $_FILES，後端處理回傳 json Type 給 jQuery 處理，json 格式： 

<pre class="brush: jscript; title: ; notranslate" title="">{
  "error" : 'test',
  "msg" : 'upload completed'
}</pre> 這樣大致上ok了。如果要多檔案上傳，其實就是改 jQuery 部份：html 部份請加上多個 input file 

### 多重檔案上傳

<pre class="brush: xml; title: ; notranslate" title=""></pre> jQuery 部份改成： 

<pre class="brush: jscript; title: ; notranslate" title="">$().ready(function() {  
    $('#uploadfile').click(function(){      
      $('input:file').each(function(){		  
        $.ajaxFileUpload
    		(
    			{
    				url:'doajaxfileupload.php', 
    				secureuri:false,
    				fileElementId: $(this).attr('id'),
    				dataType: 'json',
    				success: function (data, status)
    				{
  						if(data.error != '')
  						{
  							alert(data.error);
  						}else
  						{
  							alert(data.msg);
  						}
    				},
    				error: function (data, status, e)
    				{
    					alert(e);
    				}
    			}
    		); 
     });
     
    });
  });
</pre> 另外也可以參考 jQuery Plugin: 

[jQuery Multiple File Upload Plugin v1.47][4]

 [1]: http://jquery.com/
 [2]: http://www.swfupload.org/
 [3]: http://www.plupload.com/index.php
 [4]: http://www.fyneworks.com/jquery/multiple-file-upload/