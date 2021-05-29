---
title: 初探 Open Policy Agent 實作 RBAC (Role-based access control) 權限控管
author: appleboy
type: post
date: 2021-04-18T07:24:13+00:00
url: /2021/04/setup-rbac-role-based-access-control-using-open-policy-agent/
dsq_thread_id:
  - 8482265112
categories:
  - Golang
tags:
  - golang
  - open policy agent
  - RBAC

---
[![Open Policy Agent][1]][1]

最近公司內部多個專案都需要用到 [RBAC][2] (Role-based access control) 權限控管，所以決定來找尋 Go 語言的解決方案及套件，在 Go 語言比較常聽到的就是 [Casbin][3]，大家眾所皆知，但是隨著專案變大，系統複雜性更高，希望未來可以打造一套可擴充性的權限機制，故網路上看到一篇 [ladon vs casbin][4] 的介紹文章，文章留言有中國開發者對於 Casbin 的一些看法，以及最後他推薦另一套 [CNCF][5] 的專案叫 [Open Policy Agent][6] 來實作權限控管機制。本篇直接來針對 Open Policy Agent 簡稱 (OPA) 來做介紹，並且用 Go 語言來驗證 RBAC 權限。底下是文章內其他開發者用過 Casbin 的感想

> 1.使用覺得ladon的質量更好，支持類ACL和RBAC的權限系統，跟亞馬遜AWS的IAM非常契合 2.casbin那些庫的質量真的是無力吐槽，都沒有經常測試的東西就往github發，UI也到處bug，全都是畢業生寫的一樣，試用便知 3.casbin這個項目不讓提問題，提問題就給你關閉，作者很涉別人提問題 4.這些確實是本人的經歷，大家慎重選擇吧

最後的推薦

> 強烈推薦CNCF今年畢業的策略引擎OPA（維護團隊主要是Google，微軟，Styra等），可以實現ABAC，RBAC，PBAC等各種權限模型，目前我們已經在生產環境中使用。 也是基於OPA實現的。

本篇所使用的範例程式碼請從[這邊下載或觀看][7]。

<!--more-->

## 線上影片

{{< youtube AkMVh5XRcuI >}}

  * [Go 語言基礎實戰 (開發, 測試及部署)][8]
  * [一天學會 DevOps 自動化測試及部署][9]
  * [DOCKER 容器開發部署實戰][10]

如果需要搭配購買請直接透過 [FB 聯絡我][11]，直接匯款（價格再減 **100**）

## 什麼是 Open Policy Agent

[Open Policy Agent][6] (念 "oh-pa") 是一套開源專案，用來讓開發者制定各種不同的 Policy 機制，並且創造了 OPA’s policy 語言 ([Rego][12]) 來協助開發者快速撰寫各種不同的 Policy 政策，並且可以透過 Command (opa) 來驗證及測試。透過 OPA 可以制定像是微服務或 CI/CD Pipeline 等之間溝通的政策，來達到權限的分離。底下用一張官網的圖來介紹

[![open policy agent infra][13]][13]

簡單來說各個服務之間有不同的權限需要處理，這時透過 OPA 專門做授權管理的服務會是最好的，整個流程就會如下:

  1. 服務定義好 Query 格式 (任意的 JSON 格式)
  2. 撰寫所有授權政策 (Rego)
  3. 準備在授權過程需要用到的資料 (Data JSON)
  4. OPA 執行決定，並回傳服務所需的資料 (任意的 JSON 格式)

## 撰寫 RBAC 政策及驗證

OPA 官網已經[提供完整的範例][14]給各位開發者參考，也有完整的 [Rego 文件格式][15]，我們先定義 User 跟 Role 權限關係，接著定義 Role 可以執行哪些操作

<pre><code class="language-go">package rbac.authz

# user-role assignments
user_roles := {
  "design_group_kpi_editor": ["kpi_editor_design", "viewer_limit_ds"],
  "system_group_kpi_editor": ["kpi_editor_system", "viewer_limit_ds"],
  "manufacture_group_kpi_editor": ["kpi_editor_manufacture", "viewer"],
  "project_leader": ["viewer_limit_ds", "viewer_limit_m"]
}

