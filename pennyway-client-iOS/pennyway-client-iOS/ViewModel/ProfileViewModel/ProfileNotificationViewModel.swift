
import Combine
import Foundation

class ProfileNotificationViewModel: ObservableObject {
    @Published var notificationData: [NotificationContentData] = [] // 알림 데이터 리스트
    @Published var hasUnread: Bool = false // 미확인 알림 여부 조회

    private var currentPageNumber: Int = 0
    private var hasNext: Bool = true // 다음 페이지가 있는지 여부

    func initPage() {
        notificationData = []
        currentPageNumber = 0
        hasNext = true
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
    func checkUnReadNotifications(completion: @escaping (Bool) -> Void) {
        UserAccountAlamofire.shared.checkUnReadNotifications { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(CheckUnReadNotificationResponseDto.self, from: responseData)

                        Log.debug("Before hasUnread : \(self.hasUnread)")
                        self.hasUnread = true
//                        self.objectWillChange.send() // 뷰 강제 렌더링
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
}
