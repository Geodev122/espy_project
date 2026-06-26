# Android Release Guide - Hope Support Suit

## 1. Google Services (Firebase) ✅ Done
The Gradle plugins for Firebase are now fully configured in:
*   `android/build.gradle` (Project level)
*   `android/app/build.gradle` (App level)

**Your Action:**
1. Move the `google-services.json` you downloaded to: `android/app/google-services.json`.

## 2. Generate a Keystore
A Keystore is a file that contains your digital signature. To generate one, run this command in your terminal (replace `YOUR_PASSWORD` and `YOUR_ALIAS`):

```powershell
keytool -genkey -v -keystore android/app/release-key.keystore -alias YOUR_ALIAS -keyalg RSA -keysize 2048 -validity 10000
```
*   **Store file:** `android/app/release-key.keystore`
*   **Alias:** `YOUR_ALIAS` (e.g., `hope-suit-key`)

## 3. Configure Signing
I have updated `android/app/build.gradle` with a `signingConfigs` section. 
**Your Action:**
Open `android/app/build.gradle` and change `'your-password'` and `'your-alias'` to match what you created in Step 2.

```groovy
    signingConfigs {
        release {
            storeFile file('release-key.keystore')
            storePassword 'YOUR_PASSWORD'
            keyAlias 'YOUR_ALIAS'
            keyPassword 'YOUR_PASSWORD'
        }
    }
```

## 4. Build the App
Once you have the keystore and `google-services.json` in place:
1. Run `npm run mobile:build` to sync the latest web code.
2. Run `npm run mobile:open` to open Android Studio.
3. **In Android Studio:** Wait for the Gradle sync to finish (a bar at the bottom).
4. Go to `Build > Generate Signed Bundle / APK`.
5. Select `Android App Bundle` (for Play Store) or `APK` (for direct install).
6. Use the keystore you generated.

## 5. Required Native Features ✅ Done
I have already:
*   Installed `@capacitor/geolocation` and `@capacitor/camera`.
*   Added the following permissions to `android/app/src/main/AndroidManifest.xml`:
    *   `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` (Map/GPS)
    *   `CAMERA` (Camera access)
    *   `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE` (Photo library)

**Important:** Never share your `.keystore` file or passwords with anyone. Keep them backed up in a safe place (not in Git).

## 6. Troubleshooting
### Multiple Gradle Daemons / JDK Mismatch
If you see a warning about different JDK locations:
I have added `org.gradle.java.home` to `android/gradle.properties` pointing to the Android Studio JBR. 
*   If you move to a different computer where Android Studio is installed in a different path, you will need to update this path in `android/gradle.properties`.
*   Alternatively, you can delete that line and set your system `JAVA_HOME` environment variable to `C:\Program Files\Android\Android Studio\jbr`.

## 7. Locating Your Build Files
After you complete Step 4 (**Generate Signed Bundle / APK**), you can find your files here:

### For Play Store (Android App Bundle - .aab)
This is the required format for publishing to the Play Store.
*   **Path:** `android/app/release/app-release.aab`
*   *(Note: Android Studio usually shows a popup in the bottom right with a "Locate" link once the build finishes.)*

### For Testing (APK - .apk)
If you want to send a file to someone to install directly on their phone:
*   **Path:** `android/app/release/app-release.apk`

## 8. Publishing to Google Play Console
1.  Log in to your [Google Play Console](https://play.google.com/console/).
2.  Create a new app.
3.  Navigate to **Production** > **Create new release**.
4.  Upload the `.aab` file found in `android/app/release/`.
5.  **Version Management:** Every time you want to upload a *new* version to the store, you **must** increment the `versionCode` in `android/app/build.gradle`.
    *   Example: Change `versionCode 1` to `versionCode 2`, etc.
    *   You can also update `versionName "1.0"` to "1.1" for your users to see.

## 9. Fixing Login Issues (Firebase Auth)
If you can't log in on your phone:
1.  **Register SHA-1 Fingerprint (MANDATORY):** 
    *   Firebase needs to know your app is authentic. 
    *   Run this to get your SHA-1: `keytool -list -v -keystore android/app/release-key.keystore -alias YOUR_ALIAS`
    *   Copy the **SHA-1** hex string.
    *   Go to **Firebase Console > Project Settings > General**.
    *   Select your Android app and click **Add Fingerprint**. Paste the SHA-1.
2.  **Google Sign-In:** 
    *   Native Google Sign-In is now enabled using the `@capacitor-firebase/authentication` plugin.
    *   I have updated `UserContext.tsx` to automatically use the native sign-in flow when on a mobile device.
    *   **MANDATORY:** You must still register your **SHA-1** (see Step 1 above) and ensure your **Web Client ID** (found in Google Cloud Console or Firebase) is listed in the Firebase project settings.
3.  **App Check:** 
    *   I have updated `src/shared/services/firebase.ts` to skip App Check enforcement on native devices for now, as it requires additional native configuration.

## 10. Admin Access
For security and data fidelity, the **Admin Dashboard** is restricted to web browsers.
*   A small **"Admin External Terminal"** button has been added to the app's menu drawer.
*   Tapping this will open your phone's browser and redirect you to the secure admin login page.

## 11. Native Connectivity
I have updated `directoryAPIService.ts` to use absolute production URLs when running as a native app. This ensures that dynamic data (like SOS numbers and Community Requests) is correctly fetched even without the Vite development proxy.

**Pro Tip:** Always run `npm run mobile:build` before your final build in Android Studio to ensure your latest web changes (HTML/JS/CSS) are included in the native app!
