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

Before we begin, let's understand what [Gitea][2] and [Jira][1] are. I recommend reading "[Git Software Development Guide: Key to Improving Team Collaboration][0]" first to better understand the following content.

[0]: https://blog.wu-boy.com/2025/01/git-software-development-guide-key-to-improving-team-collaboration-en/

[Gitea][2] is a lightweight self-hosted Git server developed in Go language, offering teams an easy-to-deploy code management solution. Besides supporting multiple operating systems like Linux, Windows, and macOS, it features comprehensive code review, issue tracking, and Wiki functionalities that significantly enhance team collaboration efficiency.

[Jira][1] is a professional project management and issue tracking system developed by Atlassian. Widely adopted by software development teams, Jira not only provides complete issue tracking functionality but also supports agile development processes (such as Scrum and Kanban) and rich data analytics features, effectively helping teams manage project progress and improve collaboration quality.

[1]: https://www.atlassian.com/software/jira
[2]: https://about.gitea.com/

<!--more-->

## Problem Description

In our department's software development process, Git serves as the primary version control system, with Gitea functioning as the Git server. Development teams use Jira for issue tracking and management during program development. However, since Gitea and Jira are two separate systems, establishing an effective connection between code commits and Jira issues has become a crucial challenge we need to address.

While there are many solutions available for integrating Jira with Git services like Bitbucket, GitHub, and GitLab, there are relatively few integration options for self-hosted Git servers like Gitea. This issue has been [discussed in the Gitea community][11], with users seeking suitable solutions.

[11]: https://github.com/go-gitea/gitea/issues/25852

Our team found a Jira plugin for Git integration, but its underlying implementation for integrating Gitea with Jira involves Jira periodically scanning the Git server's commit records to establish associations between commits and Jira issues. While this approach achieves the integration goal, it's not ideal in terms of efficiency and requires the Jira server to have direct access to the Git server and download source code to obtain historical records. Such setup may raise security concerns in certain environments, especially in large enterprises like ours where departments have strict data access restrictions, making this integration method unacceptable.

To address this issue, our team decided to develop our own Gitea-Jira integration solution to improve efficiency and ensure data security. We adopted a design where the Gitea service actively establishes associations between commits and Jira issues, rather than having the Jira service access the Gitea server. This architecture not only significantly improves efficiency but also ensures data access security. The implementation is quite simple, mainly utilizing [Gitea Action][22] in conjunction with [Jira API][23]. Here's a diagram of the integration:

[22]: https://docs.gitea.com/usage/actions/overview
[23]: https://developer.atlassian.com/server/jira/platform/rest/v10004/

![comment](/images/2025-03-15/jira-git-comment.png)

By recording Jira issue numbers in commit logs, developers can directly view related commit content in Jira issues, effectively improving the tracking and management efficiency of the code development process.

## Design Process

Before project execution, the team needs to map software development workflows to Jira states for more effective project progress tracking. Here are the basic software development workflow states we designed:

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

Gitea Action is one of Gitea platform's core features that can automatically trigger preset tasks when Git operations occur (such as Commit, Push, etc.), like sending email notifications, Slack messages, or executing custom scripts. We can utilize this feature to implement automated integration between Gitea and Jira, establishing real-time associations between commits and Jira issues.

Why did we specifically choose Gitea Action for this integration? Mainly because it's a native Gitea feature that not only fully supports various Git operation events (such as Push, Pull Request, Issue Comment, etc.) but also allows more flexible handling of integration requirements. For more implementation details, you can refer to the [appleboy/jira-action](https://github.com/appleboy/jira-action) open-source project.

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

Through the above integration design process, our team successfully achieved seamless integration between Gitea and Jira. This integration solution not only improves work efficiency but also ensures system security. Developers only need to tag Jira issue numbers in commit messages, and the system automatically establishes associations, greatly simplifying the tracking and management process. Meanwhile, we've also established a complete software development process guide to help team members follow standard operating procedures, effectively improving team collaboration efficiency.

Currently, our team is executing a large-scale project involving approximately 20 developers. Over the two years since the project's inception, we've accumulated nearly 5,000 issues, with more than ten new issues being added daily. Without the assistance of such automation tools, effectively managing such a large volume of issues would be a significant challenge.

Through the Gitea and Jira integration solution, we've not only resolved issue management concerns but also comprehensively optimized the development process. Compared to the previous approach where developers needed to manually update states in Jira, the automated process not only improves efficiency but also significantly reduces the risk of human error. This integration solution has brought significant benefits to the team, fully demonstrating the importance of automation tools in large-scale software development projects.
