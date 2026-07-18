# Espy Protocol Unified Monorepo

This repository contains the unified codebase for the Espy Protocol, divided into Frontend and Backend projects to ensure a clean separation of concerns and independent scalability.

## 📁 Project Structure

- **`/apps`**: The unified Flutter application covering Visitor, Professional, and Institution roles. Deployed as both a PWA and native Android/iOS app.
- **`/backend`**: Firebase DataConnect (PostgreSQL), Cloud Functions, and Security Rules.
- **`/packages`**: Shared Dart packages (models, core services) used by the frontend apps.

## 🚀 Getting Started

### 1. Frontend Development
1. Navigate to `/apps`.
2. Run `flutter pub get`.
3. Run `flutter run`.

### 2. Backend Development
1. Navigate to `/backend`.
2. Ensure you have the [Firebase CLI](https://firebase.google.com/docs/cli) installed.
3. Use `firebase dataconnect:sdk:generate` to sync schema changes with the frontend.

## 🛠️ Deployment

- **PWA Deployment**: Run the `/apps/deploy_pwa.ps1` script to build and deploy the web interface to both hosting targets.
- **Backend Deployment**: Use `firebase deploy` from the root to update functions, rules, and schema.

## 🤝 Synergy & Syncing

The Frontend and Backend projects are synced via the **Firebase DataConnect SDK**, which is automatically generated into `packages/shared_core/lib/generated/dataconnect`. 
Always regenerate the SDK after modifying the schema in `backend/dataconnect/schema.gql`.
