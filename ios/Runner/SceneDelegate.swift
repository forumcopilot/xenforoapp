import Flutter
import UIKit

@objc class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // FlutterSceneDelegate handles the window and engine setup automatically
    // This method is called when the scene is about to connect
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }
  
  override func sceneDidDisconnect(_ scene: UIScene) {
    // Scene is being released
    super.sceneDidDisconnect(scene)
  }
  
  override func sceneDidBecomeActive(_ scene: UIScene) {
    // Scene became active
    super.sceneDidBecomeActive(scene)
  }
  
  override func sceneWillResignActive(_ scene: UIScene) {
    // Scene will resign active
    super.sceneWillResignActive(scene)
  }
  
  override func sceneWillEnterForeground(_ scene: UIScene) {
    // Scene will enter foreground
    super.sceneWillEnterForeground(scene)
  }
  
  override func sceneDidEnterBackground(_ scene: UIScene) {
    // Scene entered background
    super.sceneDidEnterBackground(scene)
  }
}

