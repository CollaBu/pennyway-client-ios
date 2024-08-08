
import SwiftUI

struct AlarmListView: View {
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 임시 버퍼링
                                    viewModel.getNotificationListApi { _ in }
                                }
                            }
                        }
                }
            } else {
                Text("읽지 않은 알림")
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                ForEach(alarms) { alarm in
                    Button(action: {
                        Log.debug("click")
                    }, label: {
                        VStack {
                            AlarmRow(alarm: alarm)
                            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                        }
                        .contentShape(Rectangle())
                    })
                    .buttonStyle(PlainButtonStyle())
                    .buttonStyle(BasicButtonStyleUtil())
                    .onAppear {
                        // 해당 index가 마지막 index라면 데이터 추가
                        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else {
                            return
                        }
                        if index == alarms.count - 1 {
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
