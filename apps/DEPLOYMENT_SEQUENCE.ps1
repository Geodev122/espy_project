# Espy Protocol - Final Deployment Wrapper
# Run this script in the apps/mobile-app directory to wrap the app for Play Store.

function Check-Command($cmd) {
    $check = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($check -eq $null) {
        Write-Host "ERROR: $cmd not found. Please install Flutter SDK and add it to your PATH." -ForegroundColor Red
        exit
    }
}

Write-Host "--- INITIALIZING PROTOCOL: APP WRAPPING SEQUENCE ---" -ForegroundColor Yellow

# Check for Flutter
Check-Command "flutter"

# 1. Generate Android Host Project
Write-Host "Step 1: Generating Android host..." -ForegroundColor Cyan
flutter create --platforms=android .

# 2. Inject Production Assets
Write-Host "Step 2: Injecting production assets..." -ForegroundColor Cyan
# Ensure directories exist
if (!(Test-Path "android/app")) { New-Item -ItemType Directory -Force -Path "android/app" }

Copy-Item "legacy_android_assets/google-services.json" "android/app/google-services.json" -Force
Copy-Item "legacy_android_assets/release-key.keystore" "android/app/release-key.keystore" -Force

# 3. Configure Signing
Write-Host "Step 3: Configuring signing properties..." -ForegroundColor Cyan
$keyProps = @"
storePassword=hopeprotocol2026
keyPassword=hopeprotocol2026
keyAlias=upload
storeFile=release-key.keystore
"@
$keyProps | Out-File -FilePath "android/key.properties" -Encoding utf8

# 4. Generate Launcher Icons & Splash
Write-Host "Step 4: Redrawing world-class splash and icons..." -ForegroundColor Cyan
flutter pub get
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create

# 5. Execute Production Build
Write-Host "Step 5: Building Release App Bundle (AAB)..." -ForegroundColor Cyan
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols

Write-Host "--- PROTOCOL COMPLETE ---" -ForegroundColor Green
Write-Host "YOUR AAB IS READY AT: build/app/outputs/bundle/release/app-release.aab" -ForegroundColor Yellow
Write-Host "UPLOAD THIS FILE TO THE GOOGLE PLAY CONSOLE." -ForegroundColor Cyan
