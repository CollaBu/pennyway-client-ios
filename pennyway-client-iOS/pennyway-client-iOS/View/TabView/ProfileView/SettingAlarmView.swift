
import SwiftUI

struct SettingAlarmView: View {
    @State private var isToggleSpendingAlarm = false
    @State private var isToggleChatAlarm = false
    @State private var isToggleFeedAlarm = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 15 * DynamicSizeFactor.factor())

                Text("알림 설정")
                    .font(.H1SemiboldFont())
                    .multilineTextAlignment(.leading)

                Spacer().frame(height: 29 * DynamicSizeFactor.factor())

                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 280 * DynamicSizeFactor.factor(), height: 56 * DynamicSizeFactor.factor())
                        .background(Color("Gray01"))
                        .cornerRadius(7)

                    Spacer()

                    Toggle(isOn: $isToggleSpendingAlarm, label: {
                        Text("지출 관리")
                            .padding(.leading, 17)
                            .font(.H4MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                    })
                    .toggleStyle(SwitchToggleStyle(tint: Color("Mint03")))                    .padding(.trailing, 42)
                    .padding(.vertical, 18)
                }
            }
            .padding(.horizontal, 20)
            .frame(width: .infinity, height: .infinity)
        }
        .frame(width: .infinity, height: .infinity)
        .border(Color.black)
        .edgesIgnoringSafeArea(.bottom)
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
}

#Preview {
    SettingAlarmView()
}
