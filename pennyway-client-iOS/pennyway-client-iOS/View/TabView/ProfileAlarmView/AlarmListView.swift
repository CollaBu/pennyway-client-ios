
import SwiftUI

struct AlarmListView: View {
    @ObservedObject var viewModel: ProfileNotificationViewModel
    let alarms: [NotificationContentData]
    let isUnread: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(isUnread ? "읽지 않은 알림" : "읽은 알림")
                .font(.H4MediumFont())
                .platformTextColor(color: Color("Gray07"))
            
            Spacer().frame(height: 22 * DynamicSizeFactor.factor())
            
            ForEach(alarms) { alarm in
                VStack {
                    AlarmRow(alarm: alarm)
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                }
                .onAppear {
                    if !isUnread { // 읽은 알림만 무한스크롤 적용
                        // 해당 index가 마지막 index라면 데이터 추가
                        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else {
                            return
                        }
                        if index == alarms.count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                viewModel.getNotificationListApi { success in
                                    if !success {
                                        Log.debug("[AlarmListView]: 읽은 알람 목록 추가 조회 실패")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
