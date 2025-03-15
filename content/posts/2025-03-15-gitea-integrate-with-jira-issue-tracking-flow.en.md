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

By incorporating Jira issue numbers in commit logs, developers can seamlessly track related commit content within Jira issues, significantly enhancing the efficiency of code tracking and management processes.

## Design Process

Before implementation, we established a clear mapping between our software development workflow and Jira states to ensure comprehensive progress tracking. Our workflow is structured around these essential states:

1. Backlog: Pending issues awaiting prioritization
2. Open: Issues ready for development
3. In Progress: Issues actively being worked on
4. Code Review: Code undergoing peer review
5. Under Test: Issues in testing phase
6. Resolved: Successfully completed issues
7. Closed: Finalized and verified issues

![flow](/images/2025-03-15/jira-software-flow.png)

This framework provides a foundational software development process that teams can customize based on their specific requirements. Each issue progresses through distinct states, allowing developers to take appropriate actions at each stage. This structured approach ensures efficient tracking and management of the development process. We've established the following key state transitions that align with our Git workflows:

1. Backlog → In Progress: Initiated when a new development branch is created
2. In Progress → Code Review: Triggered when code is submitted for review
3. Code Review → Resolved: Completed when code review is approved

To maintain workflow efficiency, we require our development team to strictly adhere to these processes. Through automated Git commit integrations, Jira issue states are updated automatically, creating a streamlined and automated development pipeline.

## Integrating Jira with Gitea Action

We selected Gitea Action as our integration tool for its native functionality and comprehensive support for Git operations. It offers flexible integration capabilities while maintaining robust event handling. For detailed technical implementation, please refer to the [appleboy/jira-action](https://github.com/appleboy/jira-action) project.

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

This YAML configuration automatically integrates Gitea Action with Jira. Upon branch creation, the system updates the corresponding Jira issue status to "In Progress" and assigns it to the branch creator. Within the configuration, the `ref` parameter captures the new branch name, the `transition` field defines the target Jira state, and the `assignee` parameter determines the issue owner.

### Committing Code

To maintain traceability, developers must include the relevant Jira issue number (e.g., `GAIS-123`) in their commit messages. This practice enables the system to automatically create and maintain associations between code commits and their corresponding Jira issues.

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

When a Push Event is received, Action automatically extracts the Jira issue number from the commit message, updates the corresponding Jira issue status to `In Progress`, and assigns it to the committing developer. Furthermore, Action adds a detailed comment to the Jira issue containing the commit information.

![push event](/images/2025-03-15/gitea-push-event.png)

### Submitting Code for Review

The system actively monitors Pull Request status changes (`opened` and `closed`) and automatically transitions the associated Jira issue to the "Code Review" state.

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

The system continuously monitors Pull Request status changes and automatically transitions the corresponding Jira issue to `Resolved` when it detects a Pull Request has been closed. This automated workflow ensures immediate synchronization between code review completion and issue tracking.

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

Beyond these state transitions, the system can be customized to meet specific needs, such as automatically sending email notifications when code reviews are approved or triggering test environment deployments after code merging. These automated processes enhance tracking and management of the development workflow. Gitea Action's greatest strength lies in its versatility in handling various events, making it an exceptionally flexible integration solution.

## Conclusion

Our integration implementation has successfully bridged Gitea and Jira, creating a seamless workflow that enhances both efficiency and security. Developers simply need to reference Jira issue numbers in their commit messages, and the system automatically handles all necessary associations.

In our current project, a team of 20 developers has effectively managed nearly 5,000 issues over two years, processing an average of ten new issues daily. Such volume would be challenging to manage without our automated solution.

This integration has not only streamlined our issue management but also optimized our entire development process. By eliminating manual Jira status updates, we've significantly improved efficiency while reducing human error. The success of this integration demonstrates the essential role of automation tools in effectively managing large-scale software development projects.
