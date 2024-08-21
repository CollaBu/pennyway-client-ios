import SwiftUI

struct MainLayout<Content: View>: View {
    @EnvironmentObject var networkStatus: NetworkStatusViewModel
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            content

            if networkStatus.showToast {
                VStack {
                    Spacer()
                    CustomToastView(message: "네트워크 연결이 끊어졌습니다.")
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                .padding(.bottom, 44 * DynamicSizeFactor.factor())
            }
        }
    }
}
