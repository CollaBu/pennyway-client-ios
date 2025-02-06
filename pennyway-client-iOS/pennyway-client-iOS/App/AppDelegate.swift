import Firebase
import FirebaseCore
import FirebaseMessaging
import SwiftUI

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    static var currentFCMToken: String?
    let gcmMessageIDKey = "gcm.message_id"
    private var deepLinkCoordinator: DeepLinkCoordinator?

    /// 앱이 켜졌을 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        NetworkMonitor.shared.startMonitoring()

        deepLinkCoordinator = DeepLinkCoordinator()
        FirebaseApp.configure()

        setupNotification(application)
        AnalyticsManager.shared.initialize(application: application, didFinishLaunchingWithOptions: launchOptions)

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self

        return true
    }

    /// 🔔 **알림 설정**
    private func setupNotification(_: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                Log.info("알림 허용됨")
            } else {
                Log.info("알림 거부됨")
            }

            if let error = error {
                Log.error("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
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

        if let chatRoomId = userInfo["chatRoomId"] {
            Log.info("📩 Received chatRoomId: \(chatRoomId)")

            let deepLinkURLString = "pennyway://chat?roomId=\(chatRoomId)"
            if let deepLinkURL = URL(string: deepLinkURLString) {
                Log.debug("🔗 Generated DeepLink URL: \(deepLinkURL)")

                handleDeepLink(url: deepLinkURL)
            } else {
                Log.fault("⚠️ Invalid deep link URL")
            }
        } else {
            Log.fault("⚠️ chatRoomId is missing in userInfo")
        }

        Log.debug(userInfo)

        completionHandler([[.banner, .badge, .sound]])
    }

    /// 푸시메세지를 받았을 떄
    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler _: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            Log.debug("Message ID: \(messageID)")
        }

        if let chatRoomId = userInfo["chatRoomId"] {
            Log.info("📩 Received chatRoomId: \(chatRoomId)")

            let deepLinkURLString = "pennyway://chat?roomId=\(chatRoomId)"
            if let deepLinkURL = URL(string: deepLinkURLString) {
                Log.debug("🔗 Generated DeepLink URL: \(deepLinkURL)")

                handleDeepLink(url: deepLinkURL)
            } else {
                Log.fault("⚠️ Invalid deep link URL")
            }
        } else {
            Log.fault("⚠️ chatRoomId is missing in userInfo")
        }

        Log.debug("userInfo:\(userInfo)")
    }

    private func handleDeepLink(url: URL) {
        deepLinkCoordinator?.handleDeepLink(url: url)
    }
}
