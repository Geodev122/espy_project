# Implementation Plan - Espy Tokenized Economy & Wallet System

Transition the cumulative visibility system into a fully tokenized "Espy Wallet" economy. This plan covers the renaming of the "Vault", implementation of role-specific pricing, recharge card redemption, and atomic token spending with real-time benefit activation.

## User Review Required

- **Token Exchange Rate**: Confirm $1 USD = 100 $E (Espy Tokens) as the baseline for all bundles.
- **Auto-Approval Confirmation**: All new Professional/Institution accounts remain `isApproved: true` and `isActive: true` by default.
- **Admin Minting**: Confirm the 12-digit alphanumeric format (e.g., ESPY-XXXX-XXXX) for physical/digital recharge cards.

## Proposed Changes

### 1. Renaming & Branding (pro_app)
Transform the "Vault" identity into the "Espy Wallet" globally.

#### [wallet_screen.dart](file:///D:/repositories/Espy-Project/apps/pro_app/lib/screens/profile/wallet_screen.dart)
- [NEW] Features a high-end **Balance Card** with `walletGradient`.
- Displays an immutable **Protocol Ledger** (Credit/Debit history).
- Links to the **Token Shop**.

#### [token_shop_screen.dart](file:///D:/repositories/Espy-Project/apps/pro_app/lib/screens/profile/token_shop_screen.dart)
- [NEW] **Tab 1: Recharge**: WhishPay bundle selection + Code Redemption field.
- [NEW] **Tab 2: Store**: Spending interface for Pins, Slots, and Broadcasts.

#### [app_shell.dart](file:///D:/repositories/Espy-Project/apps/pro_app/lib/screens/app_shell.dart)
- Rename bottom navigation item from "Vault" to "Wallet" with `LucideIcons.wallet`.

---

### 2. The Token Engine (Cloud Functions)
Implement the core logic for the recharge and burn cycle.

#### [token-functions.js](file:///D:/repositories/Espy-Project/functions/src/token-functions.js)
- **`redeemRechargeCode`**:
  - Validates `recharge_cards` collection (status, role, expiry).
  - Atomically increments `walletBalance` in `users/{uid}`.
- **`spendTokens`**:
  - Performs a Firestore Transaction to:
    1. Check balance against `token_pricing` registry.
    2. Deduct tokens and increment `tokensUsed`.
    3. **Apply Benefit**: Push `visibilityExpiresAt` or increment `serviceSlots`.
    4. Write to `wallet_ledger`.

#### [membership-fulfillment.js](file:///D:/repositories/Espy-Project/functions/src/membership-fulfillment.js)
- Refactor to handle direct USD-to-Token conversion upon successful WhishPay callback.

---

### 3. Governance Terminal (admin_pwa)
Upgrade the admin dashboard for sales monitoring and pricing control.

#### [system_page.dart](file:///D:/repositories/Espy-Project/apps/admin_pwa/lib/pages/system/system_page.dart)
- [NEW] **Minting Terminal**: Interface to generate batches of recharge codes restricted by role.
- [NEW] **Pricing Control**: Live editor for `directory_settings/token_pricing`.

#### [finance_page.dart](file:///D:/repositories/Espy-Project/apps/admin_pwa/lib/pages/finance/finance_page.dart)
- Update stats to show **USD Revenue** (Cash-in) vs. **Token Burn Rate** (Feature Usage).

---

### 4. Visibility Logic (visitor_app)
Ensure the Visitor App map and matching correctly interpret tokenized expiry.

#### [map_explore_screen.dart](file:///D:/repositories/Espy-Project/apps/visitor_app/lib/screens/map/map_explore_screen.dart)
- Permanent visibility for **Main Hub**.
- Expiry-based visibility for **Secondary Nodes** (calculated via `visibilityExpiresAt`).

## Verification Plan

### Automated Tests
- `flutter analyze` across all projects to ensure "Vault" -> "Wallet" rename didn't break references.
- Backend logic test: Trigger `redeemRechargeCode` and verify atomic balance update.

### Manual Verification
1. **Recharge Flow**: Enter a test code in Pro App -> Verify instant balance update via RTDB sync.
2. **Burn Flow**: Purchase "Renew Pin" -> Verify Pin `visibilityExpiresAt` pushed forward in Firestore and map remains active in Visitor App.
3. **Role Enforcement**: Attempt to redeem an "Institution" card on a "Professional" account -> Verify rejection.
4. **Admin Audit**: Check `wallet_ledger` in Firestore to confirm all "burn" actions are recorded correctly.
