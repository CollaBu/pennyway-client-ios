
public struct ReadNotificationsRequestDto: Encodable {
    let notificationIds: [Int]

    public init(
        notificationIds: [Int]
    ) {
        self.notificationIds = notificationIds
    }
}
