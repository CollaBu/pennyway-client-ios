
import SwiftUI

// MARK: - ArrivedAlarmView

struct ArrivedAlarmView: View {
    @ObservedObject var viewModel: ProfileNotificationViewModel 

    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.notificationData.filter({ !$0.isRead }).isEmpty {
                AlarmListView(viewModel: viewModel, alarms: viewModel.notificationData.filter { !$0.isRead })

                Rectangle()
                    .platformTextColor(color: .clear)
                    .frame(maxWidth: 320 * DynamicSizeFactor.factor(), maxHeight: 9 * DynamicSizeFactor.factor())
                    .background(Color("Gray01"))

                Spacer().frame(height: 29 * DynamicSizeFactor.factor())
            }

            if !viewModel.notificationData.filter({ $0.isRead }).isEmpty {
                AlarmListView(viewModel: viewModel, alarms: viewModel.notificationData.filter { $0.isRead })
            }
        }
        .onAppear {
            if viewModel.hasUnread == true {
                viewModel.getNotificationListApi { success in
                    if success {
                        let unreadNotificationIds = viewModel.notificationData.filter { !$0.isRead }.map { $0.id }
                        viewModel.notificationIds = unreadNotificationIds
                        if !unreadNotificationIds.isEmpty {
                            viewModel.readNotificationsApi { success in
                                if success {
                                    Log.debug("알림 읽음 처리 성공")
                                } else {
                                    Log.debug("알림 읽음 처리 실패")
                                }
                            }
                        }
                    } else {
                        Log.debug("알림 목록 가져오기 실패")
                    }
                }
            }
        }
    }
}

// MARK: - AlarmRow

struct AlarmRow: View {
    let alarm: NotificationContentData

    var body: some View {
        HStack(spacing: 0) {
            Image("icon_notifications")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 33 * DynamicSizeFactor.factor(), height: 33 * DynamicSizeFactor.factor())
                .padding(1)

            VStack(alignment: .leading, spacing: 4 * DynamicSizeFactor.factor()) {
                Text(alarm.content)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))

                Text(DateFormatterUtil.formatRelativeDate(from: alarm.createdAt))
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray04"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 14 * DynamicSizeFactor.factor())

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
