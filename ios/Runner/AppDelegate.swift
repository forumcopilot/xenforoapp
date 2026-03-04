import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "forumcopilot/passkeys", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { call, result in
        switch call.method {
        case "getAssociatedDomains":
          let domains = self.fetchAssociatedDomains()
          result(domains)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func fetchAssociatedDomains() -> [String] {
    // SecTaskCreateFromSelf / SecTaskCopyValueForEntitlement are macOS-only; read from Info.plist on iOS.
    guard let list = Bundle.main.object(forInfoDictionaryKey: "AssociatedDomainsList") as? [String] else {
      return []
    }
    return list
  }
}
