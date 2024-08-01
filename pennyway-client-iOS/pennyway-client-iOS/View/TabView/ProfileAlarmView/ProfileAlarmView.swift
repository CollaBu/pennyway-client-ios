
import SwiftUI

struct ProfileAlarmView: View {
    var body: some View {
        ScrollView {
            ZStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 15 * DynamicSizeFactor.factor())

                    Text("알림")
                        .font(.H1SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 28 * DynamicSizeFactor.factor())

                    if dummyAlarms.isEmpty {
                        NoAlarmArrivedView()
                    } else {
                        ArrivedAlarmView()
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
    }
}

#Preview {
    ProfileAlarmView()
}
