---
title: "Git Software Development Guidelines: Improving Team Collaboration"
date: 2025-01-04T10:04:38+08:00
author: appleboy
type: post
slug: git-software-development-guide-key-to-improving-team-collaboration-en
share_img: /images/2025-01-04/git-flow.png
categories:
  - git
  - gitea
---

## Introduction

[Git][1] is a powerful distributed version control system engineered by [Linus Torvalds][2] specifically for Linux kernel development. Renowned for its exceptional speed, robust data integrity, and sophisticated branch management capabilities, Git has evolved into the industry standard for software version control. While mastering basic Git operations is fundamental, understanding its collaborative workflow is essential for effective team development. This guide presents comprehensive Git development practices to enhance team productivity.

The increasing complexity of modern software development makes Git management particularly challenging. To maximize team efficiency, establishing well-defined Git development guidelines becomes crucial. These guidelines serve to standardize team operations, maintain code stability, and ensure long-term maintainability. When properly implemented, these practices significantly streamline development workflows, minimize errors, and enhance overall code quality.

[1]: https://en.wikipedia.org/wiki/Git
[2]: https://en.wikipedia.org/wiki/Linus_Torvalds

## Git Software Development Workflow

Below is a simple Git software development workflow diagram, illustrating how team members collaborate in development:

![logo](/images/2025-01-04/git-flow.png)

The above workflow may not be suitable for all teams, but it can serve as a reference and be adjusted according to actual situations. Next, we will introduce some Git software development guidelines to help teams improve collaboration efficiency.

<!--more-->

## 01. Git Setup

Before diving into Git-based development, team members must complete several essential configuration steps to ensure proper Git functionality:

- First, set up your Git user name and email.

```bash
git config --global user.name "Bo-Yi Wu"
git config --global user.email "bo-yi.wu@example.com"
```

- Set up Git Commit Signature Verification by following the instructions in this article: [Quick Setup for Git Commit Signature Verification][3].
- Verify that the above settings are correctly configured.

```bash
git config --global --list
```

You should see the following settings:

```bash
user.name=Bo-Yi Wu
user.email=bo-yi.wu@example.com
user.signingkey=/Users/xxxxxxx/.ssh/id_rsa.pub
```

[3]: https://blog.wu-boy.com/2023/10/git-commit-signature-verification/

Since our team uses [Gitea][4] as the Git server, you can see a green badge on your personal settings page.

![logo](/images/2025-01-04/gitea-signature-verification.png)

Next, you can test whether the commit is correctly signed. Normally, you should see the following screen (with your commit showing a green box), which confirms that the commit was made by you.

![logo](/images/2025-01-04/gitea-commit-signature.png)

[4]: https://gitea.com/

## 02. Guidelines for Creating a New Repository

When establishing a new repository, follow these essential guidelines to ensure consistency and maintainability:

- Choose meaningful repository names that accurately reflect the project's purpose
- Craft comprehensive README.md files containing detailed project documentation
- Include appropriate LICENSE files to ensure proper legal compliance
- Maintain a thorough .gitignore configuration to exclude unnecessary files

To preserve repository health and security, avoid these common pitfalls:

- Never commit large binary files, as they significantly degrade repository performance
- Keep sensitive information strictly outside of version control

Given our enterprise-scale Git infrastructure supporting multiple teams (10,000+ employees), strictly observe these organizational policies:

- All team repositories must reside under organizational accounts, not personal ones
- Maintain repository privacy by default - public visibility requires management approval

## 03. Software Development Workflow Guidelines

### 3.1. Branch Management

Embrace GitHub Flow to streamline team communication. For detailed rationale, consult '[When to Use GitHub Flow and Git Flow][33]'. Link all feature branches to corresponding Jira issues for proper tracking:

```bash
git checkout -b GAIS-3210
git push origin GAIS-3210
```

[33]: https://blog.wu-boy.com/2017/12/github-flow-vs-git-flow/

### 3.2 Commit Message Guidelines

Maintain clear and structured commit messages following [Conventional Commits][35] standards:

[35]: https://www.conventionalcommits.org/

