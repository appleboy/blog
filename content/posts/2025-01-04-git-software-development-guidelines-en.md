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

[Git][1] is a powerful distributed version control system created by [Linus Torvalds][2], initially designed for managing the Linux kernel source code. Its exceptional features include lightning-fast processing, robust data integrity, seamless support for non-linear development through branching, and sophisticated branch management capabilities. These characteristics make Git an essential tool in modern software development. While mastering basic Git operations is important, understanding its workflow is crucial for achieving optimal team collaboration. This article presents comprehensive Git software development guidelines to enhance team productivity.

As development teams expand, Git workflows naturally become more intricate. To maintain smooth collaboration, implementing well-structured Git development guidelines becomes essential. These guidelines help regulate team members' actions, ensuring code repository stability and maintainability. When properly followed, they not only expedite development cycles but also minimize errors and enhance overall code quality.

[1]: https://en.wikipedia.org/wiki/Git
[2]: https://en.wikipedia.org/wiki/Linus_Torvalds

## Git Software Development Workflow

The following diagram illustrates a streamlined Git development workflow that demonstrates effective team collaboration:

![logo](/images/2025-01-04/git-flow.png)

While this workflow may not suit all teams, it serves as a reference that can be adjusted according to specific circumstances. Let's explore some Git software development guidelines that help improve team collaboration efficiency.

<!--more-->

## 01. Git Prerequisites

Before diving into Git-based development, team members must complete these essential setup steps:

- Set up your Git username and email

```bash
git config --global user.name "Bo-Yi Wu"
git config --global user.email "bo-yi.wu@example.com"
```

- Configure Git commit signature verification by following the guide on "[Quick Setup for Git Commit Signature Verification][3]"
- Verify both settings are properly configured

```bash
git config --global --list
```

You should see settings like:

```bash
user.name=Bo-Yi Wu
user.email=bo-yi.wu@example.com
user.signingkey=/Users/xxxxxxx/.ssh/id_rsa.pub
```

[3]: https://blog.wu-boy.com/2023/10/git-commit-signature-verification/

Since our team uses [Gitea][4] as our Git server, you can see the green badge in your personal settings page:

![logo](/images/2025-01-04/gitea-signature-verification.png)

You can then test if commit signing works correctly. You should see something like this (your commit with a green box), confirming that the commit was indeed made by you:

![logo](/images/2025-01-04/gitea-commit-signature.png)

[4]: https://gitea.com/

## 02. Repository Creation Guidelines

When creating a new repository, certain guidelines should be followed to ensure consistency and maintainability. Here are some repository creation guidelines:

- Repository names should be descriptive, clearly expressing the repository's purpose.
- The repository's `README.md` file should include a project description, installation instructions, usage instructions, etc.
- The repository's `LICENSE` file should include project licensing information to ensure code legality.
- The repository's `.gitignore` file should include files and directories to be ignored, preventing unnecessary files from being committed to the repository.

In addition to the above guidelines, adjustments can be made based on actual circumstances to ensure repository consistency and maintainability. Here are some common mistakes to avoid:

- Do not commit large binary files to the repository, as this will make the repository too large and affect performance.
- Do not commit confidential information to the repository, as this will lead to information leakage and pose security risks.

Additionally, the company's internal Git server hosts repositories for multiple teams, with a total of 10,000 employees. To avoid unnecessary disputes, please follow these rules:

- Do not create repositories under **personal accounts** for collaboration with other teams.
- All repositories should be created as **Private** to avoid exposing code. If public access is needed, please discuss with department supervisors first.

## 03. Software Development Process Guidelines

### 3.1. Branch Management

We adopt GitHub Flow as our primary development guideline, which effectively reduces team communication costs. For more details, refer to the article "[GitHub Flow and Git Flow: When to Use Each][33]". When creating branches, be sure to associate them with Jira Issues. For example, to handle Issue GAIS-3210, use the following commands:

```bash
git checkout -b GAIS-3210
git push origin GAIS-3210
```

[33]: https://blog.wu-boy.com/2017/12/github-flow-vs-git-flow/

### 3.2 Commit Message Guidelines

- Clear and concise: Commit messages should be brief and clear, describing the changes made. Refer to [Conventional Commits][35].
- Format: Use a standard format, such as: `refactor(GAIS-2892): improve HTTP response handling and concurrency control`

