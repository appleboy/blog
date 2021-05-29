---
title: 使用 RESTful API 串接 Open Policy Agent
author: appleboy
type: post
date: 2021-05-04T02:14:12+00:00
url: /2021/05/comunicate-with-open-policy-agent-using-resful-api/
dsq_thread_id:
  - 8505295386
categories:
  - Golang
tags:
  - golang
  - open policy agent

---
[![Open Policy Agent][1]][1]

上一篇『[初探 Open Policy Agent 實作 RBAC (Role-based access control) 權限控管][2]』介紹了如何透過 [Go 語言][3]直接嵌入 Open Policy Agent (簡稱 OPA)設定檔，並透過 Go 套件直接查詢使用者權限。由於目前 OPA 只有支援三種模式串接各種不同的 Application，一種是透過 Go 語言直接整合，詳細請看上一篇教學，另一種是透過 RESTful API，也就是本篇的教學，最後一種是透過 [WebAssembly][4] 讓其他 application 可以直接讀取。之後有機會再來寫 WebAssembly 教學。而本篇將帶您了解如何透過 RESTful API 方式來完成 [RBAC 權限控管][5]，其實我比較期待支援 [gRPC][6] 模式，但是看到這篇 [issue 提到][7]，OPA 現在已經支援 Plugin 模式，大家想擴充的，可以自行處理。

<!--more-->

## 請求流程

[![blog_01][8]][8]

可以看到上述圖片看到整個 OPA 系統流程，OPA 就是確保各種 API Request 的權限，首先第一步驟會帶著 Auuthorization Token 去跟單一個服務詢問，接著此服務就會將資料帶到 OPA 進行查詢此 請求是否有權限可以存取，最後 OPA 會回傳結果，接著再由服務端決定要回送哪些訊息。那本篇的重點會在下圖部分

[![blog_02][9]][9]

## 準備查詢資料

底下是 OPA 的系統流程圖

[![blog_03][10]][10]

我們可以很清楚知道，要拿到最後的 Query Result (JSON) 需要有三個 Input 的，分別是

  1. Query Input (JSON)
  2. Data (JSON)
  3. Policy (Rego)

就以 RBAC 為範例，第一個 **Query Input** 的資料，就需要帶入像是使用者所在的群組 (user)，使用者現在要執行的動作 (action)，使用者要對什麼資源做事情 (object)。這三個資料轉成 JSON 格式如下:

<pre><code class="language-json">{
  "input": {
    "user": ["design_group_kpi_editor", "system_group_kpi_editor"],
    "action": "edit",
    "object": "design"
  }
}</code></pre>

第二項就是準備系統內建的 Data 資料給 OPA，上述資料可以看到 user 所在的群組資訊，但是這些群組能做哪些事情，是 OPA 沒辦法知道的，所以需要將這些資料整理成 JSON 格式，並且上傳到 OPA 系統內

