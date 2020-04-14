# covid_tracker

Basic COVID-19 Tracker.
![Simulator Screen Shot - iPhone 11 Pro Max - 2020-04-14 at 11 14 18](https://user-images.githubusercontent.com/3673431/79259278-4e4f1100-7e41-11ea-9951-01320c1f250e.png)

## Getting Started

This project tracks COVID-19 cases worldwide using https://covid19-api.weedmark.systems/ REST API.

## Important
- Google Maps: Get an API key at https://cloud.google.com/maps-platform/
- You might also want to change the bundle ID for both iOS and Android to reflect your organization.
- Enable Google Map SDK for each platform.
    - Go to Google Developers Console -> https://console.cloud.google.com/.
    - Choose the project that you want to enable Google Maps on.
    - Select the navigation menu and then select "Google Maps".
    - Select "APIs" under the Google Maps menu.
    - To enable Google Maps for Android, select "Maps SDK for Android" in the "Additional APIs" section, then select "ENABLE".
    - To enable Google Maps for iOS, select "Maps SDK for iOS" in the "Additional APIs" section, then select "ENABLE".
    - Make sure the APIs you enabled are under the "Enabled APIs" section.
- You can also find detailed steps to get start with Google Maps Platform here -> https://developers.google.com/maps/gmp-get-started.

### iOS
Specify your API key in the application delegate ios/Runner/AppDelegate.swift
```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Android
Specify your API key in the application manifest android/app/src/main/AndroidManifest.xml:
```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```


For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
