# 🛠️ Support Suite Workstation Context

You are working in the **Support Suite** standalone workstation.

## 📍 Important Structural Context

- This directory is a **Directory Junction** pointing to `D:\repositories\AWARD Site\hope-support-suit`.
- This is **NOT** a standalone Git repository. It is a subfolder of the master repo at `D:\repositories\AWARD Site`.
- **ALL Git operations** must be performed in the Master Repo root: `D:\repositories\AWARD Site`.

## 📖 Master Guide

For full details on development, deployment, and synchronization logic, please refer to the master guide in the root of the main repository:
👉 `../../WORKSTATION_GUIDE.md` (physically located in the parent directory of the main repo).

## 🚀 Local Deployment

- Hosting Target: `support-suit`
- Command: `firebase deploy --only hosting:support-suit`
