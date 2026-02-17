---
title: "Introduction to OAuth Client ID Metadata Document"
date: 2026-02-17T11:52:21+08:00
draft: false
slug: oauth-client-id-metadata-document
share_img: /images/2026-02-17/cover_1000x558.png
categories:
  - OAuth
  - MCP
---

![cover](/images/2026-02-17/cover_1000x558.png)

In 2025, I introduced MCP ([Model Context Protocol](https://modelcontextprotocol.io/docs/getting-started/intro)) at the iThome [Taiwan Cloud Summit](https://cloudsummit.ithome.com.tw/2025/). At that time, I mentioned that the official team has been continuously revising the authentication protocol to address complex authentication flows. The previous design involved DCR ([Dynamic Client Registration](https://datatracker.ietf.org/doc/html/rfc7591)), so as expected, on 2025/11/25, a new [Authorization mechanism](https://modelcontextprotocol.io/specification/2025-11-25/basic/authorization) was released. This authentication mechanism is called "[Client ID Metadata Documents, abbreviated as CIMD](https://datatracker.ietf.org/doc/draft-ietf-oauth-client-id-metadata-document/)".

When installing a Model Context Protocol (MCP) server, the most challenging part is often not the protocol itself, but how to establish trust between the client and server. If you've ever tried to connect an MCP client to an MCP server it has never encountered before, you've probably run into what's known as the "registration wall".

Pre-registering with every possible authorization server is simply not scalable, and while Dynamic Client Registration (DCR) helps, it lacks reliable mechanisms to verify client identity, making it vulnerable to phishing attacks. Beyond security concerns, DCR also creates operational overhead by generating an ever-growing number of duplicate client identities that need to be managed.

<!--more-->

The MCP community is gradually converging on a simpler, more secure default approach: [OAuth Client ID Metadata Document][1]. In this approach, the `client_id` is an HTTPS URL pointing to a small JSON file that describes the client. The authorization server fetches this document when needed, verifies the content, and processes it according to its own policies, all without prior coordination. So please remember that this new protocol primarily addresses MCP Client registration issues.

For those hearing about MCP for the first time, you can refer to my previous tutorial: "[Step-by-Step Guide to Developing MCP Server and Client with Golang (Model Context Protocol)](https://blog.wu-boy.com/2025/07/step-by-step-golang-mcp-server-client-zh-tw/)".

[1]: https://datatracker.ietf.org/doc/draft-ietf-oauth-client-id-metadata-document/

## Client Registration Pain Points

GitHub Issue #991 ([SEP-991](https://github.com/modelcontextprotocol/modelcontextprotocol/issues/991)) mentions three pain points:

### Pain Point 1: Pre-registration is Impractical

1. Developer pre-registration: MCP clients often ship without knowing which servers they'll encounter later
2. User manual registration: Requiring users to manually enter client data and manage credentials on the server side

### Pain Point 2: Dynamic Client Registration (DCR) Has Significant Limitations

While DCR (Dynamic Client Registration) is "dynamic", it causes the following problems in MCP environments:

1. Servers must maintain an unbounded client database: Since any client can register, servers need to maintain large database records and expiration management.
2. Servers can only trust "self-asserted" metadata: Self-asserted metadata poses security risks.

### Pain Point 3: MCP's Typical Scenario is "No Pre-existing Relationship"

MCP's core value lies in:

> Clients and servers that have never heard of each other need to be able to establish secure and reliable connections immediately.

For example:

1. A user wants to connect to a newly discovered MCP server
2. The server's author has never heard of this client
3. The client developer doesn't know about this server either

This is a common scenario in open protocol environments that must be addressed.

## Solution: OAuth Client ID Metadata Documents

The solution proposed by SEP-991 is a pattern using HTTPS URLs as Client IDs:

> Client ID is a URL → pointing to a JSON client metadata document.

### ✔ Solution 1: No Pre-registration Required

The server only needs to:

- Receive a client ID (which is actually an HTTPS URL)
- Fetch the metadata document from that URL
- Verify the domain as a trust anchor

No need to know the client in advance.

> Perfectly solves the impossibility of pre-registration and user manual configuration issues.

### ✔ Solution 2: No DCR Required, No Database Maintenance

Servers don't need to store client metadata because the metadata is provided by the client itself on a public URL and can be fetched at any time after going live.

> Servers don't need to store/expire/clean metadata.

### ✔ Solution 3: No Longer Relying on "Self-asserted" Data

Because metadata is hosted on the client's own HTTPS domain:

Servers establish trust based on the HTTPS domain (like OAuth mechanisms), rather than just trusting `client metadata`.

> Enhanced security.

### ✔ Solution 4: Perfectly Fits MCP's "No Pre-existing Relationship" Operating Model

Both servers and clients can:

1. Not need to know each other in advance
2. Still establish a verifiable trust chain (using URL domain as Trust Anchor) when they first meet

This is exactly what the MCP Ecosystem needs most.

## 📌 Summary: Pain Points vs. Solutions

| Pain Point                                                | Corresponding Solution (SEP-991)                              |
| --------------------------------------------------------- | ------------------------------------------------------------- |
| Developer can't pre-register with all Servers             | Client uses URL-based metadata, self-hosted, readable anytime |
| User manual registration has poor UX                      | Server doesn't need manual registration, just fetch metadata  |
| DCR causes Server to maintain unlimited DB                | URL-based metadata → no need for server to store data         |
| DCR trusts self-asserted metadata                         | Establish truly verifiable trust through HTTPS domain         |
| MCP's "no pre-existing relationship" scenario unsupported | URL-based registration is designed exactly for this scenario  |

## CIMD Flow

![CIMD](/images/2026-02-17/cimd-en.png)

The flow is simple, with four steps to understand:

### Client Self-hosts Metadata URL

The client creates a JSON document containing its metadata and hosts it at an HTTPS URL. Here's an actual VSCode example:

```json
{
  "application_type": "native",
  "client_id": "https://vscode.dev/oauth/client-metadata.json",
  "client_name": "Visual Studio Code",
  "client_uri": "https://vscode.dev/product",
  "grant_types": [
    "authorization_code",
    "refresh_token",
    "urn:ietf:params:oauth:grant-type:device_code"
  ],
  "response_types": ["code"],
  "redirect_uris": ["https://vscode.dev/redirect", "http://127.0.0.1:33418/"],
  "token_endpoint_auth_method": "none"
}
```

### Client Uses the URL as `client_id`

Instead of using a pre-registered client ID, the client directly passes the metadata URL:

> GET /authorize?client_id=https://vscode.dev/oauth/client-metadata.json&...

### Server Fetches and Validates Metadata

The authorization server fetches the JSON document from the client_id URL and validates it.

- Verify JSON structure and required fields
- Confirm that client_id matches the source URL
- Check redirect URIs and other parameters

### Server Displays Client Information on Consent Screen

The server displays `client_name` and `client_uri` to help users make informed consent decisions.

## Why This Approach is Perfect for MCP

MCP's core value is that any "capable client" should be able to communicate freely with any "compliant server". This is precisely why URL-based Client ID Metadata is particularly reasonable in an open, dynamic, cross-platform environment. It allows any client to introduce itself to any MCP server in a standardized, scalable, verifiable way without needing to establish a prior relationship, registration, or coordination.

### Trust Mechanism Without Prior Coordination

Servers don't need to maintain long-term registration databases or establish any prior agreements with clients. They can choose to accept all clients, restrict to specific trusted domains, or allow only a few specific URLs — entirely based on their own risk tolerance. This SEP positions it as a **server-driven trust model, not a client-driven registration process**.

### Stable and Consistent Identification

Since `client_id` is a URL, it represents the application itself, not a specific installation instance. This reduces the confusion caused by "generating a new ID for each installation" and allows operators to identify clients in a clearer, more persistent way.

### Redirect URI Attestation

`redirect_uris` are explicitly bound in the client's Metadata Document. This makes it nearly impossible for attackers to sneak in malicious callbacks, as the server will only accept URLs listed in the JSON document and enforce matching.

### Extremely Low Implementation Cost

For most applications, providing a static JSON file requires almost no additional cost. Even for desktop applications, they typically have an official website for downloads, and the same website can effortlessly provide the metadata document.

## Conclusion

The CIMD specification proposes a new approach that allows OAuth clients to directly use a URL as their client_id. In this model, authorization servers can retrieve the client's publicly hosted JSON Metadata in real-time via that URL, eliminating the need to first create an "OAuth Application" in a manual backend to obtain a fixed Client ID. In other words, the traditional process of "having to pre-register the client with each authorization server" is now replaced by clients self-hosting their identity information; authorization servers can dynamically retrieve and validate during the authorization flow. This not only removes the cumbersome pre-registration requirement but also allows numerous, dynamic, multi-source clients to complete identity verification and mutual trust establishment in a more concise and secure manner.

In short, Client ID Metadata not only significantly reduces the burden of traditional registration processes but also allows servers to obtain clearer, more trustworthy client identity signals, truly knowing who the connecting client is.

## References

- [Client ID Metadata Document Adopted by the OAuth Working Group](https://aaronparecki.com/2025/10/08/4/cimd)
- [Client ID Metadata Documents](https://client.dev/)
- [Building MCP with OAuth Client ID Metadata (CIMD)](https://stytch.com/blog/oauth-client-id-metadata-mcp/)
- [Evolving OAuth Client Registration in the Model Context Protocol](https://blog.modelcontextprotocol.io/posts/client_registration/)
- [MCP authentication and authorization implementation guide](https://stytch.com/blog/MCP-authentication-and-authorization-guide/)
- [OAuth Client ID Metadata Document (CIMD) From Authlete](https://www.authlete.com/developers/cimd/)
