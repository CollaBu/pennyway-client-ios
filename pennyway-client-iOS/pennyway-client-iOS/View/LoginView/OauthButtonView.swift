
import SwiftUI

struct OauthButtonView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack(spacing: 10) {
                Button(action: { // kakao
                }, label: {
                    Image("icon_signin_kakao")
                })

                Button(action: { // google
                }, label: {
                    Image("icon_signin_google")
                })

                Button(action: { // apple
                }, label: {
                    Image("icon_signin_apple")
                })
            }
            .padding(.horizontal, 100)
        }
        Spacer().frame(height: 15)
    }
}

#Preview {
    OauthButtonView()
}