# role-permissions assignments
role_permissions := {
  "admin": [
    {"action": "view_all",  "object": "design"},
    {"action": "edit",  "object": "design"},
    {"action": "view_all",  "object": "system"},
    {"action": "edit",  "object": "system"},
    {"action": "view_all",  "object": "manufacture"},
    {"action": "edit",  "object": "manufacture"},
  ],
  "quality_head_design":[
    {"action": "view_all",  "object": "design"},
    {"action": "edit",  "object": "design"},
    {"action": "view_all",  "object": "system"},
    {"action": "view_all",  "object": "manufacture"},
  ],
  "quality_head_system":[
    {"action": "view_all",  "object": "design"},
    {"action": "view_all",  "object": "system"},
    {"action": "edit",  "object": "system"},
    {"action": "view_all",  "object": "manufacture"},
  ],
  "quality_head_manufacture":[
    {"action": "view_all",  "object": "design"},
    {"action": "view_all",  "object": "system"},
    {"action": "view_all",  "object": "manufacture"},
    {"action": "edit",  "object": "manufacture"},
  ],

  "kpi_editor_design":[
    {"action": "view_all",  "object": "design"},
    {"action": "edit",  "object": "design"},
  ],
  "kpi_editor_system":[
    {"action": "view_all",  "object": "system"},
    {"action": "edit",  "object": "system"},
  ],
  "kpi_editor_manufacture":[
    {"action": "view_all",  "object": "manufacture"},
    {"action": "edit",  "object": "manufacture"},
  ],

  "viewer":[
    {"action": "view_all",  "object": "design"},
    {"action": "view_all",  "object": "system"},
    {"action": "view_all",  "object": "manufacture"},
  ],

  "viewer_limit_ds":[
    {"action": "view_all",  "object": "design"},
    {"action": "view_all",  "object": "system"},
  ],

  "viewer_limit_m":[
    {"action": "view_l3_project",  "object": "manufacture"},
  ],
}</code></pre>

資料準備完成後，接著就是寫政策

<pre><code class="language-go="># logic that implements RBAC.
default allow = false
allow {
  # lookup the list of roles for the user
  roles := user_roles[input.user[_]]
  # for each role in that list
  r := roles[_]
  # lookup the permissions list for role r
  permissions := role_permissions[r]
  # for each permission
  p := permissions[_]
  # check if the permission granted to r matches the user&#039;s request
  p == {"action": input.action, "object": input.object}
}</code></pre>

大家可以看到其中 `input` 就是上面第一點 Query 條件，可以是任意的 JSON 格式，接著在 allow 裡面開始處理整個政策流程，第一就是拿到 User 是屬於哪些角色，第二就是找到這些角色相對應得權限，最後就是拿 Query 的條件進行比對，最後可以輸出結果 `true` 或 `false`。寫完上面 Rego 檔案後，開發者可以下 OPA 執行檔，並且撰寫測試文件，進行驗證，跟 Go 語言一樣，直接檔名加上 `_test` 即可

<pre><code class="language-go=">test_design_group_kpi_editor {
  allow with input as {"user": ["design_group_kpi_editor"], "action": "view_all", "object": "design"}
  allow with input as {"user": ["design_group_kpi_editor"], "action": "edit", "object": "design"}
  allow with input as {"user": ["design_group_kpi_editor"], "action": "view_all", "object": "system"}
  not allow with input as {"user": ["design_group_kpi_editor"], "action": "edit", "object": "system"}
  not allow with input as {"user": ["design_group_kpi_editor"], "action": "view_all", "object": "manufacture"}
  not allow with input as {"user": ["design_group_kpi_editor"], "action": "edit", "object": "manufacture"}
}</code></pre>

像是這樣的格式，接著用 OPA Command 執行測試

