import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Google Maps
    let apiKey = "AIzaSyDZyyxf0aLbyaNtXlVK6GH0S1y1p9LDtBk"
    GMSServices.provideAPIKey(apiKey)

    GeneratedPluginRegistrant.register(with: self)

    

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
