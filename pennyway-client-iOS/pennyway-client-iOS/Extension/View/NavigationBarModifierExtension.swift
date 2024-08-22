import SwiftUI

// MARK: - NavigationBarModifierExtension

struct NavigationBarModifierExtension: ViewModifier {
    var backgroundColor: UIColor?
    var title: String?
    var isPresented: Binding<Bool>?

    init(backgroundColor: UIColor?, title: String?, isPresented: Binding<Bool>? = nil) {
        self.backgroundColor = backgroundColor
        self.title = title
        self.isPresented = isPresented

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "Gray07") as Any,
                                                 .font: UIFont(name: "Pretendard-Medium", size: 14 * DynamicSizeFactor.factor()) as Any]

        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Gray07") as Any,
                                                      .font: UIFont(name: "Pretendard-Medium", size: 14 * DynamicSizeFactor.factor()) as Any]

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

            if let isPresented = isPresented, isPresented.wrappedValue {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.top)
                    .onTapGesture {
                        isPresented.wrappedValue = false
                    }
            }
        }
    }
}

extension View {
    /// 네비게이션 바 색상 및 타이틀 텍스트 설정
    func navigationBarColor(_ backgroundColor: UIColor?, title: String?, isPresented: Binding<Bool>? = nil) -> some View {
        modifier(NavigationBarModifierExtension(backgroundColor: backgroundColor, title: title, isPresented: isPresented))
    }
}
