---
title: 升級 PHP Facebook SDK 到 4.0.x 版本
author: appleboy
type: post
date: 2014-07-24T09:11:12+00:00
url: /2014/07/upgrade-php-facebook-sdk-to-4-0-x/
dsq_thread_id:
  - 2869113045
categories:
  - CodeIgniter
  - Laravel
  - php
tags:
  - CodeIgniter
  - Composer
  - Facebook
  - Facebook SDK
  - php

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div>

最近幫公司建立 Staging 環境，申請了新的 [FB App][1] 來，用原本 [Facebook v3.2.3 SDK][2] 發現已經不能 work 了，去翻了 [Facebook Platform Changelog][3]，看到今年 4 月 30 號以後申請的 App 會強制走 v2.0 Auth 機制，所以原本用 php sdk 3.2.3 版本的話，完全無法呼叫 Auth 2.0 API，導致整個網站爛掉，當然線上的網站是不會隨意換 App ID 及 secret，免得怎麼爆掉的都不知道。這次來教學在 CodeIgniter 轉換 PHP Facebook SDK，可以直接參考[官方 4.0.0 的教學][4]，原本 3.2.3 版本直接下載程式碼，放到 library 目錄，直接 include 就可以取得 Facebook 個人資料，4.0.0 版本以後，請先確認系統是否升級為 PHP 5.4 版本以上，並且支援 [Composer][5] 安裝，當然如果不用 Composer 也可以，只是要 include 很多檔案，真的比較麻煩。

<!--more-->

先在根目錄建立 `composer.json` 內容填入

<div>
  <pre class="brush: bash; title: ; notranslate" title="">{
  "require" : {
    "facebook/php-sdk-v4" : "4.0.*"
  }
}</pre>
</div>

接著執行 `composer install`，系統會自動建立 vendor 目錄。在 `application/libraries` 建立 `lib_login.php` 檔案，並且寫入底下程式碼

<div>
  <pre class="brush: php; title: ; notranslate" title=""><?php  if (! defined('BASEPATH')) exit('No direct script access allowed');

/**
* Name: Facebook Login Library
*
* Author: appleboy
*
*/

require 'vendor/autoload.php';

use Facebook\FacebookSession;
use Facebook\FacebookRequest;
use Facebook\GraphUser;
use Facebook\FacebookRequestException;
use Facebook\FacebookRedirectLoginHelper;

class Lib_login
{
    /**
     * CodeIgniter global
     *
     * @var string
     **/
    protected $ci;

    /**
     * __construct
     *
     * @return void
     * @author Ben
     **/
    public function __construct()
    {
        $this->ci =& get_instance();
        $this->ci->load->library('session');
        $this->ci->config->load('facebook');

        if (! isset($_SESSION)) {
            session_start();
        }
    }

    public function facebook()
    {
        $facebook_default_scope = explode(',', $this->ci->config->item("facebook_default_scope"));
        $facebook_app_id = $this->ci->config->item("facebook_app_id");
        $facebook_api_secret = $this->ci->config->item("facebook_api_secret");

        // init app with app id and secret
        FacebookSession::setDefaultApplication($facebook_app_id, $facebook_api_secret);

        // login helper with redirect_uri
        $helper = new FacebookRedirectLoginHelper(site_url('login/facebook'));
        // see if a existing session exists
        if (isset($_SESSION) && isset($_SESSION['fb_token'])) {
            // create new session from saved access_token
            $session = new FacebookSession($_SESSION['fb_token']);

            // validate the access_token to make sure it's still valid
            try {
                if (!$session->validate()) {
                    $session = null;
                }
            } catch (Exception $e) {
                // catch any exceptions
                $session = null;
            }
        }

        if (!isset($session) || $session === null) {
            // no session exists

            try {
                $session = $helper->getSessionFromRedirect();
            } catch(FacebookRequestException $ex) {
                // When Facebook returns an error
                // handle this better in production code
                print_r($ex);
            } catch(Exception $ex) {
                // When validation fails or other local issues
                // handle this better in production code
                print_r($ex);
            }
        }

        // see if we have a session
        if (isset($session)) {
            // save the session
            $_SESSION['fb_token'] = $session->getToken();
            // create a session using saved token or the new one we generated at login
            $session = new FacebookSession($session->getToken());

            // graph api request for user data
            $request = new FacebookRequest($session, 'GET', '/me');
            $response = $request->execute();
            // get response
            $graphObject = $response->getGraphObject()->asArray();
            $fb_data = array(
                'me' => $graphObject,
                'loginUrl' => $helper->getLoginUrl($facebook_default_scope)
           );
            $this->ci->session->set_userdata('fb_data', $fb_data);

        } else {
            $fb_data = array(
                'me' => null,
                'loginUrl' => $helper->getLoginUrl($facebook_default_scope)
           );
            $this->ci->session->set_userdata('fb_data', $fb_data);
        }

        return $fb_data;
    }
}
</pre>
</div>

最後寫簡單 controller

<div>
  <pre class="brush: php; title: ; notranslate" title=""><?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Login extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->library(array('session', 'lib_login'));
    }

    /**
     * facebook login
     *
     * @return void
     * @author appleboy
     **/
    public function facebook()
    {
        $fb_data = $this->lib_login->facebook();

        // check login data
        if (isset($fb_data['me'])) {
            var_dump($fb_data);
        } else {
            echo '<a href="' . $fb_data['loginUrl'] . '">Login</a>';
        }
    }
}

/* End of file login.php */
/* Location: ./application/controllers/login.php */
</pre>
</div>

打開瀏覽器，直接執行 `http://xxxx/login/facebook` 就可以看到 Facebook 登入連結。所以程式碼都放在 [Github][6] 上 [codeigniter-facebook-php-sdk-v4][7]，歡迎取用。

 [1]: https://developers.facebook.com
 [2]: https://github.com/facebook/facebook-php-sdk
 [3]: https://developers.facebook.com/docs/apps/changelog
 [4]: https://developers.facebook.com/docs/php/gettingstarted/4.0.0
 [5]: https://getcomposer.org/
 [6]: https://github.com
 [7]: https://github.com/appleboy/codeigniter-facebook-php-sdk-v4