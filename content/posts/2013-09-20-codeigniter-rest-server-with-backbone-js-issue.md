---
title: CodeIgniter REST Server with Backbone.js Issue
author: appleboy
type: post
date: 2013-09-20T04:20:20+00:00
url: /2013/09/codeigniter-rest-server-with-backbone-js-issue/
dsq_thread_id:
  - 1779534896
categories:
  - AJAX
  - Backbone.js
  - CodeIgniter
  - javascript
  - php
tags:
  - Backbone.js
  - CodeIgniter
  - REST

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 如果有在用 

<a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a> 來當作 <a href="http://en.wikipedia.org/wiki/Representational_state_transfer" target="_blank">REST</a> Server 的朋友們，我相信都會找到 <a href="http://philsturgeon.co.uk/" target="_blank">philsturgeon</a> 所寫的 <a href="https://github.com/philsturgeon/codeigniter-restserver" target="_blank">codeigniter-restserver</a>，此套件幫你完成底層 API Response 動作，讓你可以輕易處理 REST URL。但是如果拿這套程式碼來搭配 <a href="http://backbonejs.org/" target="_blank">Backbone.js</a> 你會遇到拿不到 POST 或 PUT 變數問題，作者來一一描述。 <!--more--> 使用 Backbone.js 來取代 jQuery AJAX 方式來跟 REST Server 溝通，當然 Backbone.js 底層還是透過 jQuery AJAX API 來傳遞，首先我們建立一個簡易的 Backbone model 

<pre class="brush: jscript; title: ; notranslate" title="">// a simple backbone model
var User = Backbone.Model.extend({
    urlRoot: '/user',
    defaults:{
        'name':'appleboy',
        'age': 31
    }
});
var user1 = new User();
var user2 = new User();
var user3 = new User();
</pre> 你可以建立多個使用者，或是搭配 Backbone Collection 來顯示，到這邊是沒有問題，接著要跟伺服器做 GET PUT POST DELETE 的動作，也就是透過底下 Backbone 操作 

<pre class="brush: jscript; title: ; notranslate" title="">user1.fetch() // get user data
user1.save() // create or update user
user1.destroy() // delete user</pre> 這邊就會是問題所在，你會發現 backbone 丟給 REST request 的內容不會是像 jQuery AJAX 包在 parameter 內，而是在 

<span style="color:red">Request Payload</span> 內寫入 **<span style="color:green">{'name':'appleboy', 'age': 31}</span>**，所以我們在 REST Server 會一直存取不到任何資料 

<pre class="brush: php; title: ; notranslate" title="">class User extends REST_Controller
{
    public function index_get()
    {
        echo $this->get(null);
    }

    public function index_post()
    {
        echo $this->post(null);
    }

    public function index_put()
    {
        echo $this->put(null);
    }

    public function index_delete($id)
    {
        echo $this->put(null);
    }
}</pre> 問題出在 REST_Controller.php 處理 POST 函數 

<pre class="brush: php; title: ; notranslate" title="">/**
 * Parse POST
 */
protected function _parse_post()
{
    $this->_post_args = $_POST;

    $this->request->format and $this->request->body = file_get_contents('php://input');
}</pre> 只要將上面函數改成 

<pre class="brush: php; title: ; notranslate" title="">/**
* Parse POST
*/
protected function _parse_post()
{
    $this->_post_args = $_POST;

    $this->request->format and $this->request->body = file_get_contents('php://input');

    if (!empty($this->request->body)) {
        $this->_post_args = array_merge($_POST, json_decode($this->request->body, true));
    }
}</pre> 這樣 POST 就沒有問題了，接著如果 PUT 或 DELETE 也遇到此問題，就按照上述改相關函式。晚點發 pull request 給作者，只是不知道作者會啥時處理。