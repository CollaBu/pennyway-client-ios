import SwiftUI

enum NavigationUtil {
    static func popToRootView() {
        let keyWindow = UIApplication.shared.connectedScenes

            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first

        findNavigationController(viewController: keyWindow?.rootViewController)?

            .popToRootViewController(animated: true)
    }

    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }

        if let navigationController = viewController as? UINavigationController {
             Log.debug(navigationController)
            return navigationController
        }

        for childViewController in viewController.children {
             Log.debug(childViewController)
            return findNavigationController(viewController: childViewController)
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
