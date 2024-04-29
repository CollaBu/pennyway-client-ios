
import SwiftUI

struct ProfileOAuthButtonView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
            
            Text("SNS 연동 현황 확인하기")
                .font(.B2MediumFont())
                .platformTextColor(color: Color("Gray04"))
            
            HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                Button(action: {}, label: {
                    Image("icon_signin_kakao")
                        .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
                })
               
                Button(action: {}, label: {
                    Image("icon_signin_google")
                        .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
                })
               
                Button(action: {}, label: {
                    Image("icon_signin_apple")
                        .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
                })
            }
            
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
        }

        .frame(maxWidth: .infinity)
        .background(Color("White01"))
    }
}
