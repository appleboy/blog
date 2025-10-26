---
title: "From Natural Language to K8s Operations: The MCP Architecture and Practice of kubectl-ai"
date: 2025-10-25T10:54:53+08:00
slug: from-natural-language-to-k8s-operations-the-mcp-architecture-and-practice-of-kubectl-ai-en
share_img: /images/2025-10-25/blog-cover_1024x983.png
categories:
  - kubernetes
  - AI
  - kubectl-ai
  - mcp-server
  - mcp-client
---

![blog cover](/images/2025-10-25/blog-cover_1024x983.png)

[kubectl-ai][1] is a revolutionary open-source project that seamlessly integrates Large Language Models (LLMs) with [Kubernetes][2] operations, enabling users to interact intelligently with K8s clusters using natural language. This article explores how this innovative technology addresses the pain points of traditional [kubectl][3] command complexity and significantly lowers the barrier to entry for Kubernetes users.

<!--more-->

We'll dive deep into kubectl-ai's core architecture, including its Agent conversation management system, extensible tool framework, and innovative application of the [Model Context Protocol (MCP)][4]. The tool supports multiple LLM providers—from Google Gemini, Anthropic Sonnet, and Azure OpenAI to locally deployed models—and features a dual MCP mode design (MCP-Server + MCP-Client).

[1]:https://github.com/GoogleCloudPlatform/kubectl-ai
[2]:https://kubernetes.io/
[3]:https://kubernetes.io/docs/reference/kubectl/
[4]:https://modelcontextprotocol.io/docs/getting-started/intro

## KubeSummit Presentation Slides

{{< speakerdeck id="9861a365e82e4eccb9f0f4db6548bfe8" >}}

This was my first time participating in the [2025 Taiwan KubeSummit Conference][12]. The presentation slides have been uploaded to Speaker Deck and are available on [Speaker Deck][11]. The 40-minute talk covered the following topics:

1. Why do we need kubectl-ai?
2. Three kubectl-ai use case scenarios
3. kubectl-ai's Agent architecture breakdown

[11]:https://speakerdeck.com/appleboy/from-natural-language-to-k8s-operations-the-mcp-architecture-and-practice-of-kubectl-ai
[12]:https://k8s.ithome.com.tw/2025/session-page/4096

Let's dive into the three powerful use case scenarios of kubectl-ai.

## Three Major kubectl-ai Use Case Scenarios

### 1. K8s Problem Diagnostic Assistant

In day-to-day Kubernetes operations, encountering various errors and anomalies is the norm. kubectl-ai serves as an intelligent diagnostic assistant that can quickly identify issues and provide solutions through natural language problem descriptions. For example, users can ask "Why won't Nginx start?" and kubectl-ai will analyze the cluster state and provide specific troubleshooting steps and recommendations.

Let's use the following YAML example to create an Nginx Deployment.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:wrong-tag  # wrong tag
        resources:
          requests:
            memory: "10Gi"      # wrong value
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  selector:
    app: nginx
  ports:
  - port: 80
```

As you can see, the Deployment above contains two errors: first, the Nginx image tag is incorrect; second, the memory request value is too high. When we ask kubectl-ai "Why won't Nginx start?", it analyzes these configuration errors and provides specific solutions.

![demo01](/images/2025-10-25/demo01_1024x826.png)

In summary, kubectl-ai as a K8s diagnostic assistant significantly improves operational efficiency and reduces troubleshooting time, allowing operations teams to focus more on core business needs. Of course, I know many will say that similar functionality can be achieved through [Claude Code][15], but kubectl-ai is specifically designed for Kubernetes and can understand K8s operational mechanisms more deeply, providing more precise diagnostic recommendations. Beyond this, kubectl-ai offers two additional major features: MCP Server + MCP Client modes. Let's explore these further.

[15]:https://docs.claude.com/en/docs/claude-code/overview

### 2. MCP-Server Mode: Extending LLM Capabilities

![mcp-server](/images/2025-10-25/mcp-server_1024x696.png)

MCP-Server mode allows kubectl-ai to act as a bridge, integrating multiple LLM capabilities into Kubernetes operations. In this mode, kubectl-ai can invoke external LLM services such as Google Gemini, Anthropic Sonnet, or Azure OpenAI to handle complex natural language requests. You can start the MCP-Server with just one command:

```bash
kubectl-ai --mcp-server \
  --mcp-server-mode \
  streamable-http \
  --http-port 9080
```

Use the following command in Claude Code to connect to the MCP-Server:

```bash
claude mcp add --transport http kubernetes http://localhost:9080/mcp
```

kubectl-ai provides two different toolsets:

1. bash: For executing basic shell commands, suitable for handling simple tasks.
2. kubectl: Specifically designed for Kubernetes operations, capable of generating and executing kubectl commands.

You can then interact with kubectl-ai through Claude Code or other MCP protocol-compliant clients. For example, you can enter "Please check the status of all Pods" in Claude Code, and kubectl-ai will invoke the backend LLM to generate the corresponding kubectl command, execute it, and return the results.

Beyond the above functionality, MCP-Server mode also supports custom tool extensions, allowing users to add new operational tools based on specific needs, further enhancing system flexibility and scalability. You can also connect multiple MCP-Server instances to implement more complex workflows and collaborative operations.

```yaml
servers:
  - name: permiflow
    url: http://localhost:8080/mcp
  - name: jira-server
    url: https://localhost:8081/mcp
    skipVerify: true
    auth:
      type: "api-key"
      apiKey: "Token xxxxxxx"
      headerName: "Authorization"
```

Add `--external-tools` to enable external tool support:

```bash
kubectl-ai --mcp-server \
  --mcp-server-mode \
  streamable-http \
  --http-port 9080 \
  --external-tools
```

### 3. MCP-Client Mode: Multiple Services with One Command

![mcp-client](/images/2025-10-25/mcp-client_1024x529.png)

Traditionally, when we want to scan RBAC security reports with kubectl, organize them, and send emails to supervisors or notifications via Slack, we typically need to write complex scripts to implement these functions. With kubectl-ai's MCP-Client mode, these tasks can be accomplished with just one command.

For example, the following natural language instruction:

> Scan RBAC permissions in the srv-gitea namespace, identify ServiceAccounts with excessive permissions, and create a Jira issue in the GAIA project with a summary of findings included in the description.

```bash
kubectl-ai --mcp-client \
  "xxxxxxxxxxxxxxxxx"
```

In this example, kubectl-ai automatically generates the appropriate kubectl commands to scan RBAC permissions in the specified namespace, identifies over-privileged ServiceAccounts, then uses the Jira API to create a new issue with a summary of the scan results included in the description. This not only simplifies the operational workflow but also greatly improves work efficiency.

Therefore, MCP-Client mode enables users to easily invoke multiple services and tools through simple natural language instructions, implementing complex workflows without writing tedious scripts, significantly lowering the technical barrier.

## Conclusion

[kubectl-ai][1] brings revolutionary changes to Kubernetes operations through its innovative MCP architecture. Whether serving as an intelligent diagnostic assistant or extending LLM capabilities and simplifying operational workflows through MCP-Server and MCP-Client modes, kubectl-ai demonstrates its powerful practical value. As the Kubernetes ecosystem continues to evolve, kubectl-ai is poised to become an indispensable tool for operations teams, helping enterprises achieve more efficient and intelligent cloud-native operations management.
