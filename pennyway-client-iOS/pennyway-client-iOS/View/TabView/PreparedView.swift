
import SwiftUI

struct PreparedView: View {
    @EnvironmentObject var viewStateManager: ViewStateManager

    var body: some View {
        ZStack {
            VStack {
                Image("icon_illust_preparing")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 142 * DynamicSizeFactor.factor(), height: 75 * DynamicSizeFactor.factor())

                Spacer().frame(height: 24 * DynamicSizeFactor.factor())

                Text("준비 중인 서비스예요")
                    .font(.H2SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer().frame(height: 8 * DynamicSizeFactor.factor())

                Text("조금만 기다리면 만날 수 있어요!")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray04"))
            }
        }
        .onAppear {
            viewStateManager.setCurrentView(self)
        }
    }
}

#Preview {
    PreparedView()
}
