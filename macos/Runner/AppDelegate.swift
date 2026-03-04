import Cocoa
import FlutterMacOS
import UserNotifications

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    // Register for remote notifications after super call
    // This allows Firebase to initialize first
    // Note: Firebase Messaging will handle the APNs token callbacks via method swizzling
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      print("📱 [AppDelegate] Registering for remote notifications...")
      NSApplication.shared.registerForRemoteNotifications()
    }
  }
  
  // Note: We don't override didRegisterForRemoteNotificationsWithDeviceToken or
  // didFailToRegisterForRemoteNotificationsWithError because Firebase Messaging
  // handles these via method swizzling. Explicit overrides would conflict.
}
