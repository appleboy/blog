---
title: 在 Go 語言使用 Viper 管理設定檔
author: appleboy
type: post
date: 2017-10-23T06:54:53+00:00
url: /2017/10/go-configuration-with-viper/
dsq_thread_id:
  - 6234564019
categories:
  - Golang
tags:
  - golang
  - viper

---
[![][1]][1]

在每個語言內一定都會有管理設定檔的相關套件，像是在 [Node.js][2] 的 [dotenv][3] 套件，而在 [Go 語言][4]內呢？相信大家一定都會推 [Hugo][5] 作者寫的 [Viper][6]，Viper 可以支援讀取 JSON, TOML, YAML, HCL 等格式的設定檔案，也可以讀取環境變數，另外也可以直接跟取遠端設定檔整合(像是 [etcd][7] 或 [Consul][8])，本篇會介紹如何使用 Viper。

<!--more-->

## 情境需求

當專案是使用 Yaml 或 JSON 存放設定檔時，在不同的部署環境都需要不同的設定檔。這時候就需要設定 App 可以指定不同設定檔路徑，指令如下

```bash
$ app -c config.yaml
```

這樣測試同事拿到執行檔時，就可以透過 `-c` 參數來讀取個人設定檔。有個問題，假設設定檔需要動態修改，每次測完就改動一次有點麻煩，所以 App 必須要支援環境變數，像是如下:

```bash
$ APP_PORT=8088 app -c config.yaml
```

假如沒有帶入 `-c` 參數，App 要能讀取系統預設環境設定檔案，像是 (`$HOME/.app/config.yaml`)。下面來教大家如何透過 Viper 做到上述環境。

## 建立預設檔案

在 Go 語言內可以先用變數方式將 Yaml 直接寫在程式碼內:

```go
var defaultConf = []byte(`
app:
  port: 3000
`)
```

接著設定 Viper 讀取 `Yaml` 檔案型態。

```go
viper.SetConfigType("yaml")
```

## 讀取指定檔案

透過 Go 語言的 flag 套件可以輕易實作出命令列 `-c` 參數

```go
flag.StringVar(&configFile, "c", "", "Configuration file path.")
```

接著就可以直接讀取 Yaml 檔案

```go
if configFile != "" {
    content, err := ioutil.ReadFile(confPath)

    if err != nil {
        return conf, err
    }

    viper.ReadConfig(bytes.NewBuffer(content))
}
```

可以看到透過 `viper.ReadConfig` 可以把 Yaml 內容丟進去，之後就可以透過 `viper.GetInt("app.port")` 來存取資料。

## 讀取動態目錄

Viper 有個功能就是可以直接幫忙找尋相關目錄內的設定檔案。先假設底下路徑是您希望 App 可以自動幫你讀取:

  1. `/etc/app/` (Linux 常用的 `/etc/` 目錄)
  2. `$HOME/.app` (家目錄底下的 `.app` 目錄)
  3. `.` (執行當下目錄)

首先設定 Viper 要去找 `config` 開頭的設定檔案

```go
viper.SetConfigName("config")
```

上面設定好，就會直接找 `config.yaml` 檔案，如果設定 `app` 則是找 `app.yaml`。接著指定設定檔所在目錄

```go
viper.AddConfigPath("/etc/app/")
viper.AddConfigPath("$HOME/.app")
viper.AddConfigPath(".")
```

最後透過 `ReadInConfig` 來自動搜尋並且讀取檔案。

```go
if err := viper.ReadInConfig(); err == nil {
    fmt.Println("Using config file:", viper.ConfigFileUsed())
}
```

## 從環境變數讀取

如果專案需要跑在容器環境，這樣此功能對部署來說非常重要，也就是我只需要將 Go 語言的執行檔包進去 Docker 就好，而不需要將 Yaml 設定檔一起包入，或是透過 Volume 方式掛起來。這樣至少減少了一個步驟。首先設定 Viper 自動讀取環境變數:

```go
// read in environment variables that match
viper.AutomaticEnv()
```

接著設定環境變數 Prefix，避免跟其他專案衝突

```go
// will be uppercased automatically
viper.SetEnvPrefix("test")
```

最後設定環境變數的分隔符號從 `.` 換成 `_`

```go
viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
```

以上面的例子來說，你可以透過 `TEST_APP_PORT` 來指定不同的 port

```bash
$ TEST_APP_PORT=3001 app -c config.yaml
```

## 實作範例

我們可以把上面的說明整理成範例，讀取流程會如下

  1. 讀取實體路徑
  2. 讀取預設路徑
  3. 讀取預設設定

假如 App 讀取特定路徑設定檔 (`-c` 參數)，那就不會執行 2, 3 步驟，步驟 1 省略的話，App 就會自動先找預設路徑，如果預設路徑找不到就會執行步驟 3。程式碼範例如下:

```go
viper.SetConfigType("yaml")
viper.AutomaticEnv()         // read in environment variables that match
viper.SetEnvPrefix("gorush") // will be uppercased automatically
viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))

if confPath != "" {
    content, err := ioutil.ReadFile(confPath)

    if err != nil {
        return conf, err
    }

    viper.ReadConfig(bytes.NewBuffer(content))
} else {
    // Search config in home directory with name ".gorush" (without extension).
    viper.AddConfigPath("/etc/gorush/")
    viper.AddConfigPath("$HOME/.gorush")
    viper.AddConfigPath(".")
    viper.SetConfigName("config")

    // If a config file is found, read it in.
    if err := viper.ReadInConfig(); err == nil {
        fmt.Println("Using config file:", viper.ConfigFileUsed())
    } else {
        // load default config
        viper.ReadConfig(bytes.NewBuffer(defaultConf))
    }
}
```

## 結論

我個人用 Viper 最大的原因就是可以透過環境變數修改 App 的預設參數，另外編譯 Docker 容器時也不需要將設定檔丟入。在 [Kubernetes][9] 架構內可以透過 [config map][10] 方式來動態改變 App 行為。如果要搭配命令列，可以使用 [cobra][11] 結合 Viper。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://nodejs.org/en/
 [3]: https://github.com/motdotla/dotenv
 [4]: https://golang.org
 [5]: https://gohugo.io/
 [6]: https://github.com/spf13/viper
 [7]: https://github.com/coreos/etcd
 [8]: https://www.consul.io
 [9]: https://kubernetes.io/
 [10]: https://kubernetes.io/docs/tasks/configure-pod-container/configmap/
 [11]: https://github.com/spf13/cobra