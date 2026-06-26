# Hope Support Suite - Mobile App (Flutter)

This component has been migrated from React/Capacitor to **Flutter**.

## Migration Status
- [x] PWA Version Removed
- [x] Capacitor IOS/Android Removed
- [x] Flutter APK Build Infrastructure Setup
- [x] Shared Firebase Logic Ported

## Development
- Run: `flutter run`
- Build APK: `flutter build apk`

## Note on Shared Logic
The mobile app now resides exclusively in the `lib/` directory using Dart. 
The legacy React source code has been moved to `apps/admin-dashboard/src/legacy_shared` to maintain the Admin Dashboard PWA's functionality while keeping this workspace clean.
