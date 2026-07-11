# 🚀 Espy Backend: Firestore to DataConnect Migration Guide

This document outlines the detailed audit of the current backend and the phased flow to migrate 100% of the logic to **Firebase DataConnect (PostgreSQL)**.

## 📊 Current Backend Audit

### 1. Data Silos (Firestore Collections)
*   **Users/Profiles**: Split across `users`, `directory_professionals`, `directory_institutions`, and `directory_visitors`.
*   **Ledger**: Managed in `wallet_ledger`.
*   **Asset Logic**: `practicePins`, `serviceSlots`, and `broadcastsBought` are scattered across multiple documents.
*   **Locations**: Stored as maps/lists inside user docs, making spatial queries complex.

### 2. Logic Triggers (Cloud Functions)
*   **Transactions**: Handled via `db.runTransaction` in `spendTokens` and `redeemRechargeCode`.
*   **Cross-DB Sync**: RTDB is used for low-latency dashboard updates (syncing `walletBalance`).
*   **Webhooks**: Express app handling WhishPay server-to-server callbacks.

---

## 🏛️ Proposed Relational Schema (DataConnect)
The new schema (see `backend/dataconnect/schema.gql`) introduces:
1.  **Strict Relations**: Users are linked to their specific role tables via foreign keys.
2.  **Normalized Ledger**: All token movements are recorded in a central `WalletLedger` table.
3.  **Spatial Nodes**: `LocationNode` table allows for efficient geospatial indexing (PGVector).
4.  **Atomic Assets**: Centralized tracking of slots, pins, and credits.

---

## 🔄 Phased Migration Flow

### **Phase 1: Dual-Write & Shadow Schema (Grooming)**
*   **Step 1**: Deploy the DataConnect schema to Google Cloud SQL.
*   **Step 2**: Update `AuthService` to call `CreateUser` mutation upon new sign-ups (writing to both Firestore and DataConnect).
*   **Step 3**: Implementation of a "Migration Service" in Cloud Functions to backfill existing Firestore data into PostgreSQL.

### **Phase 2: Transition Critical Mutations (Logic Shift)**
*   **Step 4**: Replace `spendTokens` Cloud Function logic with a **DataConnect Mutation**. Leverage PostgreSQL transactions to handle balance deductions and asset increments atomically.
*   **Step 5**: Port `redeemRechargeCode` to DataConnect. This replaces the complex `db.runTransaction` with a single GQL mutation call.

### **Phase 3: Repository Cutover (Frontend Shift)**
*   **Step 6**: Implement `DataConnectEspyRepository` in Flutter using the generated SDK.
*   **Step 7**: Toggle the Provider in `main.dart` from `FirestoreEspyRepository` to `DataConnectEspyRepository`.
*   **Step 8**: Verify real-time updates via GQL Subscriptions, replacing the RTDB sync logic.

### **Phase 4: Function & Firestore Retirement (Cleanup)**
*   **Step 9**: Move WhishPay callback fulfillment from Firestore to DataConnect mutations.
*   **Step 10**: Disable Firestore triggers and RTDB listeners.
*   **Step 11**: Final data wipe from Firestore collections once data integrity is verified in SQL.

---

## ⚖️ Key Advantages of the Migration
*   **Type Safety**: No more `Map<String, dynamic>` debugging; every field is typed and validated at the schema level.
*   **Complex Joins**: Fetching a Professional *with* their Services and Locations in a single request.
*   **Transaction Integrity**: PostgreSQL provides superior ACID compliance compared to NoSQL transactions.
*   **Performance**: Optimized spatial queries for the "Pins of Presence" map.
