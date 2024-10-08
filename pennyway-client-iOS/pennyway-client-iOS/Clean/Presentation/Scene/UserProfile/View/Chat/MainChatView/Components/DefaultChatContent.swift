
import SwiftUI

struct DefaultChatContent: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 91 * DynamicSizeFactor.factor())
            
            Image("icon_illust_my_chating")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 98 * DynamicSizeFactor.factor(), height: 82 * DynamicSizeFactor.factor())
            
            Spacer().frame(height: 20 * DynamicSizeFactor.factor())
            
            Text("채팅방을 추가하고\n함께 절약해요")
                .font(.H4MediumFont())
                .platformTextColor(color: Color("Gray04"))
                .multilineTextAlignment(.center)
                .padding(1)
        }
    }
}
