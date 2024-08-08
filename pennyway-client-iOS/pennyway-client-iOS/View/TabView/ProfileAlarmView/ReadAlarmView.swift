
import SwiftUI

struct ReadAlarmView: View {
    @ObservedObject var viewModel: ProfileNotificationViewModel

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
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                        .onAppear {
                            // 해당 index가 마지막 index라면 데이터 추가

                            guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else {
                                return
                            }
                            if index == alarms.count - 1 {
                                print("Fetching next page because last item appeared: \(alarm.id)")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 임시 버퍼링
                                    viewModel.getNotificationListApi { _ in }
                                }
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
