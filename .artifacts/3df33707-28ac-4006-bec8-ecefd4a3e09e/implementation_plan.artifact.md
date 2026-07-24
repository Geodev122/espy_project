# Implementation Plan: Architecture Consolidation, Intelligence & Polish

This plan addresses findings from the MVVM and Backend audit. It focuses on consolidating shared logic into a central package, implementing advanced analytics workers, and polishing the user experience with high-fidelity components.

## User Review Required

> [!IMPORTANT]
> **Shared Core Package:** Moving models and shared ViewModels to a new package `packages/espy_core`. This will reduce code duplication but requires updating imports across both apps.
> **Backend Synchronization Workers:** Implementing a "Sync Worker" (simulated via client-side or separate Function) to populate the `AnalyticsSnapshot` table daily.
> **Heatmap Precision:** The heatmap will now use real aggregated data from the `AnalyticsSnapshot` instead of individual pin lookups for performance.

## Proposed Changes

### 1. Architecture: Consolidation (Shared Core)

#### [NEW] `packages/espy_core`
- Create a new Flutter package to host shared code.
- **Move Models:** All `lib/models/*.dart` files from both apps.
- **Move Services:** `AuthService`, `StorageService`, `WhishPayService`, `SoundService`.
- **Move Shared ViewModels:** `DashboardViewModel`, `WalletViewModel`, `DirectoryViewModel`.
- **Repository Interface:** Move `EspyRepository` to core.

---

### 2. Backend Intelligence (Workers & Analytics)

#### [MODIFY] [schema.gql](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/espy_service/schema/schema.gql)
- Add `ServiceMetric` table: `id`, `serviceId`, `views`, `contacts`, `shares` (Aggregated from `Interaction` table).

#### [MODIFY] `lib/viewmodels/admin_dashboard_view_model.dart`
- Implement `triggerAnalyticsSync()`: A method that aggregates raw `Transactions` and `Interactions` into `AnalyticsSnapshot`.

---

### 3. Admin App: Advanced Governance

#### [MODIFY] `lib/views/admin/modules/finance_manager_screen.dart`
- Add **Area Charts** for Revenue vs Profit comparison.
- Implement "Multi-Filter" for Transactions (Cluster by Sector, Role, and Country simultaneously).

#### [MODIFY] `lib/views/admin/modules/broadcast_manager_screen.dart`
- Implement **Broadcast Scheduling**: Allow setting `scheduledAt`.
- Add "Targeting Reach Preview": Shows how many users will be reached by the selected filters before sending.

#### [MODIFY] `lib/views/admin/modules/verifications_screen.dart`
- Add **Bulk Validation**: Select multiple pending users and approve/reject in one action.
- Add "Protocol Badge Editor": Assign special badges (e.g., "Honor Verified") during validation.

---

### 4. User App: UX Polish & High-Fidelity UI

#### [MODIFY] `lib/views/visitor/emergency/sos_hub_screen.dart`
- **Glassmorphism Styling**: Use `BackdropFilter` for SOS cards.
- **Lottie Animations**: Add subtle pulse animations for "Locating..." state.

#### [MODIFY] `lib/views/professional/profile/token_shop_screen.dart`
- **Tiered Presentation**: Distinct visual themes for Bronze, Silver, and Gold packages.
- **Sales Badges**: "POPULAR", "BEST VALUE", "LIMITED OFFER" based on dynamic flags.

#### [MODIFY] `lib/views/shared/map/map_explore_screen.dart`
- **Cluster Markers**: Implement `flutter_map_animations` or `supercluster` for dense marker areas.
- **Node Detail Sheet**: Overhaul the popup dialog into a modern `DraggableScrollableSheet`.

---

### 5. Backend Refactoring & Sync

#### [MODIFY] `lib/viewmodels/dataconnect_espy_repository.dart`
- Standardize all GQL calls into a `Result<T>` pattern for consistent error handling.
- Implement **Optimistic UI Updates**: Immediately reflect token spend/recharge in state before server confirmation.

## Phased Task List

### Phase 1: Shared Core Extraction
- [ ] Create `packages/espy_core` and configure `pubspec.yaml`.
- [ ] Move Models and shared ViewModels to core.
- [ ] Refactor imports in `admin_app` and `user_app`.

### Phase 2: Analytics & Performance Engine
- [ ] Implement Analytics aggregation logic.
- [ ] Build the "Reach Preview" for Broadcasts.
- [ ] Optimize Marker rendering with clustering.

### Phase 3: High-Fidelity Frontend
- [ ] SOS Hub Glassmorphism + Animations.
- [ ] Token Shop Tiered Styling.
- [ ] Map Node Detail Sheets (Modern Sheet UI).

### Phase 4: Verification & Stress Test
- [ ] Verify cross-app synchronization via Shared Core.
- [ ] Test Analytics Snapshot accuracy with 5000+ mock interactions.

## Verification Plan

### Automated Tests
- Widget tests for the new `DraggableScrollableSheet` map details.
- Integration tests for `espy_core` logic.

### Manual Verification
1. **Core:** Change a field in `UserModel` in core -> Verify both apps build and reflect the change.
2. **Analytics:** Perform 100 "Views" on a service -> Trigger Sync -> Verify `ServiceMetric` updates.
3. **Map:** Zoom out on map -> Verify markers cluster into numbered circles.
