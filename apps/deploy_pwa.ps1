# Espy Protocol - Distinct PWA Deployment Sequence

# Set explicit path for Flutter
$env:PATH = "C:\Flutter\SDK\flutter_windows_3.24.5-stable\flutter\bin;" + $env:PATH

# Get current script directory
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Write-Host "--- INITIALIZING PROTOCOL: DUAL PWA DEPLOYMENT ---" -ForegroundColor Yellow

# 1. Build Admin App
Write-Host "Step 1: Building ADMIN PWA..." -ForegroundColor Cyan
Push-Location "$scriptPath/admin_app"
flutter build web --release --pwa-strategy=offline-first
Pop-Location

# 2. Build User App
Write-Host "Step 2: Building USER PWA..." -ForegroundColor Cyan
Push-Location "$scriptPath/user_app"
flutter build web --release --pwa-strategy=offline-first
Pop-Location

# 3. Deploy to Firebase
Write-Host "Step 3: Deploying to Firebase Hosting..." -ForegroundColor Cyan
Push-Location "$scriptPath/.."
npx firebase deploy --only hosting
Pop-Location

Write-Host "--- PROTOCOL COMPLETE: BOTH APPS DEPLOYED ---" -ForegroundColor Green
