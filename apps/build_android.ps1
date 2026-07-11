# Espy Protocol - Optimized Android Build Script
# This script handles process cleanup, cache redirection, and performance flags

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   OPTIMIZED ANDROID BUILD PROTOCOL" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

# 1. Cleanup stuck processes
Write-Host "STEP 1: Cleaning up background processes..." -ForegroundColor Yellow
taskkill /F /IM java.exe /T 2>$null
taskkill /F /IM gradlew.bat /T 2>$null

# 2. Clear known Gradle locks
Write-Host "STEP 2: Clearing filesystem locks..." -ForegroundColor Yellow
$lockFiles = Get-ChildItem -Path "C:\Users\Dell\StudioProjects\espy project\espy_project\apps\android\.gradle" -Filter "*.lock" -Recurse
foreach ($f in $lockFiles) { Remove-Item $f.FullName -Force -ErrorAction SilentlyContinue }

# 3. Set Environment (Using C: defaults or root)
Write-Host "STEP 3: Configuring build environment..." -ForegroundColor Yellow
# $env:GRADLE_USER_HOME = "C:\.gradle"
# $env:PUB_CACHE = "C:\.pub-cache"
# $env:ANDROID_USER_HOME = "C:\.android"

# 4. Clean and Resolve
Write-Host "STEP 4: Refreshing dependencies..." -ForegroundColor Yellow
C:\Flutter\SDK\flutter_windows_3.24.5-stable\flutter\bin\flutter.bat clean
C:\Flutter\SDK\flutter_windows_3.24.5-stable\flutter\bin\flutter.bat pub get

# 5. Build APK
Write-Host "STEP 5: Generating Release APK (Level 5 Optimization)..." -ForegroundColor Yellow
C:\Flutter\SDK\flutter_windows_3.24.5-stable\flutter\bin\flutter.bat build apk --release --android-skip-build-dependency-validation --obfuscate --split-debug-info=build/app/outputs/symbols

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS: APK Generated at build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Green

    # 6. Commit and Push
    Write-Host "STEP 6: Committing and Pushing fixes..." -ForegroundColor Yellow
    git add .
    git commit -m "fix: adjust paths to C: drive and optimize build"
    git push
} else {
    Write-Host ""
    Write-Host "ERROR: Build Failed. Please check the logs." -ForegroundColor Red
}

Write-Host "========================================" -ForegroundColor Cyan