[35]: https://www.conventionalcommits.org/

Types can include:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation update
- `style`: Code formatting
- `refactor`: Code refactoring
- `test`: Testing related
- `chore`: Maintenance work

The `GAIS-2892` corresponds to the Jira Issue ID. The Gitea system can automatically link to Jira Issues.

```bash
feat(ui): Add new Button component
^    ^    ^
|    |    |__ Subject (Describe the change in present tense)
|    |_______ Scope (Change scope)
|____________ Type (Change type)
```

Introduce [Gitea Action][36] with [semantic-pull-request][34] for automated checks

![logo](/images/2025-01-04/gitea-semantic-pull-request.png)

[34]: https://github.com/marketplace/actions/semantic-pull-request
[36]: https://docs.gitea.com/usage/actions/overview

### 3.3. Code Review

- Pull Request (PR): All code changes must go through PR and require **at least one team member's review and approval**.
- Automated Testing: Ensure all automated tests pass before merging. The team uses Gitea Actions for automated testing.
- Squash and Merge: Use Squash Commit to merge, keeping the version history clean and avoiding unnecessary Merge Commits.

![logo](/images/2025-01-04/gitea-squash-commit.png)

### 3.4. Version Release

- Tags: Use semantic tags to mark important versions, such as `v1.0.0`
- Semantic Versioning: Follow semver guidelines, with version numbers in the format `MAJOR.MINOR.PATCH`
  - MAJOR: Major updates, possibly including incompatible API changes
  - MINOR: New features, but backward compatible
  - PATCH: Bug fixes, backward compatible
- CI/CD: Integrate Push and Tag events with Gitea Actions for automatic deployment to test and production environments
- Release Notes: Use the [GoReleaser][55] tool to automatically generate release notes

[55]: https://goreleaser.com/

![logo](/images/2025-01-04/gitea-release-note.png)

### 3.5. Security

- During software development, do not include personal sensitive information in the git repo
  - Use `.env` files to store sensitive information
  - Add `.env` files to the `.gitignore` list
- Set deployment-related sensitive information directly in Gitea Secret

![logo](/images/2025-01-04/gitea-secret.png)

### 3.6 Development Documentation

Many developers have encountered difficulties running services in local environments. Therefore, the development team must detail the following in the README.md file for future team members' reference:

- Installation steps
- Execution methods
- Testing methods
- Deployment process
- Usage instructions

### 3.7 Code Standards

Consistency: Follow the team's agreed [code style guide][40] to maintain code consistency. Below is the code style guide for developing Go language projects:

[40]: https://google.github.io/styleguide/

- Use the [golangci-lint][43] tool to check code standards
- Use the [gofmt][44] tool to format code
- Use the [go vet][45] tool to check code standards

[43]: https://golangci-lint.run/
[44]: https://golang.org/cmd/gofmt/
[45]: https://pkg.go.dev/golang.org/x/tools/cmd/vet

## Conclusion

This article provides some Git software development guidelines aimed at improving team collaboration efficiency. The main content includes:

1. **Prerequisites**: Ensure team members correctly set up Git usernames, emails, and commit signature verification.
2. **Repository Creation Guidelines**:
   - Use descriptive names
   - Include `README.md`, `LICENSE`, and `.gitignore` files
   - Avoid committing large binary files and confidential information
   - Follow rules for creating private repositories within the company
3. **Software Development Process Guidelines**:
   - **Branch Management**: Adopt GitHub Flow and link to Jira Issues
   - **Commit Message Guidelines**: Use Conventional Commits format
   - **Code Review**: Make changes through PR and use automated testing
   - **Version Release**: Use tags and semantic versioning, and integrate automated deployment
   - **Security**: Use `.env` files and Gitea Secret for sensitive information
   - **Development Documentation**: Detail installation, execution, testing, deployment, and usage instructions in the `README.md` file
   - **Code Standards**: Follow code style guides and use tools to check and format code

These Git software development guidelines aim to help improve team collaboration efficiency. Of course, these guidelines are just a reference, and specific practices need to be adjusted based on the team's actual situation. We hope these guidelines help you better use Git and improve team collaboration efficiency.
