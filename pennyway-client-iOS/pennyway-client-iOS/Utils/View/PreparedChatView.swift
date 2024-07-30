
import SwiftUI

struct PreparedChatView: View {
    var body: some View {
        ZStack {
            VStack {
                Image("icon_close_filled_primary")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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
    }
}

#Preview {
    PreparedChatView()
}
