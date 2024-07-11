import SwiftUI

struct SettingAlarmView: View {
    @StateObject var viewModel = UserAccountViewModel()

    var toggleListArray: [String] = ["지출 관리", "채팅방", "피드"]
    var alarmTypes: [String] = ["ACCOUNT_BOOK", "CHAT", "FEED"]

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 15 * DynamicSizeFactor.factor())

                Text("알림 설정")
                    .font(.H1SemiboldFont())
                    .multilineTextAlignment(.leading)

                Spacer().frame(height: 29 * DynamicSizeFactor.factor())

                VStack(spacing: 9 * DynamicSizeFactor.factor()) {
                    ForEach(toggleListArray.indices, id: \.self) { item in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .platformTextColor(color: .clear)
                                .frame(width: 280 * DynamicSizeFactor.factor(), height: 56 * DynamicSizeFactor.factor())
                                .background(Color("Gray01"))
                                .cornerRadius(7)

                            Spacer()

                            Toggle(isOn: Binding(
                                get: { viewModel.toggleStates[item] },
                                set: { newValue in
                                    viewModel.toggleStates[item] = newValue
                                    if newValue { // 토글 상태가 on
                                        settingOnAlarm(type: alarmTypes[item])
                                    } else { // 토글 상태가 off
                                        settingOffAlarm(type: alarmTypes[item])
                                    }
                                }
                            ), label: {
                                Text(toggleListArray[item])
                                    .padding(.leading, 17)
                                    .font(.H4MediumFont())
                                    .platformTextColor(color: Color("Gray07"))
                            })
                            .toggleStyle(CustomToggleStyle())
                            .padding(.trailing, 30)
                            .padding(.vertical, 18)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .onAppear {
                viewModel.getUserProfileApi { success in
                    if success {
                        Log.debug("알람 설정 조회 성공")
                    } else {
                        Log.debug("알람 설정 조회 실패")
                    }
                }
            }
        }
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }

    private func settingOnAlarm(type: String) { // 알람 활성화
        viewModel.settingOnAlarmApi(type: type) { success in
            if success {
                Log.debug("알람 활성화 성공")
                viewModel.refreshToggleStates()
            } else {
                Log.debug("알람 활성화 실패")
            }
        }
    }

    private func settingOffAlarm(type: String) { // 알람 비활성화
        viewModel.settingOffAlarmApi(type: type) { success in
            if success {
                Log.debug("알람 비활성화 성공")
                viewModel.refreshToggleStates()
            } else {
                Log.debug("알람 비활성화 실패")
            }
        }
    }
}

#Preview {
    SettingAlarmView()
}
