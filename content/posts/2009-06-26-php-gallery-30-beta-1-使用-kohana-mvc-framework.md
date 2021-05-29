---
title: '[PHP] Gallery 3.0 Beta 1 使用 Kohana MVC Framework'
author: appleboy
type: post
date: 2009-06-26T02:35:43+00:00
url: /2009/06/php-gallery-30-beta-1-使用-kohana-mvc-framework/
views:
  - 13528
bot_views:
  - 758
dsq_thread_id:
  - 246703835
categories:
  - CodeIgniter
  - php
  - Zend Framework
tags:
  - CodeIgniter
  - php

---
<img src="https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2009/06/logo.png?resize=329%2C131" alt="Gallery" title="Gallery" class="alignleft size-full wp-image-1487" srcset="https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2009/06/logo.png?w=329&ssl=1 329w, https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2009/06/logo.png?resize=300%2C119&ssl=1 300w" sizes="(max-width: 329px) 85vw, 329px" data-recalc-dims="1" /> [Gallery][1] 3.0 Beta 1 出來了，在 [roga’s blog][2]，看到這篇訊息，gallery 3 捨去 php smaty template engine，而改用 [Kohana MVC Framework][3] 這套 base on [CodeIgniter][4] 的 Framework，在 [Gallery3:FAQ][5] 裡面有提到為什麼會使用 Kohana 這套 MVC，gallery 團隊找尋了許多 MVC 的架構來幫助開發整個相簿系統，包含了 [CakePHP][6]、[Zend Framework][7]、[Prado][8]、[Symfony][9]、[CodeIgniter][10]，最後經過許多人的討論，選用了 Kohana 這套 MVC，原本打算考慮 CI 的，雖然 CI 支援 PHP4 跟 PHP5，以及它非常的小，對於效能方面也非常的好，但是並不支援 PHP5 的 exception，畢且有些少數的 Structure 只有支援 PHP4，所以就不被他們採納了，再來 Zend Framework 因為包含了 1705 個檔案，相當龐大，效能比 CI 少了 200-300%，雖然 ZF 文件相當豐富，不過沒有良好的 example 範例，所以導致 gallery 團隊遇到很多挫折，XDD。 最後選擇了 Kohana，雖然 Kohana 效能輸給 CI，不過這之間的差異極小，Kohana 也有 support PHP5 的 exception，Kohana 文件比 CI 還要少了些，不過對 gallery 團隊已經相當足夠了。底下有一篇各大 Framework 的效能比較：[PHP framework comparison benchmarks][11]，還有另一篇：[Kohana vs CodeIgniter: Speed and Memory Usage Performance Benchmark][12]

 [1]: http://gallery.menalto.com/
 [2]: http://blog.roga.tw/2009/06/10/2222
 [3]: http://www.kohanaphp.com/
 [4]: http://codeigniter.com
 [5]: http://codex.gallery2.org/Gallery3:FAQ#Why_did_you_choose_Kohana.3F
 [6]: http://cakephp.org/
 [7]: http://framework.zend.com/
 [8]: http://www.xisc.com/
 [9]: http://www.symfony-project.org/
 [10]: http://codeigniter.com/
 [11]: http://www.avnetlabs.com/php/php-framework-comparison-benchmarks
 [12]: http://www.beyondcoding.com/2008/03/25/kohana-vs-codeigniter-speed-and-memory-usage-performance-benchmark/