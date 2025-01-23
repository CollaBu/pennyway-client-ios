import Foundation

/// Notification 이름 확장
extension Notification.Name {
    static let logoutNotification = Notification.Name("logoutNotification")
    static let changeNetworkState = Notification.Name("changeNetworkState")
    static let didReceiveMessage = Notification.Name("didReceiveMessage")
    static let tokenRefreshComplete = Notification.Name("token-refresh-complete")
    static let tokenRefreshFailure = Notification.Name("token-refresh-failure")
}
