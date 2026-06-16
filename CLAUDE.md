# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal tech blog (blog.wu-boy.com) built with Hugo static site generator using the beautifulhugo theme.

## Common Commands

```bash
# Local development server (with drafts)
hugo server -D

# Build for production
make build
# or: hugo --minify

# Clean build artifacts
make clean
```

## Architecture

- **Hugo Site**: Static site generator configured via `config.toml`
- **Theme**: beautifulhugo (git submodule in `themes/`)
- **Content**: Markdown posts in `content/posts/` with YAML front matter
- **Deployment**: GitHub Actions deploys to GitHub Pages on push to master

## Content Structure

Blog posts use this front matter format:
```yaml
---
title: "Post Title"
date: 2025-01-01T10:00:00+08:00
draft: false
slug: post-url-slug
share_img: /images/YYYY-MM-DD/image.png
categories:
  - Category1
  - Category2
---
```

Posts are named: `YYYY-MM-DD-slug-name.md`

Use `<!--more-->` to mark the excerpt/summary cutoff point.

## Permalink Format

Posts use `/:year/:month/:slug/` URL pattern.
