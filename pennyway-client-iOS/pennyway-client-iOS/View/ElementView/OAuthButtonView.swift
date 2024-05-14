import SwiftUI

struct OAuthButtonView: View {
    var kakaoAction: () -> Void
    var googleAction: () -> Void
    var appleAction: () -> Void

    var body: some View {
        HStack(spacing: 10 * DynamicSizeFactor.factor()) {
            Button(action: {
                kakaoAction()
            }, label: {
                Image("icon_signin_kakao")
                    .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
            })

            Button(action: {
                googleAction()
            }, label: {
                Image("icon_signin_google")
                    .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
            })

            Button(action: {
                appleAction()
            }, label: {
                Image("icon_signin_apple")
                    .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
            })
        }
    }
}
