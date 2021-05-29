---
title: 使用 GraphQL Gateway 串接多個 Data Schema
author: appleboy
type: post
date: 2021-02-06T01:12:54+00:00
url: /2021/02/graphql-gateway-in-golang/
dsq_thread_id:
  - 8386140370
categories:
  - Golang
  - GraphQL
tags:
  - golang
  - GraphQL

---
[![infra][1]][1]

不久之前寫過一篇『[從 graphql-go 轉換到 gqlgen][2]』，目前團隊舊有的專案還是繼續用 [graphql-go][3] 來撰寫，不過之後需求量越來越大，維護 graphql-go 就越來越困難，故有在想怎麼把 [gqlgen][4] 跟 graphql-go 相容在一起，那就是把這兩個套件想成不同的服務，再透過 Gateway 方式完成 [single data graph][5]。至於怎麼選擇 GraphQL Gateway 套件，最容易的方式就是使用 [@apollo/gateway][6]，但是由於個人比較偏好 [Go 語言][7]的解決方案，就稍微找看看有無人用 Go 實現了 Gateway，後來找到 [nautilus/gateway][8]，官方有[提供文件][9]以及[教學 Blog][10] 可以供開發者參考。底下會教大家使用 nautilus/gateway 將兩個不同的服務串接在一起。

<!--more-->

## 線上影片

{{< youtube f4KM3RFx8ro >}}

  * 00:00​ 為什麼有 GraphQL Gateway 需求?
  * 02:16​ 用兩個 Routing 來區分 graphql-go 跟 gqlgen
  * 03:00​ 用 jwt token check
  * 03:40​ 選擇 GraphQL Gateway 套件
  * 04:58​ main.go 撰寫機制介紹
  * 06:05​ 如何將 Token 往後面 Service 發送?
  * 06:58​ 看看完整的程式代碼
  * 07:56​ 最後心得感想

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][11]
  * [一天學會 DevOps 自動化測試及部署][12]
  * [DOCKER 容器開發部署實戰][13]

如果需要搭配購買請直接透過 [FB 聯絡我][14]，直接匯款（價格再減 **100**）

## 整合 graphql-go + gqlgen

要把兩個不同的套件整合在一起，最簡單的方式就是分不同的 URL 區隔開來，兩邊都是透過 Bearer Token 來進行使用者身份確認。

<pre><code class="language-go">        g := e.Group("/graphql")
        g.Use(auth.Check())
        {
            g.POST("", graphql.Handler())
            if config.Server.GraphiQL {
                g.GET("", graphql.Handler())
            }
        }
        q := root.Group("/query")
        q.Use(auth.Check())
        {
            q.POST("", gqlgen.SchemaHandler())
            q.GET("", gqlgen.SchemaHandler())
        }</code></pre>

透過 jwt 驗證及讀取使用者資料

<pre><code class="language-go">// Check user bearer token
func Check() gin.HandlerFunc {
    return func(c *gin.Context) {
        if data, err := jwt.New().GetClaimsFromJWT(c); err != nil {
            c.Next()
        } else if id, ok := data["id"]; ok {
            var userID int64
            switch v := id.(type) {
            case int:
                userID = int64(v)
            case string:
                i, err := strconv.ParseInt(v, 10, 64)
                if err != nil {
                    log.Error().Err(err).Msg("can&#039;t convert user id to int64")
                }
                userID = i
            case float64:
                userID = int64(v)
            default:
                log.Info().Msgf("I don&#039;t know about user id type %T from token!", v)
            }

            user, err := model.GetUserByID(userID)
            if err != nil {
                log.Error().Err(err).Msg("can&#039;t get user data")
            }

            ctx := context.WithValue(
                c.Request.Context(),
                config.ContextKeyUser,
                user,
            )
            c.Request = c.Request.WithContext(ctx)
        }
    }
}</code></pre>

## 撰寫 graphql-gateway

使用 [nautilus/gateway][8] 可以簡單將 Schema 合併成單一 Data，不過此套件[尚未支援 subscription][15]。