- Keep messages concise yet descriptive
- Follow the format: `type(scope): description`

Example: `refactor(GAIS-2892): optimize response handling and concurrency`

The types can be feat (feature), fix (bug fix), docs (documentation), style (formatting), refactor (refactoring), test (testing), chore (maintenance), etc.

The `GAIS-2892` corresponds to the Jira issue number. The Gitea system can integrate with Jira issue numbers.

```bash
feat(ui): Add `Button` component
^    ^    ^
|    |    |__ Subject
|    |_______ Scope
|____________ Type
```

Introduce [Gitea Action][36] with [semantic-pull-request][34] for automated checks.

![logo](/images/2025-01-04/gitea-semantic-pull-request.png)

[34]: https://github.com/marketplace/actions/semantic-pull-request
[36]: https://docs.gitea.com/usage/actions/overview

### 3.3. Code Review

- Pull Requests: All changes should be made through PRs and require **at least one team member's review and approval**.
- Automated Testing: Ensure all automated tests pass before merging. The team uses Gitea Action for automated testing.
- Use **Squash Commit** for merging: This keeps the history clean and avoids unnecessary merge commits.

![logo](/images/2025-01-04/gitea-squash-commit.png)

### 3.4. Version Release

- Tags: Use tags to mark important version points, such as v1.0.0.
- Semantic Versioning ([Semantic Versioning][42]): Follow semantic versioning rules, with the format MAJOR.MINOR.PATCH.
- Integrate Gitea Action with push and tag for automated deployment to staging and production environments.
- Use the [goreleaser][41] tool to quickly generate release notes.

[41]: https://goreleaser.com/
[42]: https://semver.org/

![logo](/images/2025-01-04/gitea-release-note.png)

### 3.5. Security

- During software development, do not include personal sensitive information in the git repository.
  - Use `.env` files to store sensitive information.
  - Add `.env` files to the `.gitignore` list.
- For deployment-related sensitive information, configure it directly in Gitea Secrets.

![logo](/images/2025-01-04/gitea-secret.png)

### 3.6 Documentation

It is common to encounter difficulties in running services in your own environment. Developers should write detailed `README.md` files to guide future colleagues. The documentation should include:

- Installation instructions
- Execution instructions
- Testing instructions
- Deployment instructions
- Usage instructions

### 3.7 Code Standards

Consistency: Follow the team's agreed-upon [code style guide][40] to maintain code consistency. Below is the code style guide for developing Go language projects:

[40]: https://google.github.io/styleguide/

- Use the [golangci-lint][43] tool to check code standards.
- Use the [gofmt][44] tool to format code.
- Use the [go vet][45] tool to check code standards.

[43]: https://golangci-lint.run/
[44]: https://golang.org/cmd/gofmt/
[45]: https://pkg.go.dev/golang.org/x/tools/cmd/vet

## Summary

This document provides some Git software development guidelines aimed at improving team collaboration efficiency. The main points include:

1. **Preliminary Setup**: Ensure team members correctly set up Git user name, email, and commit signature verification.
2. **Guidelines for Creating a New Repository**:
   - Use descriptive names.
   - Include `README.md`, `LICENSE`, and `.gitignore` files.
   - Avoid committing large binary files and sensitive information.
   - Follow internal rules for creating private repositories.
3. **Software Development Workflow Guidelines**:
   - **Branch Management**: Adopt GitHub Flow and link branches to Jira issues.
   - **Commit Message Guidelines**: Use the Conventional Commits format.
   - **Code Review**: Make changes through PRs and use automated testing.
   - **Version Release**: Use tags and semantic versioning, and integrate automated deployment.
   - **Security**: Use `.env` files and Gitea Secrets for sensitive information.
   - **Documentation**: Write detailed `README.md` files with installation, execution, testing, deployment, and usage instructions.
   - **Code Standards**: Follow the code style guide and use tools to check and format code.

These guidelines aim to help teams improve collaboration efficiency. They are intended as a reference and should be adjusted based on the team's actual situation. We hope these guidelines help you use Git more effectively and improve team collaboration.
