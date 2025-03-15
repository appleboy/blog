---
title: "Integrating Gitea with Jira Software Development Workflow"
date: 2025-03-15T12:22:24+08:00
author: appleboy
type: post
slug: gitea-jira-integration-en
share_img: /images/2025-03-15/blog-logo.png
categories:
  - git
  - gitea
  - jira
---

![blog logo](/images/2025-03-15/blog-logo.png)

Before diving in, let's familiarize ourselves with [Gitea][2] and [Jira][1]. For better context, I recommend reading "[Git Software Development Guide: Key to Improving Team Collaboration][0]" first.

[0]: https://blog.wu-boy.com/2025/01/git-software-development-guide-key-to-improving-team-collaboration-en/

[Gitea][2] is a lightweight self-hosted Git server written in Go, providing teams with an easily deployable code management solution. It supports multiple operating systems including Linux, Windows, and macOS, while offering comprehensive features for code review, issue tracking, and Wiki management—all essential tools for enhancing team collaboration.

[Jira][1] is Atlassian's professional project management and issue tracking system. Widely adopted by software development teams worldwide, Jira excels in issue tracking, supports agile methodologies (including Scrum and Kanban), and provides robust data analytics capabilities to optimize project management and team collaboration.

[1]: https://www.atlassian.com/software/jira
[2]: https://about.gitea.com/

<!--more-->

## Problem Description

In our department's development workflow, while Git serves as our version control system with Gitea as our Git server, and Jira handles our issue tracking, we faced a significant challenge: bridging the gap between code commits and Jira issues effectively.

While robust integration solutions exist for Jira with services like Bitbucket, GitHub, and GitLab, options for self-hosted Git servers like Gitea are limited. This integration challenge has been a [notable discussion point in the Gitea community][11].

[11]: https://github.com/go-gitea/gitea/issues/25852

While our team discovered a Jira plugin for Git integration, its implementation approach was less than ideal. The plugin required Jira to periodically scan the Git server's commit history to establish associations between commits and Jira issues. Although this method achieved basic integration, it was inefficient and required the Jira server to have direct access to the Git server, including downloading source code to retrieve historical records. This setup posed security concerns, particularly in large enterprise environments like ours, where departments operate under strict data access policies, making this integration method unsuitable.

To overcome these limitations, our team developed a custom Gitea-Jira integration solution that prioritizes both efficiency and security. We implemented a design where the Gitea service proactively establishes associations between commits and Jira issues, eliminating the need for Jira to access the Gitea server directly. This architecture not only significantly improves performance but also maintains data security. The implementation is straightforward, primarily leveraging [Gitea Action][22] in combination with the [Jira API][23]. Here's an illustration of the integration:

[22]: https://docs.gitea.com/usage/actions/overview
[23]: https://developer.atlassian.com/server/jira/platform/rest/v10004/

![comment](/images/2025-03-15/jira-git-comment.png)

By recording Jira issue numbers in commit logs, developers can directly view related commit content in Jira issues, effectively improving the tracking and management efficiency of the code development process.

## Design Process

Prior to implementation, we needed to establish a clear mapping between our software development workflow and Jira states to ensure effective progress tracking. Our workflow encompasses these key states:

1. Backlog: Issues to be processed
2. Open: Issues under development
3. In Progress: Issues being worked on
4. Code Review: Code under review
5. Under Test: Testing phase
6. Resolved: Issues resolved
7. Closed: Issues closed

![flow](/images/2025-03-15/jira-software-flow.png)

This is a basic software development process framework that teams can adjust according to their actual needs. In this process, each issue has a specific state, and developers can perform corresponding operations based on the issue state, ensuring the development process can be effectively tracked and managed. We mapped the following key state transitions with Git workflows:

1. Backlog → In Progress: Open new branch for development
2. In Progress → Code Review: Submit code for review
3. Code Review → Resolved: Code review completed

We expect the development team to follow these processes strictly and automatically update Jira issue states through Git commits, making the entire development process more streamlined and automated.

## Integrating Jira with Gitea Action

We chose Gitea Action as our integration tool because it's a native feature that provides comprehensive support for Git operation events while offering flexible integration capabilities. For technical implementation details, refer to the [appleboy/jira-action](https://github.com/appleboy/jira-action) project.

### Creating New Branches

