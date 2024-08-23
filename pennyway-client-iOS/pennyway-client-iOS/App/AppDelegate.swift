import Firebase
import FirebaseCore
import FirebaseMessaging
import SwiftUI

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    static var currentFCMToken: String?

    let gcmMessageIDKey = "gcm.message_id"

    /// 앱이 켜졌을 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        NetworkMonitor.shared.startMonitoring()

        // 파이어베이스 설정
        let firebaseAnalyticsService = FirebaseAnalyticsService()

        AnalyticsManager.shared.addService(firebaseAnalyticsService)

        if let launchOptions = launchOptions {
            AnalyticsManager.shared.initialize(application: application, didFinishLaunchingWithOptions: launchOptions)
        }

        FirebaseApp.configure()

        // 알림 허용 여부
        UNUserNotificationCenter.current().delegate = self

        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOption,
            completionHandler: { granted, error in
                if granted { // 알림 허용
                    Log.info("알림 허용")
                } else { // 알림 거부
                    Log.info("알림 거부")
                }

                if let error = error {
                    Log.error("Error requesting notification authorization: \(error.localizedDescription)")
                }
            })

        application.registerForRemoteNotifications()

        // Setting Up Cloud Messaging...
        // 메세징 델리겟
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        return true
    }

    /// fcm 토큰이 등록 되었을 때
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: MessagingDelegate

/// Cloud Messaging...
extension AppDelegate: MessagingDelegate {
    /// fcm 등록 토큰을 받았을 때
    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            AppDelegate.currentFCMToken = fcmToken // fcm 토큰 저장
            Log.info("fcmToken: \(fcmToken)")
        }
    }
}

// MARK: UNUserNotificationCenterDelegate

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    /// 푸시 메세지가 앱이 켜져있을 때 나올떄
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void)
    {
        let userInfo = notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            Log.debug("Message ID: \(messageID)")
        }

        Log.debug(userInfo)

        completionHandler([[.banner, .badge, .sound]])
    }

    /// 푸시메세지를 받았을 떄
    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            Log.debug("Message ID: \(messageID)")
        }

        Log.debug(userInfo)

        completionHandler()
    }
}