<pre><code class="language-json">{
  "group_roles": {
    "admin": ["admin"],
    "quality_head_design": ["quality_head_design"],
    "quality_head_system": ["quality_head_system"],
    "quality_head_manufacture": ["quality_head_manufacture"],
    "kpi_editor_design": ["kpi_editor_design"],
    "kpi_editor_system": ["kpi_editor_system"],
    "kpi_editor_manufacture": ["kpi_editor_manufacture"],
    "viewer": ["viewer"],
    "viewer_limit_ds": ["viewer_limit_ds"],
    "viewer_limit_m": ["viewer_limit_m"],
    "design_group_kpi_editor": ["kpi_editor_design", "viewer_limit_ds"],
    "system_group_kpi_editor": ["kpi_editor_system", "viewer_limit_ds"],
    "manufacture_group_kpi_editor": ["kpi_editor_manufacture", "viewer"],
    "project_leader": ["viewer_limit_ds", "viewer_limit_m"]
  },
  "role_permissions": {
    "admin": [
      {"action": "view_all", "object": "design"},
      {"action": "edit", "object": "design"},
      {"action": "view_all", "object": "system"},
      {"action": "edit", "object": "system"},
      {"action": "view_all", "object": "manufacture"},
      {"action": "edit", "object": "manufacture"}
    ],
    "quality_head_design": [
      {"action": "view_all", "object": "design"},
      {"action": "edit", "object": "design"},
      {"action": "view_all", "object": "system"},
      {"action": "view_all", "object": "manufacture"}
    ],
    "quality_head_system": [
      {"action": "view_all", "object": "design"},
      {"action": "view_all", "object": "system"},
      {"action": "edit", "object": "system"},
      {"action": "view_all", "object": "manufacture"}
    ],
    "quality_head_manufacture": [
      {"action": "view_all", "object": "design"},
      {"action": "view_all", "object": "system"},
      {"action": "view_all", "object": "manufacture"},
      {"action": "edit", "object": "manufacture"}
    ],
    "kpi_editor_design": [
      {"action": "view_all", "object": "design"},
      {"action": "edit", "object": "design"}
    ],
    "kpi_editor_system": [
      {"action": "view_all", "object": "system"},
      {"action": "edit", "object": "system"}
    ],
    "kpi_editor_manufacture": [
      {"action": "view_all", "object": "manufacture"},
      {"action": "edit", "object": "manufacture"}
    ],
    "viewer": [
      {"action": "view_all", "object": "design"},
      {"action": "view_all", "object": "system"},
      {"action": "view_all", "object": "manufacture"}
    ],
    "viewer_limit_ds": [
      {"action": "view_all", "object": "design"},
      {"action": "view_all", "object": "system"}
    ],
    "viewer_limit_m": [{"action": "view_l3_project", "object": "manufacture"}]
  }
}</code></pre>

上述 Data 可以知道 Group 跟 Role 的對應關係，以及 Role 可以做得相對應事情。最後一項就是撰寫 OPA Policy，要透過 [Rego 語言][11]來撰寫，其實沒有很難。

<pre><code class="language-go">package rbac.authz

import data.rbac.authz.acl
import input

# logic that implements RBAC.
default allow = false

allow {
    # lookup the list of roles for the user
    roles := acl.group_roles[input.user[_]]

    # for each role in that list
    r := roles[_]

    # lookup the permissions list for role r
    permissions := acl.role_permissions[r]

    # for each permission
    p := permissions[_]

    # check if the permission granted to r matches the user's request
    p == {"action": input.action, "object": input.object}
}</code></pre>

上面就是先把 User 對應的 Group Role 找到之後，再將全部的 Role 權限拿出來進行最後的比對產生結果，回傳值就會是 `allow` 布林值。

## RESTful API

上述步驟將檔案整理成底下三個

  1. input.json
  2. data.json
  3. rbac.authz.rego

透過底下指令依序將資料上傳到 OPA Server 內，第一個先上傳 data

<pre><code class="language-bash">curl -X PUT http://localhost:8181/v1/data/rbac/authz/acl \
  --data-binary @data.json</code></pre>

接著上傳 Policy

<pre><code class="language-bash">curl -X PUT http://localhost:8181/v1/policies/rbac.authz \
  --data-binary @rbac.authz.rego</code></pre>

最後驗證 input 資料

<pre><code class="language-bash">curl -X POST http://localhost:8181/v1/data/rbac/authz/allow \
  --data-binary @input.json</code></pre>

用 [bat tool][12] 驗證

<pre><code class="language-bash">$ bat POST http://localhost:8181/v1/data/rbac/authz/allow < input.json
POST /v1/data/rbac/authz/allow HTTP/1.1
Host: localhost:8181
Accept: application/json
Accept-Encoding: gzip, deflate
Content-Type: application/json
User-Agent: bat/0.1.0

