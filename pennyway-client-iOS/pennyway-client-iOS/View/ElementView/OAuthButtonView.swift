import SwiftUI

struct OAuthButtonView: View {
    var isKakaoLoggedIn: Bool
    var isGoogleLoggedIn: Bool
    var isAppleLoggedIn: Bool

    var kakaoAction: () -> Void
    var googleAction: () -> Void
    var appleAction: () -> Void

    var body: some View {
        HStack(spacing: 2 * DynamicSizeFactor.factor()) {
            Button(action: {
                kakaoAction()
            }, label: {
                Image(isKakaoLoggedIn ? "icon_signin_kakao" : "icon_signin_kakao_notlinked")
                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
            })
            .buttonStyle(BasicButtonStyleUtil())

            Button(action: {
                googleAction()
            }, label: {
                Image(isGoogleLoggedIn ? "icon_signin_google" : "icon_signin_google_notlinked")
                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
            })
            .buttonStyle(BasicButtonStyleUtil())

            Button(action: {
                appleAction()
            }, label: {
                Image(isAppleLoggedIn ? "icon_signin_apple" : "icon_signin_apple_notlinked")
                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
            })
            .buttonStyle(BasicButtonStyleUtil())
        }
    }
}
