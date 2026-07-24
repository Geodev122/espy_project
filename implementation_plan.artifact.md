# Plan: App Normalization & Login Stability

Audit and synchronize the Admin and User apps' data models with the DataConnect/PostgreSQL schema, and resolve the initial login failure in the Admin App.

## User Review Required

> [!IMPORTANT]
> I will be updating core models (UserModel, ServiceModel, etc.) in both apps. This may require small adjustments in UI files that depend on these models. I will ensure both apps remain buildable.

## Proposed Changes

### [Component] Authentication & Bootstrap

#### [MODIFY] [AuthService.dart](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/viewmodels/auth_service.dart)
- Synchronize `_onAuthStateChanged` and `signInWithEmail` to prevent concurrent bootstrapping.
- Ensure `isLoading` accurately reflects the entire initialization process (auth check + profile fetch + auto-bootstrap).

### [Component] Data Models (Normalization)

#### [MODIFY] [UserModel.dart](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/models/user_model.dart)
- Add `adminNotes`.
- Ensure all factory methods handle both Firestore (CamelCase) and DataConnect (snake_case/CamelCase) keys consistently.

#### [MODIFY] [CountryModel.dart](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/models/country_model.dart)
- Add `isoCode`, `currency`, `timezone`.

#### [MODIFY] [ServiceModel.dart](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/models/service_model.dart)
- Add `sectorId`, `priceTagId`, `deliveryMode`, `moderationStatus`, `flagReason`, `createdAt`, `updatedAt`.

#### [MODIFY] [ProfessionalProfile.dart](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/models/professional_profile.dart)
- Add `isProfileValidated`, `verificationDocUrl`.

#### [MODIFY] [InstitutionProfile.dart](file:///C:/Users/Dell/StudioProjects/espy project/espy_project/apps/admin_app/lib/models/institution_profile.dart)
- Add `bioEn`, `bioAr`, `isProfileValidated`, `verificationDocUrl`.

#### [NEW] New Domain Models
- Create `SectorModel.dart`, `CategoryModel.dart`, `RegionModel.dart`, `CityModel.dart` to replace generic `Map` usage.

### [Component] User App Synchronization
- Replicate all model changes to `apps/user_app/lib/models/` to ensure parity.

## Verification Plan

### Automated Tests
- Run `flutter build web` on both `admin_app` and `user_app` to verify consistency.

### Manual Verification
- **Login Flow**: Log out and log back in to the Admin account to verify the "failed login" issue is resolved and it lands directly on the Dashboard.
- **Model Audit**: Check "USER MANAGEMENT" and "SERVICE MODERATION" in Admin App to ensure new fields (like adminNotes or moderationStatus) are correctly displayed/handled.