{"input":{"action":"edit","object":"design","user":["design_group_kpi_editor","system_group_kpi_editor"]}}

HTTP/1.1 200 OK
Content-Type: application/json
Date: Sat, 01 May 2021 08:43:30 GMT
Content-Length: 15

{
  "result": true
}</code></pre>

或者可以透過簡單的 Go 語言來驗證，用 Go 1.16 新的 embed package 來驗證。

<pre><code class="language-go">package main

import (
    "bytes"
    _ "embed"
    "fmt"
    "io/ioutil"
    "net/http"
    "time"
)

//go:embed input.json
var input []byte

func main() {
    url := "http://localhost:8181/v1/data/rbac/authz/allow"
    method := "POST"

    payload := bytes.NewReader(input)

    client := &http.Client{
        Timeout: 5 * time.Second,
    }
    req, err := http.NewRequest(method, url, payload)

    if err != nil {
        fmt.Println(err)
        return
    }
    req.Header.Add("Content-Type", "application/json")

    res, err := client.Do(req)
    if err != nil {
        fmt.Println(err)
        return
    }
    defer res.Body.Close()

    body, err := ioutil.ReadAll(res.Body)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(string(body))
}</code></pre>

## 結論

本篇透過 RESTful 方式來更新 Data 及 Policy，此方式相對於前篇直接坎入在 Go 語言內，效率上來說會比較差些，因為會牽扯到你把 OPA 部署在哪個環境內，中間肯定會有一些 Latency，不過這就要看團隊怎麼使用 OPA 了，各有優缺點，團隊如果不是在寫 Go 語言的，肯定只能用 RESTful 方式來更新及查詢。程式碼可以在[這邊找到][13]。

 [1]: https://lh3.googleusercontent.com/qLGheyjm3eVL-TRP_MT1X9j2QrNrtIIAlVPmLbvNGWcLkqfUTpH87D2GCzYmce8eU88oMF-82lSqT6DwOByPWEKVZP4nGWT-IZFDvpVwnil2AeXZaYxZN5J33IpfsYfP6mljV3S51R4=w1920-h1080 "Open Policy Agent"
 [2]: https://blog.wu-boy.com/2021/04/setup-rbac-role-based-access-control-using-open-policy-agent/
 [3]: https://golang.org
 [4]: https://webassembly.org/
 [5]: https://en.wikipedia.org/wiki/Role-based_access_control
 [6]: https://grpc.io/
 [7]: https://github.com/open-policy-agent/opa/issues/841
 [8]: https://lh3.googleusercontent.com/Sjqfv-XLOfdlK2GmoZdmcEM0UYKzNsKSas3xh1GfBc4UIQLKjmqjbC_ULUgM_2Jf76yI6baveAn_uAfJ5DGPbo39zRhKgvf7pOGsWSi1B4wW4DvciTrCuL2O5J1n-YUF43F3DqFOPQM=w1920-h1080 "blog_01"
 [9]: https://lh3.googleusercontent.com/yjVOXbiFYt6XZ577GOqJLCh5cY-kPxEyxuSIo_7TbkQBmhSn0zdW5RmxwmNLumP5QJBxfuKlUTZWQchqFzVKRVtyxefwzxmkZou5ck_06guA7eVXViEW_mtnfNG3YvKqwNsXrxcCLlE=w1920-h1080 "blog_02"
 [10]: https://lh3.googleusercontent.com/wAdNLaVqbVK9JoP124HisUautnVurHNn8QTVvgdbfKsI_zv4OXVNzFrQLs4n5xtpbSPK_khXbV2AmXzc197GGfHFdsHbbM8O9Gj9O48LVJhF-fEInUHhdcGPfUjEHNSn4Ygvq50FqTY=w1920-h1080 "blog_03"
 [11]: https://www.openpolicyagent.org/docs/latest/policy-language/
 [12]: https://github.com/astaxie/bat
 [13]: https://github.com/go-training/opa-restful