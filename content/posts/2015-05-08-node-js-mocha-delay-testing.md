---
title: Node.js Mocha 延遲測試
author: appleboy
type: post
date: 2015-05-08T01:24:30+00:00
url: /2015/05/node-js-mocha-delay-testing/
dsq_thread_id:
  - 3745923993
categories:
  - javascript
  - NodeJS
tags:
  - Mocha
  - Node.js
  - Testing

---
<div style="margin:0 auto; text-align:center">
  <a href="https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2015/05/687474703a2f2f662e636c2e6c792f6974656d732f336c316b306e32413155334d3149314c323130702f53637265656e25323053686f74253230323031322d30322d32342532306174253230322e32312e3433253230504d2e706e67.png"><img src="https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2015/05/687474703a2f2f662e636c2e6c792f6974656d732f336c316b306e32413155334d3149314c323130702f53637265656e25323053686f74253230323031322d30322d32342532306174253230322e32312e3433253230504d2e706e67-300x134.png?resize=300%2C134" alt="687474703a2f2f662e636c2e6c792f6974656d732f336c316b306e32413155334d3149314c323130702f53637265656e25323053686f74253230323031322d30322d32342532306174253230322e32312e3433253230504d2e706e67" class="aligncenter size-medium wp-image-5729" srcset="https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2015/05/687474703a2f2f662e636c2e6c792f6974656d732f336c316b306e32413155334d3149314c323130702f53637265656e25323053686f74253230323031322d30322d32342532306174253230322e32312e3433253230504d2e706e67.png?resize=300%2C134&ssl=1 300w, https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2015/05/687474703a2f2f662e636c2e6c792f6974656d732f336c316b306e32413155334d3149314c323130702f53637265656e25323053686f74253230323031322d30322d32342532306174253230322e32312e3433253230504d2e706e67.png?w=500&ssl=1 500w" sizes="(max-width: 300px) 85vw, 300px" data-recalc-dims="1" /></a>
</div>

如果大家有在寫 [Node.js Express Framework][1]，一定對 [Mocha][2] Unit Testing 不陌生，`各位工程師不要太相信自己寫的程式碼`，產品上線前，務必要把 Unit Test 寫完整，如果是要 Code Refactor，那測試的重要性更是大。網站架構越來越大，功能越來越多，每寫一個新功能，都會產生 side effect，造成其他程式或邏輯出錯，這時候就需要 Unit Test 來驗證邏輯的正確性。使用 Express 寫 API 我個人會建議使用 [Supertest][3] + [Should.js][4] 來驗證後端程式碼即可，這幾套框架都是由 [TJ Holowaychuk][5] 完成。使用 supertest 也可以讓 express 不用 listen port 就可以測試。

<!--more-->

在 Express 內如果有寫 Async 程式，在測試過程中，這時候測試最後會先拿到 response，Async 部分尚未處理完，這時就會驗證失敗，要避免錯誤驗證，解決方式就是在測試過程中使用 delay time，延遲幾秒後才開始測試。底下範例可以在測試內延遲幾秒再繼續測試。

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">it('enable device mobile if post same data again.', function(done) {
  DeviceMobileRels.scope('deleted').find({
    where: {
      deviceId: deviceId,
      mobileId: mobileId
    }
  }).then(function(mobile){
    should.exist(mobile);
    return request(mcs)
      .post('/xxxxxx/xxxxxxxx')
      .set('Accept', 'application/json')
      .expect(200)
      .expect('Content-Type', /json/);
  }).then(function() {
    // delay 900ms to test
    setTimeout(function () {
      return DeviceMobileRels.find({
        where: {
          deviceId: deviceId,
          mobileId: mobileId
        }
      }).then(function(mobile){
        should.exist(mobile);
        done();
      });
    }, 900);
  });
});</pre>
</div>

每一個測試時間都必須在 2000ms 內完成，如果測試 delay 時間需要延遲超過兩秒，請務必在最前面補上 `this.timeout(1000);` 單位是毫秒。

 [1]: http://expressjs.com/
 [2]: http://mochajs.org/
 [3]: https://github.com/visionmedia/supertest
 [4]: https://github.com/tj/should.js/
 [5]: https://github.com/tj