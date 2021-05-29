---
title: 統一開發者編輯器 Coding Style
author: appleboy
type: post
date: 2013-03-28T06:50:07+00:00
url: /2013/03/coding-style-tool-editorconfig/
dsq_thread_id:
  - 1169980030
categories:
  - www
tags:
  - Code Style
  - EditorConfig

---
在多人開發專案時候，一定會遇到大家使用的編輯器大不相同 <a href="http://macromates.com/" target="_blank">TextMate</a>, <a href="http://www.vim.org/" target="_blank">Vim</a>, <a href="http://www.sublimetext.com/" target="_blank">Sublime Text 2</a>, <a href="http://www.geany.org/" target="_blank">Geany</a>, <a href="http://notepad-plus-plus.org/" target="_blank">Notepad++</a>…等，該如何統一程式碼的一致性呢？這邊要講得不是各種語言的 Coding Style，而是編輯器的設定，例如大家一定會遇到有的開發者使用 Tab 另外一群人使用 Space，在同一專案裡面就會發現有的 tab 有的 space，這樣看起來非常的亂，該如何統一大家的預設 indent style，就是要使用 <a href="http://editorconfig.org/" target="_blank">EditorConfig</a> 啦。使用方式很簡單，可以在專案目錄內加入 .editorconfig 內容設定如下 

<pre class="brush: bash; title: ; notranslate" title="">; EditorConfig is awesome: http://EditorConfig.org

root = true ; top-most EditorConfig file

; Unix-style newlines with a newline ending every file
[*]
end_of_line = lf
insert_final_newline = true

; 4 space indentation
[*.py]
indent_style = space
indent_size = 4

; Tab indentation (no size specified)
[*.js]
indent_style = tab

; Indentation override for all JS under lib directory
[lib/**.js]
indent_style = space
indent_size = 2</pre> 設定方式真的很簡單，如果是 Makefile 可以加入底下 

<pre class="brush: bash; title: ; notranslate" title="">[Makefile]
indent_style = tab</pre> 設定完成，最後只要裝上編輯器的 Plugin 即可，可以

<a href="http://editorconfig.org/#download" target="_blank">參考這裡</a>，目前支援編輯器如下 

  * [Code::Blocks][1]
  * [Emacs][2]
  * [Geany][3]
  * [Gedit][4]
  * [jEdit][5]
  * [Notepad++][6]
  * [Sublime Text 2][7]
  * [TextMate][8]
  * [Vim][9]
  * [Visual Studio][10] 如果開發者沒有使用上面的編輯器，那可能需要請他更換了，或者是設定該編輯器設定了。

 [1]: https://github.com/editorconfig/editorconfig-codeblocks#readme
 [2]: https://github.com/editorconfig/editorconfig-emacs#readme
 [3]: https://github.com/editorconfig/editorconfig-geany#readme
 [4]: https://github.com/editorconfig/editorconfig-gedit#readme
 [5]: https://github.com/editorconfig/editorconfig-jedit#readme
 [6]: https://github.com/editorconfig/editorconfig-notepad-plus-plus#readme
 [7]: https://github.com/sindresorhus/editorconfig-sublime#readme
 [8]: https://github.com/Mr0grog/editorconfig-textmate#readme
 [9]: https://github.com/editorconfig/editorconfig-vim#readme
 [10]: https://github.com/editorconfig/editorconfig-visualstudio#readme