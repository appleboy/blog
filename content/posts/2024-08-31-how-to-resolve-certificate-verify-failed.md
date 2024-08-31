---
title: "如何解決 MacOS 或 Linux 開發環境下的 SSL 驗證失敗問題"
date: 2024-08-31T09:21:49+08:00
author: appleboy
type: post
slug: how-to-resolve-certificate-verify-failed
share_img: /images/2024-08-31/azure-openai-hong-kong.png
categories:
- Azure
- SSL
---

![logo](/images/2024-08-31/azure-openai-hong-kong.png)

在開發環境中，有時候會遇到 SSL 驗證失敗的問題，這個問題通常是因為系統沒有正確的 SSL 憑證，導致無法驗證 SSL 憑證的問題。這篇文章將會介紹如何解決 MacOS 或 Linux 開發環境下的 SSL 驗證失敗問題。會寫這篇主要是我們預計在中國地區使用 [Azure 服務][1]，但是在中國地區使用 Azure 服務時，會遇到 SSL 驗證失敗的問題，其理由就是在 [Application Gateway][2] 上的 SSL 憑證是由 Azure 提供自簽憑證。之後再寫一篇這個架構的目的跟辛酸史。也很感謝微軟團隊在這邊給予的協助及幫忙。

[1]: https://azure.microsoft.com/
[2]: https://learn.microsoft.com/en-us/azure/application-gateway/overview

## 程式範例

由於我們在 Application Gateway 上使用的是自簽憑證，所以我們需要在程式中加入忽略 SSL 驗證的設定，這邊以 Python 語言為例，程式碼如下：

```python
import os
from openai import AzureOpenAI
import httpx

# Create an httpx client and pass the SSL certificate path or set to False
httpx_client = httpx.Client(http2=True, verify=False)

client = AzureOpenAI(
  azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT", "https://xxxxxxxx.eastasia.cloudapp.azure.com"),
  api_key=os.getenv("AZURE_OPENAI_API_KEY", "xxxxxxx"),
  api_version="2023-03-15-preview",
  http_client=httpx_client
)

response = client.chat.completions.create(
  model="gpt-4o",  # model = "deployment_name".
  messages=[
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "Does Azure OpenAI support customer managed keys?"},
    {"role": "assistant",
     "content": "Yes, customer managed keys are supported by Azure OpenAI."},
    {"role": "user", "content": "Do other Azure AI services support this too?"}
  ]
)

print(response.choices[0].message.content)
```

可以透過 httpx 套件，設定 `verify=False` 參數來忽略 SSL 驗證，這樣就可以正確的呼叫 Azure OpenAI 服務。但是最終這代碼不會被用在生產環境，因為這樣的設定是不安全的。我們可以打開瀏覽器，輸入服務的網址，並且透過瀏覽器將 SSL 憑證下載下來，並且將憑證加入到系統的信任憑證中。

## 匯入或移除 SSL 憑證 (MacOS)

在 MacOS 或 Linux 系統中，我們可以透過 `security` 指令將 SSL 憑證加入到系統的信任憑證中，這樣就可以正確的驗證 SSL 憑證。以下是匯入 SSL 憑證的指令：

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain \
  ~/Downloads/xxxxxx.pem
```

查詢系統信任的憑證：

```bash
security find-certificate -a -c "xxxxxx.com" /Library/Keychains/System.keychain
```

底下是結果：

```bash
keychain: "/Library/Keychains/System.keychain"
version: 256
class: 0x80001000 
attributes:
    "alis"<blob>="example.com"
    "cenc"<uint32>=0x00000003 
    "ctyp"<uint32>=0x00000001 
....
```

移除 SSL 憑證：

```bash
sudo security delete-certificate -t -c "xxxxxx.com" /Library/Keychains/System.keychain
```

## 匯入 SSL 憑證 (Linux)

在 Linux 系統中，我們可以透過 `update-ca-certificates` 指令將 SSL 憑證加入到系統的信任憑證中，這樣就可以正確的驗證 SSL 憑證。以下是匯入 SSL 憑證的指令：

```bash
sudo cp ~/Downloads/xxxxxx.pem /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

查詢系統信任的憑證：

```bash
sudo trust list
```

移除 SSL 憑證：

```bash
sudo rm /usr/local/share/ca-certificates/xxxxxx.pem
sudo update-ca-certificates --fresh
```

## 結論

這篇只是介紹如何將私有的 SSL 憑證加入到系統的信任憑證中，這樣就可以正確的驗證 SSL 憑證。然而如何快速產私有憑證，可以參考之前寫的教學『[在本機端快速產生網站免費憑證 - mkcert][11]』。這些方法都可以讓我在在開發環境中快速產生憑證及驗證憑證是否正確。希望這些工具可以讓本機端開發更加方便。

[11]: https://blog.wu-boy.com/2018/07/mkcert-zero-config-tool-to-make-locally-trusted-development-certificates/
