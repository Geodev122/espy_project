# 🤖 AWARD-SITE Workstation & Repository Guide

This guide is for AI Agents (like Antigravity) to understand the dual-workstation architecture of this project.

## 🏗️ Repository Architecture

- **Master Repository**: `D:\repositories\AWARD Site`
- **Workstation 1 (Main Site)**: Accessible via the Master Repository root.
- **Workstation 2 (Support Suite)**: Accessible via the **Directory Junction** at `D:\repositories\Support Suite`.
- **Relationship**: `D:\repositories\Support Suite` is a live link to the subfolder `D:\repositories\AWARD Site\hope-support-suit`.

## 🔄 Synchronization Logic

- **Git**: This is a SINGLE repository. Any git commands (`add`, `commit`, `push`) must be performed in the **Master Repository** (`D:\repositories\AWARD Site`).
- **Junctions**: The `Support Suite` workstation is synchronized with the Master Repo in real-time. Changes in one are immediately reflected in the other.
- **Backend Shared Logic**:
  - `functions/` and `dataconnect/` are managed in the Master Repo root.
  - The Support Suite uses junctions to access these shared backend folders.

## 🚀 Deployment Targets

Each workstation has a tailored `firebase.json` for independent hosting:

1.  **Main Site**: Deploys to the **root domain** (Target: `main`).
2.  **Support Suite**: Deploys to the **subdomain** (Target: `support-suit`).

**Command for Deployment**:

- Main: `firebase deploy --only hosting:main`
- Support: `firebase deploy --only hosting:support-suit`

## 🛠️ Build Process

- Both projects use **Vite**.
- Build output for both is directed to a `dist/` folder in their respective roots.

## ⚠️ Important for AI Agents

- **NEVER** create separate Git repos for the Support Suite.
- **ALWAYS** perform Git operations in `D:\repositories\AWARD Site`.
- **PATH AWARENESS**: If working on the Support App, your relative paths in `D:\repositories\Support Suite` are mirrored at `D:\repositories\AWARD Site\hope-support-suit`.
