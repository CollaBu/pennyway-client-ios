
import Combine
import Foundation

class ProfileNotificationViewModel: ObservableObject {
    @Published var notificationData: [NotificationContentData] = [] // 알림 데이터 리스트
    @Published var hasUnread: Bool = true // 미확인 알림 여부 조회
    @Published var notificationIds: [Int] = [] // 읽음 처리할 알림 ID 리스트

    private var currentPageNumber: Int = 0
    private var hasNext: Bool = true // 다음 페이지가 있는지 여부

    func initPage() {
        notificationData = []
        currentPageNumber = 0
        hasNext = true
        hasUnread = true
    }

    /// 알림 목록 무한스크롤 api 호출
    func getNotificationListApi(completion: @escaping (Bool) -> Void = { _ in }) {
        guard hasNext else {
            return
        }
        Log.debug("Fetching hasNext: \(hasNext)")
        Log.debug("Fetching page: \(currentPageNumber)")

        let getNotificationRequestDto = GetNotificationRequestDto(size: "5", page: "\(currentPageNumber)")

        UserAccountAlamofire.shared.getNotificationList(dto: getNotificationRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetNotificationResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("알림 목록 무한스크롤 조회\(jsonString)")
                        }

                        self.mergeNewNotifications(newNotifications: response.data.notifications.content)
                        self.currentPageNumber += 1
                        self.hasNext = response.data.notifications.hasNext

                        Log.debug("currentPageNumber: \(self.currentPageNumber)")
                        Log.debug("hasNext: \(self.hasNext)")

                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }

    /// 무한 스크롤 merge
    private func mergeNewNotifications(newNotifications: [NotificationContentData]) {
        var combinedNotifications = notificationData

        for newNotification in newNotifications {
            if !combinedNotifications.contains(where: { $0.id == newNotification.id }) {
                combinedNotifications.append(newNotification)
            }
        }

        let existingIds = Set(notificationData.map { $0.id })
        let uniqueNewNotifications = newNotifications.filter { !existingIds.contains($0.id) }
        combinedNotifications.sort { $0.createdAt > $1.createdAt }
        notificationData = combinedNotifications
    }
    /// 수신한 알람 중 미확인 알림 존재 여부 API
    func checkUnReadNotificationsApi(completion: @escaping (Bool) -> Void) {
        UserAccountAlamofire.shared.checkUnReadNotifications { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(CheckUnReadNotificationResponseDto.self, from: responseData)

                        Log.debug("Before hasUnread : \(self.hasUnread)")
                        self.hasUnread = response.data.hasUnread
                        Log.debug("After hasUnread : \(self.hasUnread)")

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("미확인 알람 여부 조회 \(jsonString)")
                        }
                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }

    /// 알림 읽음 처리 API
    func readNotificationsApi(completion: @escaping (Bool) -> Void) {
        guard !notificationIds.isEmpty else {
            Log.debug("읽을 ID가 없음")
            completion(false)
            return
        }

        let readNotificationsRequestDto = ReadNotificationsRequestDto(notificationIds: notificationIds)
        Log.debug("Sending readNotificationsApi with IDs: \(notificationIds)")

        UserAccountAlamofire.shared.readNotifications(dto: readNotificationsRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("알람 읽음 처리 성공 \(jsonString)")
                    }
                    self.notificationIds = []
                    completion(true)
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
}
