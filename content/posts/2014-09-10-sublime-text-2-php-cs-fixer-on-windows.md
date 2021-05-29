---
title: 在 Windows 上安裝 Sublime Text 2 搭配 PHP-CS-Fixer 套件
author: appleboy
type: post
date: 2014-09-10T08:16:33+00:00
url: /2014/09/sublime-text-2-php-cs-fixer-on-windows/
dsq_thread_id:
  - 3004475436
categories:
  - php
tags:
  - php-cs-fixer
  - php-fig
  - Sublime Text

---
**Note: 2014.12.22 PHP-CS-Fixer 不支援 `"--level": "all"` 設定了**

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/13007892705/" title="Sublime_Text_Logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm8.staticflickr.com/7458/13007892705_062066d2ab_m.jpg?resize=240%2C240&#038;ssl=1" alt="Sublime_Text_Logo" data-recalc-dims="1" /></a>
</div>

由於近幾年來 [PHP-Fig][1] 發佈 PSR-0 ~ PSR-4 標準，所以在撰寫 PHP 程式碼時，請依照標準，而為了符合這標準，[@fabpot][2] 寫了一個轉換工具叫 [PHP-CS-Fixer][3] (PHP Coding Standards Fixer) 最主要目的是按照 [PSR-1][4] and [PSR-2][5] 的 Coding Style，只要透過 command 就可以將程式碼轉成標準格式。此篇要紀錄在 Windows 搭配 [Sublime Text][6] 安裝 PHP-CS-Fixer。

在 Sublime 編輯器可以使 `ctrl + shift + p` 後選 `Install package` 找到 `PHPCs` 點下安裝即可。打開 `Preferences` -> `Package settings` -> `PHP Code Sniffer` -> `Settings`，裡面把相關路徑補上去即可。底下是參考設定

<!--more-->

<div>
  <pre class="brush: bash; title: ; notranslate" title="">{
    // Plugin settings

    // Turn the debug output on/off
    "show_debug": true,

    // Which file types (file extensions), do you want the plugin to
    // execute for
    "extensions_to_execute": ["php"],

    // Do we need to blacklist any sub extensions from extensions_to_execute
    // An example would be ["twig.php"]
    "extensions_to_blacklist": [],

    // Execute the sniffer on file save
    "phpcs_execute_on_save": true,

    // Show the error list after save.
    "phpcs_show_errors_on_save": true,

    // Show the errors in the gutter
    "phpcs_show_gutter_marks": true,

    // Show outline for errors
    "phpcs_outline_for_errors": true,

    // Show the errors in the status bar
    "phpcs_show_errors_in_status": true,

    // Show the errors in the quick panel so you can then goto line
    "phpcs_show_quick_panel": true,

    // The path to the php executable.
    // Needed for windows, or anyone who doesn't/can't make phars
    // executable. Avoid setting this if at all possible
    "phpcs_php_prefix_path": "C:\\xampp\\php\\php.exe",

    // Options include:
    // - Sniffer
    // - Fixer
    // - Mess Detector
    //
    // This will prepend the application with the path to php
    // Needed for windows, or anyone who doesn't/can't make phars
    // executable. Avoid setting this if at all possible
    "phpcs_commands_to_php_prefix": ["Fixer"],

    // What color to stylise the icon
    // https://www.sublimetext.com/docs/3/api_reference.html#sublime.View
    // add_regsions
    "phpcs_icon_scope_color": "comment",

    // PHP_CodeSniffer settings

    // Do you want to run the phpcs checker?
    "phpcs_sniffer_run": true,

    // Execute the sniffer on file save
    "phpcs_command_on_save": false,

    // It seems python/sublime cannot always find the phpcs application
    // If empty, then use PATH version of phpcs, else use the set value
    "phpcs_executable_path": "C:\\xampp\\php\\phpcs.bat",

    // Additional arguments you can specify into the application
    //
    // Example:
    // {
    //     "--standard": "PEAR",
    //     "-n"
    // }
    "phpcs_additional_args": {
        "--standard": "PSR2",
        "-n": ""
    },

    // PHP-CS-Fixer settings

    // Fix the issues on save
    "php_cs_fixer_on_save": true,

    // Show the quick panel
    "php_cs_fixer_show_quick_panel": true,

    // Path to where you have the php-cs-fixer installed
    "php_cs_fixer_executable_path": "C:\\xampp\\php\\php-cs-fixer.phar",

    "php_cs_fixer_additional_args": {
        "--level": "psr2"
    },

    // PHP Linter settings

    // Are we going to run php -l over the file?
    "phpcs_linter_run": true,

    // Execute the linter on file save
    "phpcs_linter_command_on_save": true,

    // It seems python/sublime cannot always find the php application
    // If empty, then use PATH version of php, else use the set value
    "phpcs_php_path": "",

    // What is the regex for the linter? Has to provide a named match for 'message' and 'line'
    "phpcs_linter_regex": "(?P<message>.*) on line (?P<line>\\d+)",

    // PHP Mess Detector settings

    // Execute phpmd
    "phpmd_run": false,

    // Execute the phpmd on file save
    "phpmd_command_on_save": true,

    // It seems python/sublime cannot always find the phpmd application
    // If empty, then use PATH version of phpmd, else use the set value
    "phpmd_executable_path": "",

    // Additional arguments you can specify into the application
    //
    // Example:
    // {
    //     "codesize,unusedcode"
    // }
    "phpmd_additional_args": {
        "codesize,unusedcode,naming": ""
    },

    // PHP Scheck settings

    // Execute scheck
    "scheck_run": false,

    // Execute the scheck on file save
    "scheck_command_on_save": false,

    // It seems python/sublime cannot always find the scheck application
    // If empty, then use PATH version of scheck, else use the set value
    "scheck_executable_path": "",

    // Additional arguments you can specify into the application
    //
    //Example:
    //{
    //  "-php_stdlib" : "/path/to/pfff",
    //  "-strict" : ""
    //}
    "scheck_additional_args": {
        "-strict" : ""
    }
}
</pre>
</div>

這裡面需要注意的是底下參數

<div>
  <pre class="brush: bash; title: ; notranslate" title="">
"phpcs_php_prefix_path": "C:\\xampp\\php\\php.exe",
"phpcs_commands_to_php_prefix": ["Fixer"],
"phpcs_executable_path": "C:\\xampp\\php\\phpcs.bat",
"php_cs_fixer_executable_path": "C:\\xampp\\php\\php-cs-fixer.phar",
"php_cs_fixer_on_save": true,</pre>
</div>

如果發現沒作用，請打開 sublime console 介面，請直接按快速鍵 `ctrl + ~` 就可以看到哪邊設定錯誤。

 [1]: http://www.php-fig.org/
 [2]: https://github.com/fabpot
 [3]: http://cs.sensiolabs.org/
 [4]: http://www.php-fig.org/psr/psr-1/
 [5]: http://www.php-fig.org/psr/psr-2/
 [6]: http://www.sublimetext.com/