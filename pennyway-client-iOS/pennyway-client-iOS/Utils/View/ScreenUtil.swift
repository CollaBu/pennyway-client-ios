
import SwiftUI

enum ScreenUtil {
    static func calculateAvailableHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height

        // 네비게이션 바 높이
        let navigationBarHeight = UINavigationController().navigationBar.frame.height

        // 탭바 높이
        let tabBarHeight = UITabBarController().tabBar.frame.height

        // (네비게이션 바 - 탭바) 높이 제거한 뷰의 높이
        let availableHeight = screenHeight - navigationBarHeight - tabBarHeight

        return availableHeight
    }
}
