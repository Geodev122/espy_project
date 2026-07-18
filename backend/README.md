# Espy Backend Project

This directory contains all backend infrastructure for the Espy Protocol.

## 🏗️ Components

### 1. DataConnect (PostgreSQL)
The primary relational database schema is defined in `/dataconnect/schema.gql`. 
- **Connector**: Handles GQL queries and mutations.
- **SDK Generation**: Generates typed Dart code for the frontend.

### 2. Cloud Functions
Located in `/functions`, these handle:
- Payment fulfillments (WhishPay, Google Pay).
- Atomic token transactions.
- Automated notifications and broadcasting logic.

### 3. Security & Rules
- `firestore.rules`: Rules for legacy Firestore access.
- `storage.rules`: Security for profile images and document uploads.
- `database.rules.json`: RTDB rules for low-latency sync.

## 🚀 Deployment

Run from the root or this directory:
```bash
# Deploy everything
firebase deploy

# Deploy only specific parts
firebase deploy --only functions
firebase deploy --only dataconnect
```

## 🔄 Syncing with Frontend

After updating `schema.gql`, run:
```bash
firebase dataconnect:sdk:generate
```
This will update the generated classes in `packages/shared_core`.
