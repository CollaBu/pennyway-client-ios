
import SwiftUI

class ProfileNotificationViewModel: ObservableObject {
    @Published var notificationData: [NotificationContentData] = [] // 알림 데이터 리스트

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
        
        let getNotificationRequestDto = GetNotificationRequestDto(size: "30", page: "\(currentPageNumber)")
                
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
    
//    /// 무한 스크롤 지출 데이터 merge
//    private func mergeNewSpendings(newSpendings: [NotificationContentData]) {
//        var allNewNotificationList: [NotificationContentData] = []
//
//        for newSpending in newSpendings {
//            for newDailySpending in newSpending.notificationData {
//                allNewNotificationList.append(contentsOf: newDailySpending.individuals)
//            }
//        }
//
//        let existingIds = Set(notificationData.map { $0.id })
//        let uniqueNewSpendings = allNewNotificationList.filter { !existingIds.contains($0.id) }
//        
//        notificationData.append(contentsOf: uniqueNewSpendings)
//        notificationData.sort { $0.spendAt > $1.spendAt }
//    }
    
    private func mergeNewNotifications(newNotifications: [NotificationContentData]) {
        let existingIds = Set(notificationData.map { $0.id })
        let uniqueNewNotifications = newNotifications.filter { !existingIds.contains($0.id) }
        notificationData.append(contentsOf: uniqueNewNotifications)
        notificationData.sort { $0.createdAt > $1.createdAt }
    }
}
