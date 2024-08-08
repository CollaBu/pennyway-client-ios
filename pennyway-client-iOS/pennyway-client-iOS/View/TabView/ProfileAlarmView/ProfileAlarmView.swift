
import SwiftUI

struct ProfileAlarmView: View {
    @StateObject private var viewModel = ProfileNotificationViewModel()

    var body: some View {
        ZStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 15 * DynamicSizeFactor.factor())

                    Text("알림")
                        .font(.H1SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 28 * DynamicSizeFactor.factor())

                    if viewModel.notificationData.isEmpty {
                        NoAlarmArrivedView()
                    } else {
                        ArrivedAlarmView(viewModel: viewModel)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }

        .setTabBarVisibility(isHidden: true)
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
        .onAppear {
            viewModel.getNotificationListApi()
        }
    }
}

#Preview {
    ProfileAlarmView()
}
