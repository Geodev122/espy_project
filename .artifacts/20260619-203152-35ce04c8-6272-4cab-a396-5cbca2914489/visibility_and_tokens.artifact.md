# Espy Protocol: Visibility & Tokenization Architecture

This document details the current logic for network elements (Pins, Slots, Broadcasts) and outlines the phase 2 roadmap for a token-based economy.

---

## Part 1: Current Cumulative Visibility System

### 1. Core Elements & Logic

| Element | Definition | Visibility Logic | Persistence |
| :--- | :--- | :--- | :--- |
| **Main Pin** | Primary location (Hub) | Always visible if `isActive: true`. | Lifetime |
| **Extra Pin** | Secondary locations | Visible if `visibilityExpiresAt > now`. | Additive/Expiring |
| **Service Slot** | Capacity to list protocols | Service is visible if `isAllocated: true`. | Cumulative Quota |
| **Broadcast** | Push notification to radius | Instant one-time event per credit. | Consumable |

### 2. The Purchase Workflow
1.  **Selection**: Pro selects units in `SubscriptionHubScreen`.
2.  **Payment**: Transaction initiated via `WhishPayService` or `GooglePayService`.
3.  **Fulfillment (Cloud Functions)**:
    *   `membership-fulfillment.js` is triggered.
    *   **Pins**: Increments `practicePins` field in user profile.
    *   **Slots**: Increments `serviceSlots` field.
    *   **Broadcasts**: Increments `broadcastsBought` pool.
    *   **Visibility**: Extends `visibilityExpiresAt` by 30 days per unit bought.
4.  **Database Intersections**:
    *   **Firestore**: Primary source for `directory_professionals` and `directory_institutions`.
    *   **RTDB**: Mirrors data for high-speed synchronization with the Visitor App.

### 3. Admin Governance
*   **Registry Monitoring**: Admin sees `isApproved` and `isActive` status in the Registry Page.
*   **Suspension**: Setting `isActive: false` instantly masks the professional from the Visitor App map and search via the `getAllProviders` stream join.
*   **Audit**: Every transaction creates a record in `directory_membership_transactions` for financial tracking.

---

## Part 2: Proposed Tokenized Ecosystem (Roadmap)

To improve system performance and sales monitoring, we will move to a **Recharge & Spend** model.

### 1. New Core Component: The Espy Wallet & Pricing
Instead of buying Pins/Slots directly with USD each time, Pros buy **Espy Tokens** ($E).

#### Global Pricing Registry (`directory_settings/token_pricing`):
| Action | Default Pro Cost | Default Inst Cost | Validity |
| :--- | :--- | :--- | :--- |
| **New Extra Pin** | 500 $E | 800 $E | 30 Days |
| **Renew Extra Pin** | 400 $E | 600 $E | 30 Days |
| **New Service Slot** | 300 $E | 500 $E | 30 Days |
| **Renew Service Slot** | 200 $E | 400 $E | 30 Days |
| **Broadcast Credit** | 1000 $E | 1500 $E | 1 Use |

#### Proposed Database Schema Changes:
*   **User Profile (`users/{uid}`)**:
    ```json
    {
      "walletBalance": 5000,
      "tokenTier": "Silver",
      "role": "professional" | "institution"
    }
    ```
*   **[NEW] `token_recharge_cards`**:
    *   `id`: UUID (Code)
    *   `tokenValue`: 1000
    *   `priceUSD`: 10.00
    *   `targetRole`: 'professional' | 'institution' | 'any'
    *   `status`: 'active' | 'used'
*   **[NEW] `wallet_ledger`**:
    *   `uid`: User ID
    *   `type`: 'credit' (recharge) | 'debit' (spend)
    *   `amount`: 500
    *   `description`: "Renewed Secondary Pin - Hamra"
    *   `timestamp`: serverTimestamp()

### 2. Interface Upgrades

#### A. Admin Dashboard (Flutter Web)
*   **Recharge Management**:
    *   Create a "Minting Terminal" to generate bulk recharge codes.
    *   Filter codes by Role (Pro/Inst) to prevent cross-role usage.
*   **Pricing Control**:
    *   Live editor for the `token_pricing` registry to adjust costs globally without code redeploy.
*   **Economic Audit**:
    *   Real-time graph showing "Tokens Burned" vs "USD Collected".

