---
title: Laravel Presenter 在 Controller 的使用
author: appleboy
type: post
date: 2015-09-04T01:28:48+00:00
url: /2015/09/how-to-use-laravel-presenter-in-controller/
dsq_thread_id:
  - 4095456224
categories:
  - javascript
  - Laravel
  - php
  - React
tags:
  - Facebook React
  - Laravel
  - Laravel Presenter
  - ReactJS

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

[Laravel Auto Presenter][1] 是一套用在 view 裡的 decorates objects，搭配資料庫時，如果有需要組合或整合欄位來顯示相關資訊，這套就非常適合使用在 [Laravel][2] View 裡，如果不是透過 Laravel Auto Presenter，開發者也可以利用 [Laravel Accessors & Mutators][3] 來實現這方法，只是這要寫在 Model 層，寫法如下，此做法寫起來蠻亂的，而且也並不是每個地方都需要擴充這些欄位。

<div>
  <pre class="brush: php; title: ; notranslate" title="">/**
 * The accessors to append to the model's array form.
 *
 * @var array
 */
protected $appends = [
    'is_twitter',
];

/**
 * Get the user's is_twitter flag.
 *
 * @param  string  $value
 * @return string
 */
public function getIsTwitterAttribute()
{
    return (bool) ($this->attributes['options'] & self::$OPTIONS['is_twitter']);
}</pre>
</div>

<!--more-->

如果是使用 Laravel Auto Presenter 則寫法如下

<div>
  <pre class="brush: php; title: ; notranslate" title=""><?php  namespace App\Models\Presenters;

use App\Models\User;
use Illuminate\Contracts\Support\Arrayable;
use McCool\LaravelAutoPresenter\BasePresenter;

class UserPresenter extends BasePresenter implements Arrayable
{
    public function __construct(User $resource)
    {
        $this->wrappedObject = $resource;
    }

    public function isTwitter()
    {
        return (bool) ($this->wrappedObject->info->options & self::$OPTIONS['is_twitter']);
    }

    /**
     * Get the instance as an array.
     *
     * @return array
     */
    public function toArray()
    {
        return [
            'id'        => $this->wrappedObject->id,
            'isTwitter' => $this->isTwitter(),
            'avatarUrl' => $this->avatarUrl(),
        ];
    }
}</pre>
</div>

但是使用在 Laravel View 裡面都可以正確拿到 `isTwitter` 欄位沒問題，如果要用在 RESTFul + 前端 [ReactJS][4] 的話，則要透過 Laravel Facades 來實現，加上 `AutoPresenter::decorate` 就可以在 Controller 內使用 AutoPresenter 了。

<div>
  <pre class="brush: php; title: ; notranslate" title=""><?php

use McCool\LaravelAutoPresenter\Facades\AutoPresenter;

class MessageController extends Controller
{
    /**
     * @var Repository
     */
    private $user;

    public function __construct(UserRepository $user)
    {
        $this->user = $user;
    }

    public function index(Request $request)
    {
        $user = $this->user->with('info')->find(\Auth::id());
        $state = collect([
            'user' => AutoPresenter::decorate($user),
        ]);

        return $state;
    }
}</pre>
</div>

 [1]: https://github.com/laravel-auto-presenter/laravel-auto-presenter
 [2]: http://laravel.com/
 [3]: http://laravel.com/docs/5.1/eloquent-mutators#accessors-and-mutators
 [4]: http://facebook.github.io/react/