<pre><code class="language-go">func main() {
    // default port
    port := "3001"
    server := "api:8080"
    if v, ok := os.LookupEnv("APP_PORT"); ok {
        port = v
    }

    if v, ok := os.LookupEnv("APP_SERVER"); ok {
        server = v
    }

    // introspect the apis
    schemas, err := graphql.IntrospectRemoteSchemas(
        "http://"+server+"/graphql",
        "http://"+server+"/query",
    )
    if err != nil {
        panic(err)
    }

    // create the gateway instance
    gw, err := gateway.New(schemas, gateway.WithMiddlewares(forwardUserID))
    if err != nil {
        panic(err)
    }

    // add the playground endpoint to the router
    http.HandleFunc("/graphql", withUserInfo(gw.PlaygroundHandler))

    // start the server
    fmt.Printf("🚀 Gateway is ready at http://localhost:%s/graphql\n", port)
    err = http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
    if err != nil {
        fmt.Println(err.Error())
        os.Exit(1)
    }
}</code></pre>

由於之後要整合進 Docker 內，故透過 LookupEnv 來決定 Server 跟 Port。這樣可以將 `/graphql` 及 `/query` 的 Schema 綁定在一起了。另外要解決的就是如何將 Authorization 傳到後面 GraphQL Server 進行認證。

<pre><code class="language-go">// the first thing we need to define is a middleware for our handler
// that grabs the Authorization header and sets the context value for
// our user id
func withUserInfo(handler http.HandlerFunc) http.HandlerFunc {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // look up the value of the Authorization header
        tokenValue := r.Header.Get("Authorization")
        // Allow CORS here By * or specific origin
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Header().Set("Access-Control-Allow-Methods", "GET,POST,PUT,PATCH,DELETE,OPTIONS")
        w.Header().Set("Access-Control-Allow-Headers", "authorization, origin, content-type, accept")
        w.Header().Set("Allow", "HEAD,GET,POST,PUT,PATCH,DELETE,OPTIONS")
        // here is where you would perform some kind of validation on the token
        // but we&#039;re going to skip that for this example and just save it as the
        // id directly. PLEASE, DO NOT DO THIS IN PRODUCTION.

        // invoke the handler with the new context
        handler.ServeHTTP(w, r.WithContext(
            context.WithValue(r.Context(), "tokenValue", tokenValue),
        ))
    })
}

// the next thing we need to do is to modify the network requests to our services.
// To do this, we have to define a middleware that pulls the id of the user out
// of the context of the incoming request and sets it as the USER_ID header.
var forwardUserID = gateway.RequestMiddleware(func(r *http.Request) error {
    // the initial context of the request is set as the same context
    // provided by net/http

    // we are safe to extract the value we saved in context and set it as the outbound header
    if tokenValue := r.Context().Value("tokenValue"); tokenValue != nil {
        r.Header.Set("Authorization", tokenValue.(string))
    }

    // return the modified request
    return nil
})</code></pre>

其中上面的 Access-Control 用來解決 CORS 相關問題。前端用各自電腦開發時，就需要此部分。

## 心得

用 gqlgen 在開發上效率差很多，現在透過這方式，可以保留舊的 Schema 搭配新的 gqlgen 開發模式，未來也可以將共通的功能獨立拆成單一服務，再透過 gateway 方式將多個模組合併。

 [1]: https://lh3.googleusercontent.com/eWR5fi9ipIuscey-E940I6fhwU5ZySehbItzPLyPVchJxBlq8N1uXT-psLHdX_wV6xojac3_EeCFZH6vs6C1R910vzDV1mY2uOo33so6QqpWgNqbDjGZPB6ar2NwspITQ7paTfjqSo8=w1920-h1080 "infra"
 [2]: https://blog.wu-boy.com/2020/04/switch-graphql-go-to-gqlgen-in-golang/
 [3]: https://github.com/graphql-go/graphql
 [4]: https://gqlgen.com/
 [5]: https://principledgraphql.com/integrity#1-one-graph
 [6]: https://www.apollographql.com/docs/federation/gateway/
 [7]: https://golang.org
 [8]: https://github.com/nautilus/gateway
 [9]: https://gateway.nautilus.dev/
 [10]: https://medium.com/@aaivazis/a-guide-to-schema-federation-part-1-995b639ac035
 [11]: https://www.udemy.com/course/golang-fight/?couponCode=202101
 [12]: https://www.udemy.com/course/devops-oneday/?couponCode=202101
 [13]: https://www.udemy.com/course/docker-practice/?couponCode=202101
 [14]: http://facebook.com/appleboy46
 [15]: https://github.com/nautilus/gateway/issues/108
