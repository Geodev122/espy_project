# Admin App Stability & Hierarchical Import Plan

This plan addresses the data fetching failures in the Admin App by implementing Firestore fallbacks and adds a hierarchical Excel (CSV) import for geography.

## User Review Required

> [!IMPORTANT]
> The DataConnect GraphQL backend is currently returning 404 for several operations, likely due to a propagation delay or deployment timeout. I will implement **Firestore Fallbacks** for all critical data lists to keep the Admin App functional while the backend stabilizes.

## Proposed Changes

### [Component] Repositories & Data Flow

#### [MODIFY] [DataConnectEspyRepository](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/viewmodels/dataconnect_espy_repository.dart)
- Implement `try/catch` wrappers for all DataConnect calls.
- Add Firestore as a secondary data source for:
    - `listSectors`, `listCategories`, `listCountries`, `listRegions`, `listCities`.
    - `searchUsersAdmin`.
    - `listMetadataTags`.
    - `listPendingOrders`, `listServiceModerationQueue`, `listRequestModerationQueue`.
- Ensure `Stream` methods combine DataConnect and Firestore snapshots or switch to Firestore if DataConnect fails.

#### [MODIFY] [DataConnectEspyRepository (User App)](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/user_app/lib/viewmodels/dataconnect_espy_repository.dart)
- Synchronize fallback logic to ensure stability for the end-user app as well.

---

### [Component] Taxonomy & Geography Seeding

#### [MODIFY] [TaxonomyViewModel](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/viewmodels/taxonomy_view_model.dart)
- Add `importHierarchicalCsv(String csvContent)`:
    - Expected columns: `Type, ID, ParentID, NameEn, NameAr, Value1 (IsoCode/Lat), Value2 (Flag/Lng)`.
    - Logic: Iteratively upsert entities based on Type, respecting hierarchy (Countries first, then Regions, then Cities).

#### [MODIFY] [TaxonomyManagerScreen](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/views/admin/modules/taxonomy_manager_screen.dart)
- Add an "IMPORT HIERARCHY (CSV)" button in the Geography section.
- Integrate with `file_picker` to allow the user to select an Excel-exported CSV.

---

### [Component] Infrastructure

#### [RETRY] DataConnect Deployment
- Attempt to deploy the connector and schema again with individual commands to bypass general timeout issues.

## Verification Plan

### Automated Tests
- Run `flutter build web` on both apps to ensure repository changes don't break compilation.

### Manual Verification
- **Login & Data**: Verify that Admin Dashboard lists (Users, Sectors, etc.) populate even if DataConnect returns 404 (by verifying fallback to Firestore).
- **Geography Import**: Test the "Import Hierarchy" with a sample Lebanon CSV:
  ```csv
  COUNTRY,LB,,Lebanon,لبنان,LB,🇱🇧
  REGION,LB-BEIRUT,LB,Beirut,بيروت,BEY,
  CITY,BEIRUT-CENTRAL,LB-BEIRUT,Beirut Central,بيروت المركزية,33.89,35.50
  ```
- **Live Sync**: Verify that imported data appears in the UI lists.
