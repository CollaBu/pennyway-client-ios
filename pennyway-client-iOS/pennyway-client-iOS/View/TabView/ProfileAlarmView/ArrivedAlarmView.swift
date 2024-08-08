
import SwiftUI

// MARK: - ArrivedAlarmView

struct ArrivedAlarmView: View {
    @StateObject private var viewModel = ProfileNotificationViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            UnreadAlarmView(alarms: viewModel.notificationData.filter { !$0.isRead })

            Spacer().frame(height: 4 * DynamicSizeFactor.factor())

            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: 320 * DynamicSizeFactor.factor(), maxHeight: 9 * DynamicSizeFactor.factor())
                .background(Color("Gray01"))

            Spacer().frame(height: 25 * DynamicSizeFactor.factor())

            ReadAlarmView(alarms: viewModel.notificationData.filter { $0.isRead })
        }
//        .onAppear {
//            viewModel.getNotificationListApi()
//        }
    }
}

// MARK: - AlarmRow

struct AlarmRow: View {
    let alarm: NotificationContentData

    var body: some View {
        HStack(spacing: 15 * DynamicSizeFactor.factor()) {
            Image("icon_close_filled_primary")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32 * DynamicSizeFactor.factor(), height: 32 * DynamicSizeFactor.factor())
                .padding(1)

            VStack(alignment: .leading, spacing: 4 * DynamicSizeFactor.factor()) {
                Text(alarm.content)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))

                Text(alarm.createdAt)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray04"))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
