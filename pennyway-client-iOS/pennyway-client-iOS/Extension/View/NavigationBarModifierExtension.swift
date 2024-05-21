import SwiftUI

// MARK: - NavigationBarModifierExtension

struct NavigationBarModifierExtension: ViewModifier {
    var backgroundColor: UIColor?
    var title: String?

    init(backgroundColor: UIColor?, title: String?) {
        self.backgroundColor = backgroundColor
        self.title = title

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "Gray07") as Any]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Gray07") as Any]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .navigationBarTitle(title ?? "", displayMode: .inline)
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    /// 네비게이션 바 색상 및 타이틀 텍스트 설정
    func navigationBarColor(_ backgroundColor: UIColor?, title: String?) -> some View {
        modifier(NavigationBarModifierExtension(backgroundColor: backgroundColor, title: title))
    }
}
