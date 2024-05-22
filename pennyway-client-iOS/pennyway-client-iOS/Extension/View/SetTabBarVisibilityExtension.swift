
import SwiftUI

extension View {
    /// 탭바 숨김 처리 여부
    func setTabBarVisibility(isHidden: Bool) -> some View {
        background(TabBarAccessor { tabBar in
            Log.debug(">> TabBar height: \(tabBar.bounds.height)")
            tabBar.isHidden = isHidden
        })
    }
}

// MARK: - TabBarAccessor

struct TabBarAccessor: UIViewControllerRepresentable {
    var callback: (UITabBar) -> Void
    private let proxyController = ViewController()

    func makeUIViewController(context _: UIViewControllerRepresentableContext<TabBarAccessor>) ->
        UIViewController
    {
        proxyController.callback = callback
        return proxyController
    }

    func updateUIViewController(_: UIViewController, context _: UIViewControllerRepresentableContext<TabBarAccessor>) {}

    typealias UIViewControllerType = UIViewController

    /// viewWillAppear가 나타날 때 가지고 있는 탭바를 클로저 콜백으로 넘겨준다.
    private class ViewController: UIViewController {
        var callback: (UITabBar) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = tabBarController {
                callback(tabBar.tabBar)
            }
        }
    }
}
