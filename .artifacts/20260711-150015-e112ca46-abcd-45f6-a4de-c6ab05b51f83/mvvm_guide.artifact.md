# 📖 Espy Architectural Standard: MVVM & Project Separation

This document defines the **enforced** architectural rules for the Espy project. These rules are mandatory for all future development to ensure scalability, type-safety, and a clean separation of concerns.

## 🏛️ Rule 1: Strict MVVM Structure
All frontend features must follow the MVVM (Model-ViewModel-View) pattern without exception.

### **1. Models (`shared_core/lib/models/`)**
- **Definition**: Plain Old Dart Objects (PODOs) representing data entities.
- **Responsibility**: Serialization (JSON/Firestore/DataConnect) and basic data validation.
- **Constraint**: Models must NEVER contain business logic or UI-related code.

### **2. ViewModels (`shared_core/lib/services/` or `app/lib/viewmodels/`)**
- **Definition**: Classes extending `ChangeNotifier` (or similar state management) that act as the single source of truth for the View.
- **Responsibility**:
  - Fetching data from services/repositories.
  - Processing business logic.
  - Exposing reactive state to the View.
- **Constraint**: ViewModels must NEVER import `dart:ui` or `package:flutter/material.dart` (except for basic types if strictly necessary, though preferred to avoid). They should be unit-testable without a Flutter environment.

### **3. Views (`app/lib/screens/` and `app/lib/widgets/`)**
- **Definition**: Flutter Widgets that build the UI.
- **Responsibility**:
  - Binding to ViewModel state using `Consumer` or `context.watch`.
  - Triggering actions on the ViewModel (e.g., `viewModel.submit()`).
- **Constraint**: Views must NEVER contain business logic. Conditional UI logic (e.g., showing a spinner) is allowed, but the *reason* for the logic (e.g., `isLoading`) must come from the ViewModel.

---

## 🏗️ Rule 2: Codebase-Level Project Separation
The codebase is strictly divided into **Frontend** and **Backend** domains to prevent dependency leaking and simplify deployment.

### **📁 Frontend (`/apps` & `/packages`)**
- **Scope**: Flutter applications, shared UI components, client-side business logic, and local storage.
- **Dependency Rule**: Frontend can only interact with the backend via defined API contracts (DataConnect GQL or Firebase Functions). Direct Firestore `instance` calls in Views are prohibited.

### **📁 Backend (`/backend`)**
- **Scope**: Firebase Functions, DataConnect Schemas/Queries/Mutations, Security Rules, and Admin scripts.
- **Responsibility**:
  - **DataConnect**: Centralized relational data management and row-level security.
  - **Functions**: Sensitive operations (Payments, Verification, Email) and background triggers.
- **Dependency Rule**: The backend project is self-contained. It contains its own `package.json` for Functions and its own schema definitions for DataConnect.

---

## ⚡ DataConnect as the Primary Data Bridge
Direct Firestore SDK usage in ViewModels is being phased out in favor of **Firebase DataConnect**.

1.  **GQL-First Development**: Define the data requirement in `.gql` files within the `backend/` directory.
2.  **Typed Code Generation**: Use the DataConnect Flutter SDK to generate typed repositories used by ViewModels.
3.  **Relational Logic**: Offload complex joins and aggregations to the DataConnect (PostgreSQL) backend.

---

## 🛠️ Enforcement Checklist
- [ ] Is this logic in a ViewModel and not a View?
- [ ] Is this Model reusable across different app roles?
- [ ] Does this UI change depend on a state variable in the ViewModel?
- [ ] Are all backend-specific files (SQL, TS/JS Functions) located in the `/backend` directory?
- [ ] Is the data being fetched through a typed service rather than raw Firestore calls?
