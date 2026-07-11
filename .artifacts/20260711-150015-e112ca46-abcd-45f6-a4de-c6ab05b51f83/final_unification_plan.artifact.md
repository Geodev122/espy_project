# Final Unification & Organization Plan

This plan outlines the final steps to complete the Espy project refactoring, UI standardization, and codebase cleanup.

## Accomplished Tasks
- [x] Unified `visitor_app` and `pro_app` into `espy_app`.
- [x] Categorized screens by role in `lib/views/`.
- [x] Centralized reusable widgets in `packages/shared_core/lib/widgets/common/`.
- [x] Standardized imports to use `package:shared_core` for themes and widgets.
- [x] Initialized and expanded `backend/dataconnect/schema.gql`.
- [x] Deleted obsolete root-level files and redundant app directories.

## Remaining Steps

### 1. UI Unification (Shared Design System)
- **Standard Scaffold**: Migrate all screens to use `EspyScaffold` (from `shared_core`) to ensure consistent backgrounds and branding.
- **Form Refactor**: Unify `VisitorWizard`, `ProfessionalWizard`, and `InstitutionWizard` to share common form components (Input fields, Image Pickers).

### 2. MVVM Completion
- **Dashboard ViewModel**: Refactor `DashboardScreen` to bind to a `DashboardViewModel` instead of raw Firestore calls.
- **Wallet ViewModel**: Create a centralized logic for token purchases and ledger viewing.

### 3. Backend / Frontend Boundary
- **DataConnect CodeGen**: Run `firebase dataconnect:sdk:generate` once local environment is ready.
- **Service Layer**: Update `FirestoreService` to act as an abstract repository, allowing seamless switching between Firestore and DataConnect.

### 4. Final Cleanup
- **Assets Audit**: Remove any images or icons in `apps/assets` that were specific to the deleted sub-apps.
- **L10n Synchronization**: Merge any remaining unique keys from the old `visitor_app` ARB files into the unified `espy_app` ARB.

## Verification Plan
- **Role Switching**: Test that a user can sign in and see their role-specific dashboard without needing to switch apps.
- **Widget Consistency**: Verify that `EspyScaffold` renders correctly on both Visitor and Professional screens.
- **Backend Isolation**: Confirm no frontend code contains hardcoded SQL or logic that belongs in Firebase Functions.
