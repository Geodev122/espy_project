# Espy Project Task List

## 🌍 Geographical Hierarchy & Global Anchor [100%]
- [x] Create `CountryModel` in `shared_core`.
- [x] Implement country management in `Admin FirestoreService`.
- [x] Update `SystemPage` (Admin) with Country table and stratification filters.
- [x] Update `FinancePage` (Admin) to stratify revenue by Country, Role, and Sector.
- [x] Mandatory triple-anchor selection in `LocationPickerModal` (App).

## 🏢 Pro Dashboard & Unified Terminology [100%]
- [x] Mass terminology migration: "Node" -> "PIN" (EN/AR).
- [x] Redesign Pro Dashboard with 4 boxes: PINs, SLOTs, BROADCASTs, VISIBILITY.
- [x] Implement "Quick Renew" logic for visibility in Dashboard.
- [x] Standardize fonts to **Montserrat** across all platforms for softness and cleanliness.

## 🪙 Token Management & Admin Terminal [100%]
- [x] Create `TokenManagementPage` in Admin PWA.
- [x] Implement "Element Packs" minting (Tokens + PINs + Slots + Broadcasts).
- [x] Implement atomic redemption logic in `AuthService` registration.
- [x] Integrated stratification in Fiscal Terminal analytics.

## 🛍️ Wallet Store & Fulfillment [100%]
- [x] Implement "Dynamic Billing" logic in Cloud Functions for stratified pricing.
- [x] Unified visibility renewal (30 days) and extra PIN/Slot purchases.
- [x] Configured Google Pay and Whish Pay integration.

## 🎨 UI/UX Redesign & Unification [100%]
- [x] Redesign Visitor Navigation: Removed labels, added active glow.
- [x] Unified Header: User avatar opens Drawer, dedicated Notification and Broadcast icons.
- [x] Match Page: Expanded card swipe area, header-only titles.
- [x] Map UI: Soft floating panel for Visibility Status and "Browse this area" action.
- [x] Global Font Unification (Montserrat).

## 🚀 Deployment & Integrity [100%]
- [x] Resolved Firestore permission errors for new geographical collections.
- [x] Fixed code-level interpolation and type errors in Admin PWA.
- [x] Commited and Pushed all changes to `master`.
- [x] Successfully built Admin PWA locally.
