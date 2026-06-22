# Espy Project — Multi-Repo Restructuring Guide

The codebase has been divided into two distinct repositories to improve focus and scalability. Both repositories share the **same Firebase project** and **Firestore schema**.

## 🏗️ Repository Architecture

### 1. Award Portfolio (`D:/repositories/Award-Portfolio`)
- **Main Site**: React-based portfolio showcase.
- **Goal**: Public visibility and legacy project history.
- **Deployment**: `firebase deploy --only hosting:main`

### 2. Espy Project (`D:/repositories/Espy-Project`)
- **Admin PWA**: Flutter-based terminal for project governance.
- **Visitor App**: Native Flutter app (with dev PWA) for patients/visitors.
- **Pro App**: Native Flutter app (with dev PWA) for Professionals and Institutions.
- **Shared Core**: A library at `packages/shared_core` ensuring all 3 apps stay synced on models, themes, and services.

## 🚀 Development & Testing

### To test the PWAs (Temporary):
1. Navigate to the app folder (e.g., `apps/visitor_app`).
2. Run `flutter run -d chrome`.

### To deploy specific PWAs:
- **Admin**: `npm run deploy:admin`
- **Visitor**: `npm run deploy:visitor`
- **Pro**: `npm run deploy:pro`

## 🐞 Sync Debugging
I have integrated a **Sync Debug Console** into all three apps. 
- **Trigger**: In `Debug` builds, a red bug icon appears at the bottom right.
- **Features**: Real-time logging of Auth changes, Firestore reads/writes, and synchronization events.
- **Shared logic**: The console logic resides in `packages/shared_core/lib/services/debug_service.dart`.

## 📊 Shared Backend Logic
All clinical logic, matching algorithms, and **WhishPay** processing are centralized in the `Espy-Project/functions` folder. Any changes made here will apply to both the Portfolio and the Espy ecosystem since they share the same database.

## 🛠️ Maintenance
- **Shared Models**: If you update the Firestore schema, update the models in `packages/shared_core/lib/models`.
- **WhishPay**: Only the `Espy-Project` should manage payment functions to ensure credential security.
