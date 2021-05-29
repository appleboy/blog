---
title: '[Go 語言] 從 graphql-go 轉換到 gqlgen'
author: appleboy
type: post
date: 2020-04-16T07:05:35+00:00
url: /2020/04/switch-graphql-go-to-gqlgen-in-golang/
dsq_thread_id:
  - 7973272536
categories:
  - Golang
tags:
  - golang
  - GraphQL

---
[![golang logo][1]][1]

相信各位開發者對於 [GraphQL][2] 帶來的好處已經非常清楚，如果對 GraphQL 很陌生的朋友們，可以直接參考之前作者寫的一篇『[Go 語言實戰 GraphQL][3]』，內容會講到用 [Go 語言][4]實戰 GraphQL 架構，教開發者如何撰寫 GraphQL 測試及一些開發小技巧，不過內容都是以 [graphql-go][5] 框架為主。而本篇主題會講為什麼我從 [graphql-go][5] 框架轉換到 [gqlgen][6]。

<!--more-->

## 教學影片

{{< youtube fznJC-GYQUw >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][7]
  * [一天學會 DevOps 自動化測試及部署][8]
  * [DOCKER 容器開發部署實戰][9] (課程剛啟動，限時特價 $900 TWD)

如果需要搭配購買請直接透過 [FB 聯絡我][10]，直接匯款（價格再減 **100**）

## 前言

我自己用 [graphql-go][5] 寫了一些專案，但是碰到的問題其實也不少，很多問題都可以在 graphql-go 專案的 [Issue 列表][11]內都可以找到，雖然此專案的 Star 數量是最高，討論度也是最高，如果剛入門 GraphQL，需要練習，用這套見沒啥問題，比較資深的開發者，就不建議選這套了，先來看看功能比較圖

<img src="https://i2.wp.com/i.imgur.com/53L16Xw.png?w=840&#038;ssl=1" alt="" data-recalc-dims="1" /> 

其中有幾項痛點是讓我主要轉換的原因:

  1. 效能考量
  2. 功能差異
  3. schema first
  4. 強型別
  5. 自動產生程式碼

底下一一介紹上述特性

## 效能考量

我自己建立效能 Benchamrk 來比較市面上幾套 GraphQL 套件 [golang-graphql-benchmark][12]

  * graphql-go/graphql version: `v0.7.9`
  * playlyfe/go-graphql version: v0.0.0-20191219091308-23c3f22218ef
  * graph-gophers/graphql-go version: v0.0.0-20200207002730-8334863f2c8b
  * samsarahq/thunder version: v0.5.0
  * 99designs/gqlgen version: `v0.11.3`

|               | Requests/sec |
| ------------- | ------------ |
| graphql-go    | 19004.92     |
| graph-gophers | 44308.44     |
| thunder       | 40994.33     |
| gqlgen        | **49925.73** |

由上面可以看到光是一個 Hello World 範例，最後的結果由 [gqlgen][6] 勝出，現在討論度比較高的也只有 gqlgen 跟 grapgql-go，效能上面差異頗大。這算是我轉過去的最主要原因之一。

## 功能差異

幾個重點差異，底下看看比較圖:

<img src="https://i2.wp.com/i.imgur.com/53L16Xw.png?w=840&#038;ssl=1" alt="" data-recalc-dims="1" /> 

  1. Type Safety
  2. Type Binding
  3. Upload FIle

等蠻多細部差異，graphql-go 目前不支持檔案上傳，所以還是需要透過 RESTFul API 方式上傳，但是已經有人[提過 Issue 且發了 PR][13]， 作者看起來沒有想處理這題。就拿上傳檔案當做例子，在 gqlgen 寫檔案上傳相當容易，先寫 schema

<pre><code class="language-sh">"The `Upload` scalar type represents a multipart file upload."
scalar Upload

"The `File` type, represents the response of uploading a file."
type File {
  name: String!
  contentType: String!
  size: Int!
  url: String!
}</code></pre>

就可以直接在 resolver 使用:

<pre><code class="language-go">type File struct {
    Name        string
    Size        int
    Content     []byte
    ContentType string
}

func (r *mutationResolver) getFile(file graphql.Upload) (*File, error) {
    content, err := ioutil.ReadAll(file.File)
    if err != nil {
        return nil, errors.EBadRequest(errorUploadFile, err)
    }

    contentType := ""
    kind, _ := filetype.Match(content)
    if kind != filetype.Unknown {
        contentType = kind.MIME.Value
    }

    if contentType == "" {
        contentType = http.DetectContentType(content)
    }

    return &File{
        Name:        file.Filename,
        Size:        int(file.Size),
        Content:     content,
        ContentType: contentType,
    }, nil
}</code></pre>

## Schema first

後端設計 API 時需要針對使用者情境及 Database 架構來設計 GraphQL Schema，詳細可以參考 [Schema Definition Language][14]。底下可以拿使用者註冊來當做例子:

<pre><code class="language-sh">enum EnumGender {
  MAN
  WOMAN
}

# Input Types
input createUserInput {
  email: String!
  password: String!
  doctorCode: String
}

type createUserPayload {
  user: User
  actCode: String
  digitalCode: String
}

# Types
type User {
  id: ID
  email: String!
  nickname: String
  isActive: Boolean
  isFirstLogin: Boolean
  avatarURL: String
  gender: EnumGender
}

type Mutation {
  createUser(input: createUserInput!): createUserPayload
}</code></pre>

除了可以先寫 Schema 之外，還可以根據不同情境的做分類，將一個完整的 Schema 拆成不同模組，這個在 gqlgen 都可以很容易做到。

<pre><code class="language-yaml">resolver:
  layout: follow-schema
  dir: graph</code></pre>

之後 gqlgen 會將目錄結構產生如下

<pre><code class="language-sh">user.graphql
user.resolver.go
cart.graphql
cart.resolver.go</code></pre>

開發者只要將相對應的 resolver method 實現出來就可以了。

## 強型別

如果有在寫 graphql-go 就可以知道該如何取得使用者 input 參數，在 graphql-go 使用的是 `map[string]interface{}` 型態，要正確拿到參數值，就必須要轉換型態

<pre><code class="language-go">username := strings.ToLower(p.Args["username"].(string))
password := p.Args["password"].(string)</code></pre>

多了一層轉換相當複雜，而 gqlgen 則是直接幫忙轉成 struct 強型別

<pre><code class="language-go">CreateUser(ctx context.Context, input model.CreateUserInput)</code></pre>

其中 `model.CreateUserInput` 就是完整的 struct，而並非是 `map[string]interface{}`，在傳遞參數時，就不用多寫太多 interface 轉換，完整的註冊流程可以參考底下:

<pre><code class="language-go">func (r *mutationResolver) CreateUser(ctx context.Context, input model.CreateUserInput) (*model.CreateUserPayload, error) {
    resp, err := api.CreateUser(r.Config, api.ReqCreateUser{
        Email:      input.Email,
        Password:   input.Password,
    })

    if err != nil {
        return nil, err
    }

    return &model.CreateUserPayload{
        User:        resp.User,
        DigitalCode: convert.String(resp.DigitalCode),
        ActCode:     convert.String(resp.ActCode),
    }, nil
}</code></pre>

## 自動產生代碼

要維護欄位非常多的 Schema 相當不容易，在 graphql-go 每次改動欄位，都需要開發者自行修改，底下是 user type 範例:

<pre><code class="language-go">var userType = graphql.NewObject(graphql.ObjectConfig{
    Name:        "UserType",
    Description: "User Type",
    Fields: graphql.Fields{
        "id": &graphql.Field{
            Type: graphql.ID,
        },
        "email": &graphql.Field{
            Type: graphql.String,
        },
        "username": &graphql.Field{
            Type: graphql.String,
        },
        "name": &graphql.Field{
            Type: graphql.String,
        },
        "isAdmin": &graphql.Field{
            Type: graphql.Boolean,
            Resolve: func(p graphql.ResolveParams) (interface{}, error) {
                source := p.Source
                o, ok := source.(*model.User)

                if !ok {
                    return false, nil
                }

                return o.CheckAdmin(), nil
            },
        },
        "isNewcomer": &graphql.Field{
            Type: graphql.Boolean,
        },
        "createdAt": &graphql.Field{
            Type: graphql.DateTime,
        },
        "updatedAt": &graphql.Field{
            Type: graphql.DateTime,
        },
    },
})</code></pre>

上面這段程式碼是要靠開發者自行維護，只要有任何異動，都需要手動自行修改，但是在 gqlgen 就不需要了，你只要把 schema 定義完整後，如下:

<pre><code class="language-sh">type User {
  id: ID
  email: String!
  username: String
  isAdmin: Boolean
  isNewcomer: Boolean
  createdAt: Time
  updatedAt: Time
}</code></pre>

在 console 端下 `go run github.com/99designs/gqlgen`，就會自動將代碼生成完畢。你也可以將 User 綁定在開發者自己定義的 Model 層級。

<pre><code class="language-yaml">models:
  User:
    model: pkg/model.User</code></pre>

之後需要新增任何欄位，只要在 `pkg/model.User` 提供相對應的欄位或 method，重跑一次 gqlgen 就完成了。省下超多開發時間。

## 心得

其實 graphql-go 雷的地方不只有這些，還有很多地方沒有列出，但是上面的 gqlgen 優勢，已經足以讓我轉換到新的架構上。而在專案新的架構上，也同時具備 RESTFul API + GraphQL 設計，如果有時間再跟大家分享這部分。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://graphql.org/
 [3]: https://blog.wu-boy.com/2018/07/graphql-in-go/
 [4]: https://golang.org
 [5]: https://github.com/graphql-go/graphql
 [6]: https://gqlgen.com/
 [7]: https://www.udemy.com/course/golang-fight/?couponCode=202004
 [8]: https://www.udemy.com/course/devops-oneday/?couponCode=202004
 [9]: https://www.udemy.com/course/docker-practice/?couponCode=202004
 [10]: http://facebook.com/appleboy46
 [11]: https://github.com/graphql-go/graphql/issues
 [12]: https://github.com/appleboy/golang-graphql-benchmark
 [13]: https://github.com/graphql-go/graphql/issues/141
 [14]: https://graphql.org/learn/schema/
