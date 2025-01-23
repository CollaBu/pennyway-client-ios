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
            }
        )

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

        if let deepLink = userInfo["deep_link"] as? String,
           let url = URL(string: deepLink)
        {
            handleDeepLink(url: url)
            Log.debug("deepLink: \(deepLink)")
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

<<<<<<< HEAD
//        if let deepLink = userInfo["deepLink"] {
//            handleDeepLink(url: deepLink as! URL)
//            Log.debug("deepLink: \(deepLink)")
//        }

        if let deepLink = userInfo["deep_link"] as? String,
           let url = URL(string: deepLink)
        {
            handleDeepLink(url: url)
            Log.debug("deepLink: \(deepLink)")
        }

        Log.debug("userInfo:\(userInfo)")

        completionHandler()
=======
        Log.debug("userInfo:\(userInfo)")
>>>>>>> 7211b4dfe1dc6eb7f41247387a1990df12ab93d2
    }

    /// 딥링크 처리 로직 호출
    private func handleDeepLink(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host,
              host == "chatRoom",
              let queryItems = components.queryItems
        else {
            return
        }

        if let chatRoomId = queryItems.first(where: { $0.name == "id" })?.value {
            navigateToChatRoom(chatRoomId: chatRoomId)
        }
    }

    private func navigateToChatRoom(chatRoomId: String) {
        // 딥링크에 따라 화면 전환 로직
        let coordinator = DeepLinkCoordinator()
        coordinator.handle(deepLink: .chatRoom(chatRoomId: chatRoomId))
    }
}