<pre><code class="language-bash=">$ opa test -v *.rego
data.rbac.authz.test_design_group_kpi_editor: PASS (8.604833ms)
data.rbac.authz.test_system_group_kpi_editor: PASS (7.260166ms)
data.rbac.authz.test_manufacture_group_kpi_editor: PASS (2.217125ms)
data.rbac.authz.test_project_leader: PASS (1.823833ms)
data.rbac.authz.test_design_group_kpi_editor_and_system_group_kpi_editor: PASS (1.150791ms)
--------------------------------------------------------------------------------
PASS: 5/5</code></pre>

## 整合 Go 語言驗證及測試

上面是透過 OPA 官方的 Command 驗證 Policy 是否正確，接著我們可以整合 Go 語言進行驗證。通常會架設一台 OPA 服務，用來處理授權機制，那現在直接把 Policy 寫進去 Go 執行檔，減少驗證的 Latency。

<pre><code class="language-go=">package main

import (
    "context"
    "log"

    "github.com/open-policy-agent/opa/rego"
)

var policyFile = "example.rego"
var defaultQuery = "x = data.rbac.authz.allow"

type input struct {
    User   string `json:"user"`
    Action string `json:"action"`
    Object string `json:"object"`
}

func main() {
    s := input{
        User:   "design_group_kpi_editor",
        Action: "view_all",
        Object: "design",
    }

    input := map[string]interface{}{
        "user":   []string{s.User},
        "action": s.Action,
        "object": s.Object,
    }

    policy, err := readPolicy(policyFile)
    if err != nil {
        log.Fatal(err)
    }

    ctx := context.TODO()
    query, err := rego.New(
        rego.Query(defaultQuery),
        rego.Module(policyFile, string(policy)),
    ).PrepareForEval(ctx)

    if err != nil {
        log.Fatalf("initial rego error: %v", err)
    }

    ok, _ := result(ctx, query, input)
    log.Println("", ok)
}

func result(ctx context.Context, query rego.PreparedEvalQuery, input map[string]interface{}) (bool, error) {
    results, err := query.Eval(ctx, rego.EvalInput(input))
    if err != nil {
        log.Fatalf("evaluation error: %v", err)
    } else if len(results) == 0 {
        log.Fatal("undefined result", err)
        // Handle undefined result.
    } else if result, ok := results[0].Bindings["x"].(bool); !ok {
        log.Fatalf("unexpected result type: %v", result)
    }

    return results[0].Bindings["x"].(bool), nil
}</code></pre>

其中 readPolicy 可以直接用 go1.16 推出的 embed 套件，將 rego 檔案直接整合進 go binary。

<pre><code class="language-go=">// +build go1.16

package main

import (
    _ "embed"
)

//go:embed example.rego
var policy []byte

func readPolicy(path string) ([]byte, error) {
    return policy, nil
}</code></pre>

撰寫測試，直接在 Go 語言進行測試及資料讀取，以便驗證更多細項功能

<pre><code class="language-go=">package main

import (
    "context"
    "log"
    "os"
    "testing"

    "github.com/open-policy-agent/opa/rego"
)

var query rego.PreparedEvalQuery

func setup() {
    var err error
    policy, err := readPolicy(policyFile)
    if err != nil {
        log.Fatal(err)
    }

    query, err = rego.New(
        rego.Query(defaultQuery),
        rego.Module(policyFile, string(policy)),
    ).PrepareForEval(context.TODO())

    if err != nil {
        log.Fatalf("initial rego error: %v", err)
    }
}

func TestMain(m *testing.M) {
    setup()
    code := m.Run()
    os.Exit(code)
}

