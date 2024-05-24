
import SwiftUI

struct SettingAlarmView: View {
    @State private var toggleStates: [Bool] = [false, false, false]
    var toggleListArray: [String] = ["지출 관리", "채팅방", "피드"]

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
                                .foregroundColor(.clear)
                                .frame(width: 280 * DynamicSizeFactor.factor(), height: 56 * DynamicSizeFactor.factor())
                                .background(Color("Gray01"))
                                .cornerRadius(7)

                            Spacer()

                            Toggle(isOn: $toggleStates[item], label: {
                                Text(toggleListArray[item])
                                    .padding(.leading, 17)
                                    .font(.H4MediumFont())
                                    .platformTextColor(color: Color("Gray07"))
                            })
                            .toggleStyle(CustomToggleStyle())
                            .padding(.trailing, 42)
                            .padding(.vertical, 18)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
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
}

#Preview {
    SettingAlarmView()
}
