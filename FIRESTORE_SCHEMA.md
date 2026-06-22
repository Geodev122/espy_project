# Espy Protocol — Firestore Unified Schema v1.0

This document defines the shared schema and operational rules for the Espy Flutter ecosystem.

## 1. Core Collections

| Collection | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| **Users** | `/users/{uid}` | Master identity record. | Owner + Admin |
| **Professionals**| `/directory_professionals/{uid}`| Professional profiles. | Public Read |
| **Institutions** | `/directory_institutions/{uid}` | Institution profiles. | Public Read |
| **Visitors** | `/directory_visitors/{uid}` | Patient/Visitor data. | Owner + Admin |
| **Services** | `/directory_services/{docId}` | Clinical offerings. | Public Read |

## 2. Dynamic Operational Collections

### `directory_matches`
- **Purpose**: Record logical connections between Visitors and Professionals.
- **Fields**:
    - `visitorId`: string (ref)
    - `professionalId`: string (ref)
    - `status`: enum (requested, accepted, rejected)
    - `timestamp`: serverTimestamp

### `directory_interactions`
- **Purpose**: Low-latency swipe/engagement tracking.
- **Fields**:
    - `userId`: string
    - `targetId`: string
    - `type`: enum (view, favorite, swipe_right)

### `directory_membership_transactions`
- **Purpose**: WhishPay audit trail for visibility nodes.
- **Fields**:
    - `userId`: string
    - `amount`: number
    - `packageId`: string
    - `status`: enum (pending, success, failed)

## 3. Global Configuration

### `directory_settings/app_config`
- **Purpose**: Remote theme tokens and system toggles.
- **Keys**:
    - `maintenanceMode`: boolean
    - `featureFlags`: map
    - `themeTokens`: map

## 4. Role-Based Operations (CRUD)

| Action | Role Requirement | Backend Trigger |
| :--- | :--- | :--- |
| **Create Service** | `professional` or `institution` | Validates `serviceSlots` |
| **Approve Profile** | `admin` | Triggers `USER_VERIFIED` notification |
| **Match Patient** | `visitor` | Creates `directory_matches` entry |
| **Broadcast Signal**| `professional` | Deducts from `broadcastLimit` |
