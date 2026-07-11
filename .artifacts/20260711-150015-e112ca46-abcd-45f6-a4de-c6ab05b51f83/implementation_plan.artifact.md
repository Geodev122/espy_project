# Espy App Unification and MVVM/Project Separation Refinement

This plan outlines the steps to unify the separate apps into a single `espy_app` while enforcing a strict MVVM architecture and a clean separation between Frontend and Backend projects.

## Proposed Changes

### 1. Architecture Enforcement (Global Rules)
- **MVVM Integration**: Every view in the unified app will be refactored to bind to a dedicated or shared ViewModel (Service).
- **Backend Isolation**: All SQL/GQL and Cloud Function code will be strictly moved to the `backend/` root directory.

---

### 2. Frontend: Shared Core & Unification (`/apps`, `/packages`)

#### [shared_core](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/packages/shared_core/)
- **Models**: Audit all models in `lib/models/` to ensure they are PODOs without logic.
- **ViewModels (Services)**:
    - [NEW] `DirectoryViewModel`: Central logic for search/filter across all roles.
    - [REFACTOR] `AuthService` & `UserService`: Ensure they strictly act as ViewModels for authentication and profile management.

#### [Unified App (espy_app)](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/)
- **Routing**: `main.dart` and `MainGate` will use `Provider` to inject role-specific ViewModels.
- **Views**: Reorganize all screens into role-based subdirectories:
    - `lib/views/visitor/`
    - `lib/views/professional/`
    - `lib/views/institution/`
    - `lib/views/shared/` (e.g., Auth, Splash)

---

### 3. Backend: DataConnect & Functions (`/backend`)

#### [NEW] [dataconnect/](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/backend/dataconnect/)
- **Schema**: Define the master `schema.gql` reflecting the `Users`, `Professionals`, and `Services` relational structure.
- **Queries/Mutations**: Implement initial typed operations to replace raw Firestore calls in ViewModels.

#### [functions/](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/backend/functions/)
- Consolidate all existing Firebase Functions into this root-level directory.

---

## Verification Plan

### Automated Tests
- **ViewModel Tests**: Run `flutter test` on `packages/shared_core` to verify business logic isolation.
- **DataConnect Lint**: Run `firebase dataconnect:sdk:generate` to ensure schema-code alignment.

### Manual Verification
- **Role Switching**: Log in as each role to ensure the `MainGate` correctly initializes the appropriate ViewModel and View.
- **Backend Isolation**: Verify that no frontend code directly references `cloud_firestore` without going through a Service/ViewModel.
