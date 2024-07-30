
import SwiftUI

struct CustomCompleteView: View {
    let title: String
    let subTitle: String

    var body: some View {
        VStack {
            Spacer().frame(height: 171 * DynamicSizeFactor.factor())
                    
            Image("icon_illust_completion")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 68 * DynamicSizeFactor.factor(), height: 68 * DynamicSizeFactor.factor())
                    
            Spacer().frame(height: 17 * DynamicSizeFactor.factor())
                    
            Text(title)
                .font(.H3SemiboldFont())
                .multilineTextAlignment(.center)
                .platformTextColor(color: Color("Gray07"))
                    
            Spacer().frame(height: 8 * DynamicSizeFactor.factor())
                    
            Text(subTitle)
                .font(.H4MediumFont())
                .platformTextColor(color: Color("Gray04"))
                    
            Spacer()
        }
    }
}
