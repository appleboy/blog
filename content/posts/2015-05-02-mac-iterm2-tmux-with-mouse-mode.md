---
title: Mac iTerm2 + tmux 搭配 Mouse mode
author: appleboy
type: post
date: 2015-05-02T02:56:00+00:00
url: /2015/05/mac-iterm2-tmux-with-mouse-mode/
dsq_thread_id:
  - 3729513655
categories:
  - Mac
tags:
  - Github
  - iTerm2
  - Mac
  - tmux

---
[<img src="https://i0.wp.com/farm8.staticflickr.com/7708/17151857929_cd5bd6c97b_z.jpg?resize=640%2C368&#038;ssl=1" alt="Screen Shot 2015-05-02 at 10.17.10 AM" data-recalc-dims="1" />][1]

在 Mac 上必裝 [iTerm2][2] 終端機軟體搭配 copy mode 相當好用，只要用滑鼠選擇了一段文字，系統就會自動幫忙 copy，接著在任何地方就可以直接使用 `command + v` 貼上，如果要多視窗操作，可以安裝 [tmux][3] 多視窗軟體，如果使用了 tmux 你會發現滾輪滑鼠無法使用了，也就是看不到執行過的畫面跟指令，這時候就要調整 tmux 設定檔，補上 [Mouse mode 設定檔][4]

<!--more-->

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># Mouse mode

set -g mode-mouse on
set -g mouse-resize-pane on
set -g mouse-select-pane on
set -g mouse-select-window on</pre>
</div>

使用上述的 mouse mode 後會發現原本 copy mode 又不能使用了，這時候我想到的解法就是透過 tmux bind key 功能，隨時可以將 mouse mode 關掉，讓原本的滑鼠可以使用 copy mode，底下是 [bind key 做法][4]

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># Toggle mouse on
bind m \
  set -g mode-mouse on \;\
  set -g mouse-resize-pane on \;\
  set -g mouse-select-pane on \;\
  set -g mouse-select-window on \;\
  display 'Mouse: ON'

# Toggle mouse off
bind M \
  set -g mode-mouse off \;\
  set -g mouse-resize-pane off \;\
  set -g mouse-select-pane off \;\
  set -g mouse-select-window off \;\
  display 'Mouse: OFF'</pre>
</div>

這時候使用者可以透過 `ctrl + a + M` 來關閉 mouse mode，但是總覺得這方式還是有點麻煩，所以找了一下 stackoverflow 的解法，發現有[快速鍵可以解決此問題][5]，在 tmux 底下使用 mouse mode 如果要複製文字，可以先按下 `option 鍵 + 滑鼠選取文字`，這樣就可以了，終於可以不用透過 bind key 來關閉 mouse mode 了。

在我的 [dotfiles Github repo][6] 內有 [.tmux.conf][7] 設定檔可以給大家參考，tmux 快速鍵可以直接參考網路上整理好的 [tmux shortcuts & cheatsheet][8]。

 [1]: https://www.flickr.com/photos/appleboy/17151857929 "Screen Shot 2015-05-02 at 10.17.10 AM by Bo-Yi Wu, on Flickr"
 [2]: http://iterm2.com/
 [3]: http://tmux.sourceforge.net/
 [4]: https://github.com/appleboy/dotfiles/blob/master/.tmux.conf#L77-L82
 [5]: https://stackoverflow.com/questions/12287432/how-to-copy-to-system-clipboard-from-tmux-output-after-mouse-selection/19843650#19843650
 [6]: https://github.com/appleboy/dotfiles
 [7]: https://github.com/appleboy/dotfiles/blob/master/.tmux.conf
 [8]: https://gist.github.com/MohamedAlaa/2961058