---
title: "Step-by-Step Guide to Building MCP Server and Client with Golang (Model Context Protocol)"
date: 2025-07-08T15:42:58+08:00
author: appleboy
type: post
slug: step-by-step-golang-mcp-server-client-en
share_img: /images/2025-07-03/mcp-golang_1024x592.png
categories:
  - golang
  - mcp
---

![blog logo](/images/2025-07-03/mcp-golang_1024x592.png)

In 2025, I delivered a workshop at the [iThome Taiwan Cloud Summit][2] in Taipei, titled "**Step-by-Step Guide to Building MCP Server and Client with [Golang][4]** ([Model Context Protocol][1])". The goal of this workshop was to help developers understand how to implement the MCP protocol using Golang, providing practical code examples and hands-on guidance. I have organized all workshop materials into a GitHub repository, which you can find at [go-training/mcp-workshop](https://github.com/go-training/mcp-workshop). For detailed workshop content, please [refer to this link][3].

[1]: https://modelcontextprotocol.io/introduction
[2]: https://cloudsummit.ithome.com.tw/2025/
[3]: https://cloudsummit.ithome.com.tw/2025/lab-page/3721
[4]: https://go.dev/

<!--more-->

## Workshop Content

This workshop is composed of a series of practical modules, each demonstrating how to build an MCP (Model Context Protocol) server and its foundational infrastructure in Go.

- **[01. Basic MCP Server](https://github.com/go-training/mcp-workshop/tree/main/01-basic-mcp/):**

  - Provides a minimal MCP server implementation supporting both stdio and HTTP, using Gin. Demonstrates server setup, tool registration, and best practices for logging and error handling.
  - _Key features:_ Dual stdio/HTTP channels, Gin integration, extensible tool registration

- **[02. Basic Token Passthrough](https://github.com/go-training/mcp-workshop/tree/main/02-basic-token-passthrough/):**

  - Supports transparent authentication token passthrough for HTTP and stdio, explaining context injection and tool development for authenticated requests.
  - _Key features:_ Token passthrough, context injection, authentication tool examples

- **[03. OAuth MCP Server](https://github.com/go-training/mcp-workshop/tree/main/03-oauth-mcp/):**

  - An MCP server protected by OAuth 2.0, demonstrating authorization, token, and resource metadata endpoints, including context token handling and tools for API authentication.
  - _Key features:_ OAuth 2.0 flow, protected endpoints, context token propagation, demo tools

- **[04. Observability](https://github.com/go-training/mcp-workshop/tree/main/04-observability/):**

  - Observability and tracing for MCP servers, integrating OpenTelemetry and structured logging, including metrics, detailed tracing, and error reporting.
  - _Key features:_ Tracing, structured logging, observability middleware, error reporting

- **[05. MCP Proxy](https://github.com/go-training/mcp-workshop/tree/main/05-mcp-proxy/):**
  - A proxy server that aggregates multiple MCP servers into a single endpoint. Supports real-time streaming, centralized configuration, and enhanced security.
  - _Key features:_ Unified entry point, SSE/HTTP streaming, flexible configuration, improved security

## Slides

{{< speakerdeck id="b22ffee1bc884cb0a2628781a5668a20" >}}

The slides for this workshop have been uploaded to Speaker Deck and can be [viewed here](https://speakerdeck.com/appleboy/building-mcp-model-context-protocol-with-golang). In the 90-minute workshop, there was no time for everyone to practice because the [OAuth flow in MCP][11] is more complex, so a lot of time was spent explaining this part. I will write another article to introduce how to implement the OAuth flow in Golang.

[11]: https://modelcontextprotocol.io/specification/2025-06-18/basic/authorization

![oauth flow](/images/2025-07-03/oauth-flow-02_1024x824.png)

For the complete OAuth token flow, see the [MCP specification][11]. The detailed process can be seen in the simplified diagram below:

![oauth flow](/images/2025-07-03/oauth-flow_1024x872.png)

I will explain in detail how to implement this flow in Golang in a future article.

## On-site Photos

The event was attended by approximately 40 people. The venue was very spacious and lunch was provided. Thanks to the iThome team for the arrangements.

![workshop01](/images/2025-07-03/workshop01.png)

![workshop02](/images/2025-07-03/workshop02.png)

## Related Resources

- [MCP Official Website](https://modelcontextprotocol.io/)
- [Let's fix OAuth in MCP](https://aaronparecki.com/2025/04/03/15/oauth-for-model-context-protocol)
- [go-training/mcp-workshop](https://github.com/go-training/mcp-workshop)
