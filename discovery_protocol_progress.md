# Discovery Protocol Debugging & Progress Specification

## 1. Executive Summary & Objective
The primary objective of this initiative is to verify, debug, and ensure the robust operation of the Data Connect SDK queries—specifically `listProfessionalsDiscovery` and `listInstitutionsDiscovery`—within the React frontend application (`hope-support-suit`). These queries power the core discovery and swipe-matching interface in `useDiscovery.ts`.

## 2. Current Status & Key Findings

### A. GraphQL Query & Schema Definitions
- **Query Verification:** Both `listProfessionalsDiscovery` and `listInstitutionsDiscovery` are fully and correctly defined in `dataconnect/connector/queries.gql`.
- **Backend Alignment:** The queries correctly request necessary fields (e.g., `id`, `nameEn`, `nameAr`, `specialty`, `avgRating`, `latitude`, `longitude`, `whatsapp`, `photoUrl`, `isVerified`, `sectorId`) and enforce filtering criteria such as `isActive: true`.

### B. Generated SDK Verification
- **File Analysis:** We conducted a thorough audit of the generated SDK bundles in both `hope-support-suit/src/dataconnect` and `hope-support-suit/src/dataconnect-generated`.
- **Exports Confirmation:** Direct inspection confirmed that `index.d.ts`, `index.cjs.js`, and `esm/index.esm.js` contain complete TypeScript signatures and runtime exports for `listProfessionalsDiscovery`, `listInstitutionsDiscovery`, and their respective `QueryRef` helpers.
- **Tooling Clarification:** Previous investigations encountered false negatives when searching for these definitions using `grep_search` with line-matching enabled. We determined that `git grep -nI` treats the large generated declaration and bundle files as binary/incompatible, skipping them during line-by-line searches. Direct AST/file viewing confirmed 100% presence and correctness of the SDK methods.

### C. Frontend Service Integration (`dataConnect.ts` & `useDiscovery.ts`)
- **Middleware Mapping:** `src/shared/services/dataConnect.ts` imports the SDK bundle via `import * as dcOps from '@/dataconnect'` and executes queries dynamically via `(dcOps as any)[queryName](dataConnect, variables)`.
- **Hook Implementation:** `src/shared/hooks/useDiscovery.ts` successfully delegates to `executeQuery('listProfessionalsDiscovery', { limit: 100 })` and `executeQuery('listInstitutionsDiscovery', { limit: 100 })` when in professional or institution search modes.

## 3. End Goal & Next Steps (Action Plan for Continuation)

When development resumes on this module, the following sequential steps must be executed to finalize the Discovery Protocol:

1. **End-to-End Runtime Verification:**
   - Launch the frontend application in development/preview mode and open the Discovery/Swipe UI.
   - Inspect network payloads and Data Connect logs to confirm successful execution and data hydration from the Cloud SQL Postgres backend.

2. **Enhanced Error Handling & Empty State Disambiguation:**
   - Update `useDiscovery.ts` to distinguish between an empty result set (e.g., no active professionals matching a specific governorate/sector filter) and a legitimate GraphQL/network failure.
   - Provide informative, user-friendly toast notifications or UI placeholders when queues are empty.

3. **Match Celebration & Interaction Telemetry:**
   - Verify the swipe interaction tracking (`recordSwipeInteraction`) to ensure right-swipes (favorites) and left-swipes (skips) are correctly logged to the Firebase Realtime Database.
   - Validate the `matchCelebration` modal/animation trigger when a mutual connection or high-affinity match occurs.

## 4. Environment & Tooling Notes
- **Path Aliasing:** `@/dataconnect` is mapped in `tsconfig.json` directly to `./src/dataconnect`.
- **Data Connect Emulator / Production:** Ensure the correct environment target (production Cloud SQL instance vs. local PGLite emulator) is active depending on the testing phase.


Overview of Newly Explored Definitions (SDK Functions & Refs)
The final section of the SDK defines the concrete function overrides and reference objects (QueryRef / MutationRef) used to execute operations against your Data Connect service.

1. Core Mutations
System & Audit: createEmergencyNumber, updateEmergencyNumber, createAuditLog
Notifications: createNotification, markNotificationRead
Analytics & Discovery: recordAnalytics, recordDiscoverySwipe, incrementProfessionalSwipeCount
Payments & Subscriptions: createPaymentRecord, activateProfessionalMembership, activateInstitutionMembership, recordPayment
Services & Credentials: createService, updateService, deleteService, addProfessionalCredential
Admin & Moderation: toggleProfessionalHonorBadge, toggleInstitutionHonorBadge, adminUpdateProfessional, adminUpdateInstitution, adminHardDeleteProfessional, adminHardDeleteInstitution
2. Core Queries
Professional Discovery & Management: listProfessionalsDiscovery, listProfessionals, searchProfessionals, getProfessional, getProfessionalByUid, getPendingProfessionals
Institution Directory: listInstitutionsDiscovery, listInstitutions, getInstitution, getInstitutionByUid, listInstitutionBranches, getInstitutionNetwork
Visitor & Favorites: getVisitor, getVisitorByUid, getVisitorByUuid, getVisitorFavorites
Taxonomy & Localization: listCategories, getCategory, listGovernorates, listCitiesByGovernorate
Matches & Reviews: getMatchesByVisitor, getMatchesByProfessional, getReviewsByProfessional, getPendingReviews
Memberships & Financials: listMembershipPackages, getMembershipPackages, getPaymentsByUser, getPaymentsByProfessional, getAllPayments, getProfessionalPayments
Community & Operations: listCommunityRequests, listEmergencyNumbers, getAuditLogs, getNotificationsByUser, getAnalyticsByDate, getAnalyticsSummary, getDiscoveryQueue, getRequestDiscoveryQueue, listServicesByProfessional, listServicesByInstitution, listServices
Admin Overviews: adminListProfessionals, adminListInstitutions
Key Architectural & Integration Takeaways
Dual Execution Patterns: Every query and mutation provides two function signatures:

Direct Execution: operationName(variables, options?) — uses the default initialized Data Connect instance.
Explicit Instance Execution: operationName(dc: DataConnect, variables, options?) — allows passing a custom configured Data Connect client (useful for multi-tenant setups or emulator switching).
Ref vs. Promise:

Calling operationNameRef(...) returns a QueryRef or MutationRef, which is ideal for integration with state management libraries (such as React Query or Vue Query) or when subscribing to real-time query updates.
Calling operationName(...) returns a QueryPromise or MutationPromise for direct async/await execution.
Strict Typing: All variables and return structures are strongly typed to match the GraphQL schema exactly, ensuring end-to-end type safety between your frontend UI components and the PostgreSQL backend.

markdown
### Summary of Work
* Explored the remaining lines (2401–3172) of `src/dataconnect/index.d.ts`.
* Cataloged all available query and mutation function signatures, reference generators, and admin/moderation execution contracts.
* Identified the standard invocation patterns (`Ref` vs `Promise` and explicit `DataConnect` instance passing) to guide frontend integration.