#### B. Pro App (Flutter Native)
*   **The Hub Header**: Replace "Subscription" text with a live `walletBalance` widget.
*   **Internal Shop**:
    *   Remove direct WhishPay button from the wizard/store.
    *   Replace with "Burn Tokens" action buttons.
    *   "Low Balance" alerts with direct shortcut to the "Recharge" page.
*   **Recharge Screen**: A simple input for Card Codes + "Buy Digital Bundle" (direct USD pay).

#### C. Onboarding Wizard
*   **Cleanup**: Remove any "Pay to Start" logic.
*   **Auto-Wallet**: Initialize every new user with 0 tokens (or a small "Welcome" gift of 100 $E).

### 3. Implementation Strategy & Backend Sync

#### Step A: Code Card Redemption
*   **`rechargeWallet(code)`**: A Cloud Function that:
    1.  Checks if the code exists and is `active`.
    2.  Verifies user `role` matches card `targetRole`.
    3.  Sets card to `used`.
    4.  Increments `walletBalance` atomically.
    5.  Writes to `wallet_ledger`.

#### Step B: Atomic Spending Engine
*   **`spendTokens(action, elementId)`**:
    1.  Reads cost from `token_pricing` registry.
    2.  Checks if `walletBalance >= cost`.
    3.  Performs a **Firestore Transaction**:
        *   Deduct tokens from user.
        *   Update the specific element (e.g., set `visibilityExpiresAt` to `now + 30d`).
        *   Log the debit in the ledger.

### 4. Database Improvements & Synched Operations

#### A. The Atomic Spending Engine (`spendTokensHandler`)
To ensure high performance and zero desync, token spending is handled via a **Firestore Transaction**:
1.  **Read**: Fetch user balance and the specific element state (e.g., current Pin expiry).
2.  **Verify**: Cost check against `walletBalance`.
3.  **Update**:
    *   `users/{uid}`: Deduct balance, increment `tokensUsed`.
    *   `directory_professionals/{uid}` (or Institutions): Mirror user profile updates.
    *   `wallet_ledger/{ledgerId}`: Create an immutable record of the "Burn".
4.  **Sync**: The Cloud Function triggers an immediate update to the **Real-Time Database (RTDB)** under `users/${userId}/walletBalance`, which is what the Pro App listens to for instantaneous UI feedback.

#### B. The Global Pricing Registry
Admins manage costs in `directory_settings/token_pricing`. This allows for seasonal promotions (e.g., "50% off Broadcasts") without app updates.
*   **Pro Configuration**: `pro_new_pin`, `pro_renew_pin`, etc.
*   **Institution Configuration**: `inst_new_pin`, `inst_renew_pin`, etc.

---

### 5. Advanced Admin Profit & Sales Monitoring

The Admin Dashboard is upgraded with a **Network Economy Command Center**:

#### A. Minting Terminal (Recharge Cards)
*   **Code Generation**: Admins generate 12-digit alphanumeric codes (e.g., `ESPY-XXXX-XXXX`).
*   **Role Constraint**: Cards are bound to `targetRole: 'professional'` or `targetRole: 'institution'`.
*   **Batch Tracking**: Track codes from "Generated" -> "Redeemed".

#### B. Ledger Auditing
*   **Revenue Mapping**: USD revenue is calculated at the point of **Recharge Card generation** (Cash-in).
*   **Value Burn Mapping**: Profitability is monitored by tracking which elements Pros spend tokens on. If 80% of tokens are spent on "Broadcasts", the system flags this as a high-demand feature for future pricing adjustments.

#### C. Operational Transparency
*   **User Ledger View**: Admins can view a specific Professional's entire wallet history (ledger) to resolve disputes or confirm successful activations.

---

### 6. Operational Direct Benefits (Pro App)

When a Pro spends tokens in the **Protocol Store**, the benefits are applied **globally and immediately**:

1.  **Pin Renewal**: The `visibilityExpiresAt` date is pushed forward in Firestore. The Visitor App's Map listener picks this up in real-time, preventing the marker from disappearing.
2.  **Slot Purchase**: The `serviceSlots` count is incremented. The "Service Manager" screen instantly unlocks the ability to toggle one more protocol to "Active".
3.  **Broadcast Activation**: A credit is added to the `broadcastsBought` pool. The "Dispatch" button is enabled immediately for use.
