
import SwiftUI

struct ReadAlarmView: View {
//    @ObservedObject var viewModel: ProfileNotificationViewModel

    let alarms: [NotificationContentData]

    var body: some View {
        VStack(alignment: .leading) {
            if alarms.contains(where: { $0.isRead }) {
                Text("읽은 알림")
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                ForEach(alarms) { alarm in
                    AlarmRow(alarm: alarm)
//                        .onAppear {
//                            // 해당 알림이 마지막 항목인 경우 추가 데이터를 로드
//                            if alarm.id == alarms.last?.id {
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 임시 버퍼링
//                                    viewModel.getNotificationListApi { _ in }
//                                }
//                            }
//                        }
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
