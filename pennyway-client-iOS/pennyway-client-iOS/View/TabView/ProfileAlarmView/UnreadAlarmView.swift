
import SwiftUI

struct UnreadAlarmView: View {
    let alarms: [AlarmList]

    var body: some View {
        VStack(alignment: .leading) {
            if alarms.contains(where: { !$0.isRead }) {
                Text("읽지 않은 알림")
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                ForEach(alarms.filter { !$0.isRead }) { alarm in
                    AlarmRow(alarm: alarm)
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
