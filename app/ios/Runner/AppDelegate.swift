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
        // Use the debug provider in Debug builds:
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
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      return UIBackgroundFetchResult.newData
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
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
