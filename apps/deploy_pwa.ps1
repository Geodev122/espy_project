# Espy Protocol - PWA Deployment Sequence
# Run this script to build and deploy the Professional App as a PWA.

# Set explicit path for Flutter to match System Variables
$env:PATH = "C:\Flutter\SDK\flutter_windows_3.24.5-stable\flutter\bin;" + $env:PATH

function Check-Command($cmd) {
    $check = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($check -eq $null) {
        Write-Host "ERROR: $cmd not found. Please install it and add it to your PATH." -ForegroundColor Red
        exit
    }
}

Write-Host "--- INITIALIZING PROTOCOL: PWA DEPLOYMENT SEQUENCE ---" -ForegroundColor Yellow

# Check for Flutter
Check-Command "flutter"

# Determine Firebase command (firebase or npx firebase)
$FirebaseCmd = "firebase"
$checkFirebase = Get-Command "firebase" -ErrorAction SilentlyContinue
if ($checkFirebase -eq $null) {
    Write-Host "Firebase CLI not found in PATH, trying npx firebase..." -ForegroundColor Gray
    $FirebaseCmd = "npx firebase"
}

# 1. Generate Web Icons
Write-Host "Step 1: Generating web icons..." -ForegroundColor Cyan
flutter pub get
flutter pub run flutter_launcher_icons

# 2. Execute Production Build
Write-Host "Step 2: Building Flutter Web (Release)..." -ForegroundColor Cyan
flutter build web --release --pwa-strategy=offline-first

# 3. Deploy to Firebase Hosting
Write-Host "Step 3: Deploying to Firebase Hosting (espy-app)..." -ForegroundColor Cyan
# Need to run from the root directory where firebase.json is located
Push-Location ..
if ($FirebaseCmd -eq "npx firebase") {
    Invoke-Expression "$FirebaseCmd deploy --only hosting:espy-app"
} else {
    & $FirebaseCmd deploy --only hosting:espy-app
}
Pop-Location

Write-Host "--- PROTOCOL COMPLETE ---" -ForegroundColor Green
Write-Host "YOUR PWA IS LIVE!" -ForegroundColor Yellow
