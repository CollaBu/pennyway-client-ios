import SwiftUI

struct LayoutView<Content: View>: View {
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
                    CustomToastView(message: "인터넷 연결이 불안정해요", isNetworkError: true)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                .padding(.bottom, networkStatus.paddingValue * DynamicSizeFactor.factor())
            }
        }
    }
}