func Test_result(t *testing.T) {
    ctx := context.TODO()
    type args struct {
        ctx   context.Context
        query rego.PreparedEvalQuery
        input map[string]interface{}
    }
    tests := []struct {
        name    string
        args    args
        want    bool
        wantErr bool
    }{
        {
            name: "test_design_group_kpi_editor_edit_design",
            args: args{
                ctx:   ctx,
                query: query,
                input: map[string]interface{}{
                    "user":   []string{"design_group_kpi_editor"},
                    "action": "edit",
                    "object": "design",
                },
            },
            want:    true,
            wantErr: false,
        },
        {
            name: "test_design_group_kpi_editor_edit_system",
            args: args{
                ctx:   ctx,
                query: query,
                input: map[string]interface{}{
                    "user":   []string{"design_group_kpi_editor"},
                    "action": "edit",
                    "object": "system",
                },
            },
            want:    false,
            wantErr: false,
        },
        {
            name: "test_design_group_kpi_editor_and_system_group_kpi_editor_for_edit_design",
            args: args{
                ctx:   ctx,
                query: query,
                input: map[string]interface{}{
                    "user":   []string{"design_group_kpi_editor", "system_group_kpi_editor"},
                    "action": "edit",
                    "object": "design",
                },
            },
            want:    true,
            wantErr: false,
        },
        {
            name: "test_design_group_kpi_editor_and_system_group_kpi_editor_for_edit_system",
            args: args{
                ctx:   ctx,
                query: query,
                input: map[string]interface{}{
                    "user":   []string{"design_group_kpi_editor", "system_group_kpi_editor"},
                    "action": "edit",
                    "object": "system",
                },
            },
            want:    true,
            wantErr: false,
        },
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := result(tt.args.ctx, tt.args.query, tt.args.input)
            if (err != nil) != tt.wantErr {
                t.Errorf("result() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if got != tt.want {
                t.Errorf("result() = %v, want %v", got, tt.want)
            }
        })
    }
}</code></pre>

## 心得

由於網路上教學文件也不多，故自己先寫一篇紀錄基本操作，未來會有更多跟 Go 整合的實際案例， 屆時會再分享給大家。OPA 除了 RBAC 之外，還有更多功能可以在官網上面查詢，個人覺得整合起來應該會相當方便，各種情境幾乎都有考慮到，不單單只有一些特定情境可以使用，至於怎麼擴充到更多情境，就是靠 Rego 撰寫 Policy 語法，並撰寫驗證及測試。本篇所使用的範例程式碼請從[這邊下載或觀看][7]。

 [1]: https://lh3.googleusercontent.com/qLGheyjm3eVL-TRP_MT1X9j2QrNrtIIAlVPmLbvNGWcLkqfUTpH87D2GCzYmce8eU88oMF-82lSqT6DwOByPWEKVZP4nGWT-IZFDvpVwnil2AeXZaYxZN5J33IpfsYfP6mljV3S51R4=w1920-h1080 "Open Policy Agent"
 [2]: https://zh.wikipedia.org/wiki/%E4%BB%A5%E8%A7%92%E8%89%B2%E7%82%BA%E5%9F%BA%E7%A4%8E%E7%9A%84%E5%AD%98%E5%8F%96%E6%8E%A7%E5%88%B6
 [3]: https://casbin.org/
 [4]: https://gist.github.com/Wang-Kai/18fe4e662ef795805c14b1ec94932834
 [5]: https://www.cncf.io/
 [6]: https://www.openpolicyagent.org/
 [7]: https://github.com/go-training/opa-demo/tree/v0.0.1
 [8]: https://www.udemy.com/course/golang-fight/?couponCode=202104
 [9]: https://www.udemy.com/course/devops-oneday/?couponCode=202104
 [10]: https://www.udemy.com/course/docker-practice/?couponCode=202104
 [11]: http://facebook.com/appleboy46
 [12]: https://www.openpolicyagent.org/docs/latest/policy-language/
 [13]: https://lh3.googleusercontent.com/sP-328kBFP9pBLIrbkfl10LboSbkK4kx5fffXG0fUeo-3IMtQewwzGGKA-4a212Y9pHuZt_kgU7tYnXaDBWeUiPDUfdWoSKbxYW4xJOsCwVpHRvN7ssGeL2wojIpugquI4ef-IzblJM=w1920-h1080 "open policy agent infra"
 [14]: https://www.openpolicyagent.org/docs/latest/comparison-to-other-systems/#role-based-access-control-rbac
 [15]: https://www.openpolicyagent.org/docs/latest/policy-language
