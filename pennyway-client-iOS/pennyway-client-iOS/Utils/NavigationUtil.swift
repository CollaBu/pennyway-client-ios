import SwiftUI

// MARK: - NavigationUtil

enum NavigationUtil {
    static func popToRootView() {
        let keyWindow = UIApplication.shared.connectedScenes

            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first

        // 루트 뷰 컨트롤러의 이름 출력
        if let rootViewController = keyWindow?.rootViewController {
            Log.debug("Root ViewController name: \(String(describing: type(of: rootViewController)))")
        }

        // TabBarController가 루트 컨트롤러인 경우
        if let tabBarController = keyWindow?.rootViewController as? UITabBarController {
            // 원하는 탭으로 설정 (여기서는 첫 번째 탭으로 설정)
            tabBarController.selectedIndex = 0

            // 선택된 탭 내의 NavigationController를 찾아 루트로 이동
            if let navController = tabBarController.selectedViewController as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        } else {
            // 루트 뷰 컨트롤러에서 NavigationController를 찾아 루트로 이동
            findNavigationController(viewController: keyWindow?.rootViewController)?
                .popToRootViewController(animated: true)
        }
    }

    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }

        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }

        for childViewController in viewController.children {
            if let navigationController = findNavigationController(viewController: childViewController) {
                return navigationController
            }
        }

        return nil
    }

    static func popToView(at index: Int) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first

        guard let navigationController = findNavigationController(viewController: keyWindow?.rootViewController) else {
            Log.fault("No navigation controller found")
            return
        }

        let viewControllersCount = navigationController.viewControllers.count

        guard index < viewControllersCount else {
            Log.error("Index out of bounds")
            return
        }

        let targetViewController = navigationController.viewControllers[index]
        Log.debug("Navigating to view controller at index \(index): \(targetViewController)")
        navigationController.popToViewController(targetViewController, animated: true)
    }
}
