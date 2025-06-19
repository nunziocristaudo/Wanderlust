import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MapViewController()
#if targetEnvironment(macCatalyst)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 600, height: 600)
            windowScene.title = "Wanderlust Desktop"
        }
#endif
        window?.makeKeyAndVisible()
        return true
    }
}