```yaml
name: jira integration

on:
  create:
    types:
      - branch

jobs:
  jira-branch:
    runs-on: ubuntu-latest
    if: github.event.ref_type == 'branch'
    name: create new branch
    steps:
      - name: transition to in progress on branch event
        uses: appleboy/jira-action@v0.2.0
        with:
          base_url: https://xxxxx.com
          insecure: true
          token: ${{ secrets.JIRA_TOKEN }}
          ref: ${{ github.ref_name }}
          transition: "Start Progress"
          assignee: ${{ github.actor }}
```

This YAML configuration file uses Gitea Action to integrate with Jira. When developers create new branches, the system automatically updates the corresponding Jira issue state to "In Progress" and assigns the issue to the current developer. In the configuration, the `ref` parameter automatically includes the new branch name, `transition` specifies the Jira state name, and `assignee` sets the issue owner.

### Committing Code

During development, developers need to include the Jira issue number (e.g., `GAIS-123`) in the commit message for each code commit. This way, the system can automatically establish associations between code commits and corresponding Jira issues.

```yaml
name: jira integration

on:
  push:
    branches:
      - "*"

jobs:
  jira-push-event:
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    name: transition to in progress on push event
    steps:
      - name: transition to in progress on push event
        uses: appleboy/jira-action@v0.2.0
        with:
          base_url: https://xxxxx.com
          insecure: true
          token: ${{ secrets.JIRA_TOKEN }}
          ref: ${{ github.event.head_commit.message }}
          transition: "Start Progress"
          assignee: ${{ github.event.head_commit.author.username }}
          comment: |
            🧑‍💻 [~${{ github.event.pusher.username }}] push code to repository

            See the detailed information from [commit link|${{ github.event.head_commit.url }}].

            ${{ github.event.head_commit.message }}
```

When Action receives a Push Event, it automatically parses the Commit Log content to extract the Jira issue number, then updates the corresponding Jira issue state to `In Progress` and assigns it to the current developer. Additionally, Action adds a comment in the Jira issue recording the detailed information of this commit.

![push event](/images/2025-03-15/gitea-push-event.png)

### Submitting Code for Review

The system monitors Pull Request status changes ([`opened`, `closed`]) and automatically updates the corresponding Jira issue state to "Code Review".

```yaml
on:
  pull_request_target:
    types: [opened, closed]

jobs:
  open-pull-request:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request_target' && github.event.action == 'opened'
    name: transition to in review when pull request is created
    steps:
      - name: transition to in review when pull request is created
        uses: appleboy/jira-action@v0.2.0
        with:
          base_url: https://xxxxx.com
          insecure: true
          token: ${{ secrets.JIRA_TOKEN }}
          ref: ${{ github.event.pull_request.title }}
          transition: "Finish Coding"
```

![pull request](/images/2025-03-15/gitea-pull-request-event.png)

### Code Review Completion

The system monitors Pull Request status, and when it detects a status change to `closed`, it automatically updates the corresponding Jira issue state to "Resolved".

```yaml
name: jira integration

on:
  pull_request:
    types:
      - closed

jobs:
  jira-merge-request:
    runs-on: ubuntu-latest
    if: ${{ github.event.pull_request.merged }}
    name: transition to Merge and Deploy
    steps:
      - name: transition to in review
        uses: appleboy/jira-action@v0.2.0
        with:
          base_url: https://xxxxx.com
          insecure: true
          token: ${{ secrets.JIRA_TOKEN }}
          ref: ${{ github.event.pull_request.title }}
          transition: "Merge and Deploy"
          resolution: "Fixed"
```

![pull request](/images/2025-03-15/gitea-merged-pr.png)

Beyond these state transitions, you can make adjustments based on actual needs, such as automatically sending email notifications to relevant personnel when code review passes, or automatically deploying to the test environment after code merging. These automated processes can more effectively track and manage the code development process. The biggest advantage of Gitea Action is its ability to handle various events, making the integration solution more flexible.

## Conclusion

Through this integration implementation, we've successfully bridged Gitea and Jira, creating a seamless workflow that enhances both efficiency and security. Developers now only need to reference Jira issue numbers in their commit messages, and the system handles all the necessary associations automatically.

Our current project, involving a team of 20 developers, has managed nearly 5,000 issues over two years, with an average of ten new issues daily. Managing this volume of work would be challenging without our automated solution.

This integration has not only streamlined our issue management but has also optimized our entire development process. By eliminating the need for manual Jira status updates, we've significantly improved efficiency while reducing human error. The success of this integration demonstrates the crucial role of automation tools in managing large-scale software development projects effectively.
