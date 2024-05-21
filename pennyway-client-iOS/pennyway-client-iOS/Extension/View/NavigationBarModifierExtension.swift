
import SwiftUI

// MARK: - NavigationBarModifierExtension

struct NavigationBarModifierExtension: ViewModifier {
    var backgroundColor: UIColor?

    func body(content: Content) -> some View {
        ZStack {
            content
                .onAppear {
                    Log.debug(backgroundColor as Any)
                    let coloredAppearance = UINavigationBarAppearance()
                    coloredAppearance.configureWithOpaqueBackground()
                    coloredAppearance.backgroundColor = backgroundColor
                    coloredAppearance.shadowColor = .clear

                    UINavigationBar.appearance().standardAppearance = coloredAppearance
                    UINavigationBar.appearance().compactAppearance = coloredAppearance
                    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
                }
        }
    }
}

extension View {
    /// 네비게이션 바 color 설정
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        modifier(NavigationBarModifierExtension(backgroundColor: backgroundColor))
    }
}
