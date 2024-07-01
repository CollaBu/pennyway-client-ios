import Firebase
import FirebaseCore
import FirebaseMessaging
import SwiftUI

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    /// 앱이 켜졌을 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 파이어베이스 설정
        FirebaseApp.configure()

        // Setting Up Notifications...
        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption,
                completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

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
            KeychainHelper.saveFcmToken(fcmToken: fcmToken)
            Log.debug("fcmToken: \(fcmToken)")
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

        // Do Something With MSG Data...
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

        // Do Something With MSG Data...
        if let messageID = userInfo[gcmMessageIDKey] {
            Log.debug("Message ID: \(messageID)")
        }

        Log.debug(userInfo)

        completionHandler()
    }
}
