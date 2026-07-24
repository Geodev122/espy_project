# Task: Model Normalization & Login Fix

### 1. Robust Login Sync
- [ ] Refactor `AuthService` synchronization logic
- [ ] Update `MainGate` to handle transient states better

### 2. Model Audit & Update (Admin App)
- [ ] Update `UserModel` with `adminNotes`
- [ ] Update `CountryModel` with missing schema fields
- [ ] Update `ServiceModel` with moderation and sector fields
- [ ] Update `ProfessionalProfile` and `InstitutionProfile`
- [ ] Create `SectorModel`, `CategoryModel`, `RegionModel`, `CityModel`

### 3. Synchronization (User App)
- [ ] Replicate all model updates to User App

### 4. Build & Verify
- [ ] Verify Admin App build
- [ ] Verify User App build
- [ ] Manual test login flow
