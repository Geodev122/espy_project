# Mobile App Rebuild Progress (Flutter · Android Only)

| Component | Status | Description |
| :--- | :--- | :--- |
| **Theme & Design System** | ✅ Complete | Centralized `EspyTheme` with "Blue Flame" gradients & typography. |
| **Auth & Routing Gate** | ✅ Complete | `MainGate` + `AuthService` with Google Sign-In & persistence. |
| **Splash & Onboarding** | ✅ Complete | Modern launch sequence and high-impact welcome screen. |
| **App Shell** | ✅ Complete | Simplified 4-tab bottom navigation system (Espy Protocol). |
| **Professional Directory** | ✅ Complete | Modern card-based list with real-time Firestore sync. |
| **Professional Wizard** | ✅ Complete | Simplified 3-step registration form with animations. |
| **Community Feed** | ✅ Complete | "Help Board" for care requests with responding logic. |
| **Matching Engine** | ✅ Complete | Full-screen Tinder-style swipe interface for nodes. |
| **Map Explore** | ✅ Complete | OpenStreetMap (flutter_map) integration with custom markers. |
| **Vault (User Hub)** | ✅ Complete | Premium user dashboard for profile and settings. |
| **SOS Protocol** | ✅ Complete | Emergency contact list and live alert system. |
| **Service Manager** | ✅ Complete | CRUD interface for pros to manage offerings. |
| **Subscription & Vault** | ✅ Complete | Integration with payment system and transaction history. |
| **Widget Audit** | ✅ Complete | Full modernization for consistency and premium aesthetics. |

---

## 🏗 Modernized Architecture
- **Simplified UI**: Zero-inline styles; all components pull from the global `ThemeData`.
- **Dynamic Interactions**: Staggered animations and fade-ins used on every major screen.
- **Unified Identity**: Native Google Sign-In with automatic Firestore profile creation.
- **Real-time Authority**: Every list and feed uses `StreamBuilder` for instant sync with Admin PWA.
- **Sole Governance**: Administrative control is restricted to the **Admin Dashboard PWA**; the mobile app is for user-facing features only.
- **WhishPay Port**: Flutter-native HTTP service for WhishPay integration via Cloud Functions.

---

## 📅 Recent Actions
- **Subscription Hub**: Implemented `subscription_hub_screen.dart` for managing tiers and transactions.
- **Service Manager**: Created `service_manager_screen.dart` for professional offering management.
- **Vault Integration**: Linked SOS, Service Manager, and Subscriptions into the central User Hub.
- **Cleaned Admin Hub**: Removed accidental `admin_hub_screen.dart` from the mobile app to enforce PWA-only governance.
- **SOS Hub**: Implemented `sos_hub_screen.dart` for emergency protocol management.
- **WhishPay Service**: Implemented `whish_pay_service.dart` for Flutter.
- **SOS Logic**: Built `emergency_service.dart` to fetch numbers and send alerts.
- **User Sync**: Refined `firestore_service.dart` for user-centric data access.
- **Matching Engine**: Rebuilt from scratch using `flutter_card_swiper`.
- **Community Feed**: Implemented a modern custom list for care requests.
- **Vault Screen**: Created a luxury dashboard for user settings.
- **Welcome UI**: Redesigned for maximum brand impact with metallic Noir/Gold.
- **Final Cleanup**: Removed all legacy JS/Capacitor files from the mobile workspace.

---

## 🛠 Strategic Rebuild Guides (Backend & Interplay)

### 1. Unified Data Access (API to Firestore Native)
**Goal**: Transition from Express-based API calls to direct Firestore SDK communication.
*   **READ Operations**: Replace `GET /api/professionals` and `GET /api/visitors` with native Firestore listeners (`StreamBuilder` in Flutter, `onSnapshot` in React).
*   **WRITE Operations**: Use direct SDK writes for simple updates (e.g., updating a bio) governed by `firestore.rules`.
*   **Complex Logic (Cloud Functions)**: Replace monolithic `directoryApi` with discrete `https.onCall` functions:
    *   `initiateMembershipPayment`: Encapsulate secure WhishPay signature generation.
    *   `finalizeProfileApproval`: Atomic update across `directory_professionals`, `users`, and `directory_admin_logs`.
    *   `syncMasterMetadata`: Handle bulk imports of categories/governorates from CSV.

