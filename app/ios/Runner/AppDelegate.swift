import UIKit
import Flutter
import Firebase
import GoogleMaps
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
#if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
#endif
        let dartEnv = getDartEnv()
        
        GMSServices.provideAPIKey(dartEnv["MAPS_KEY"]!)
        GMSServices.setMetalRendererEnabled(false)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        GMSServices.provideAPIKey("")
        GeneratedPluginRegistrant.register(with: self)
        application.registerForRemoteNotifications()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }

    override func application(_ application: UIApplication,
        didReceiveRemoteNotification notification: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
          completionHandler(.noData)
          return
        }
    }

    override func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
          return true
        }
        
        return false;
    }

    func getDartEnv() -> [String: String] {
        let dartDefinesString = Bundle.main.infoDictionary!["DART_DEFINES"] as! String
        var dartDefinesDictionary = [String:String]()
        for definedValue in dartDefinesString.components(separatedBy: ",") {
            let decoded = String(data: Data(base64Encoded: definedValue)!, encoding: .utf8)!
            let values = decoded.components(separatedBy: "=")
            dartDefinesDictionary[values[0]] = values[1]
        }
        return dartDefinesDictionary
    }
}