### 2. Backend Inspection & Service Cleanup
*   **DEPRECATE**: `directory-functions.js`. Deconstruct the Express app into modularized Cloud Functions (Gen 2).
*   **DELETE**: `registration-functions.js`. The registration logic is now natively handled by the Flutter Professional Wizard and the React PWA.
*   **CONSOLIDATE**: `directory-whishpay.js` and `subdomain-whishpay.js`. Standardize on a single payment handler for both the main event bookings and the Support Suite memberships.
*   **AUDIT**: Review `firestore.rules` to ensure `resource.data.userId == request.auth.uid` is strictly enforced for private profile edits while allowing public READs for verified content.

### 3. Admin Dashboard Page-by-Page Mapping
| Admin Page | Requirements | Source | Action |
| :--- | :--- | :--- | :--- |
| **Intelligence** | Aggregate registration metrics, platform split (Android vs PWA), and user engagement. | `directory_visitors`, `directory_interactions` | Use direct Firestore READ. Aggregate counts client-side for real-time dashboard feel. |
| **Professionals** | Moderation queue for new signups. Verification status toggle. | `directory_professionals` | Use direct READ for list. Use `approveProfile` (Cloud Function) for status transition. |
| **Revenue Hub** | List of all membership payments and à-la-carte receipts. | `directory_membership_transactions`, `directory_receipts` | Use direct READ. Align schema to ensure both collections share a common `paymentRef`. |
| **Audit Logs** | High-fidelity trail of all administrative actions. | `directory_admin_logs` | Use direct READ with `limit(100)` and pagination. |
| **Announcements** | Global broadcast system for network updates. | `directory_announcements` | Use direct WRITE. Set `status: 'pending'` by default; Admin PWA handles final publication. |
| **SOS Control** | Management of emergency agencies and verified phone numbers. | `directory_settings/app_config` | Use direct WRITE to the `emergency_sections` field. |

---

## 🛡 Verification & Unit Testing Nodes
*   **Node: Registration Auth**: Verify `users` doc creation in Flutter matches `PipelinePage` requirement.
*   **Node: SOS Stream**: Confirm `app_config` changes in PWA reflect in 1s on Android device.
*   **Node: WhishPay Cycle**: Test that `onCall` function generates same signature for both platforms.
*   **Node: Content Moderation**: Ensure `status: active` in `directory_community_requests` is the only trigger for Flutter feed visibility.

---

## 🛠 Rebuild Prompts & Instructions

### For Flutter (Data Layer)
*   **Prompt**: "Replace all remaining HTTP calls in `whish_pay_service.dart` with Firebase Functions `onCall` invocations once the backend migration is complete."
*   **Prompt**: "Ensure all Firestore queries in `firestore_service.dart` use the `directory_` prefix to match the security rules."

### For Admin Dashboard (Authority)
*   **Prompt**: "Update `legacy_shared/shared/services/directoryAPIService.ts` to use Firestore Native SDK for the Professionals and Visitors pages to eliminate API latency."
*   **Prompt**: "Implement a client-side filter for the Intelligence page that filters `directory_visitors` by the `source` field ('android' or 'pwa')."

---

## 📈 Rebuild Roadmap (Next Phase)
1. **[DONE]** Rewrite `directoryAPIService.ts` in `legacy_shared` to remove fetch-based calls in favor of Firestore SDK.
2. **[DONE]** Implement `verifyWhishPayment` as a discrete `onCall` function to replace the Express endpoint.
3. **[DONE]** Implement `finalizeProfileApproval` as a discrete `onCall` function for atomic updates.
4. **[DONE]** Audit and update `firestore.rules` for verified professional access and data privacy.
5. **[DONE]** Refactor Flutter `whish_pay_service.dart` to use `onCall` functions instead of HTTP.
6. **[DONE]** Finalize deconstruction of `directoryApi` (Express) by migrating all remaining logic to modular functions.
7. **[DONE]** Verify that `directory_visitors` metrics are correctly aggregated in the Admin Intelligence panel.
