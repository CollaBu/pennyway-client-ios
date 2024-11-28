import SwiftUI

extension UIApplication {
    static var shouldDismissKeyboard: Bool = true // 키보드 닫기 여부

    func addTapGestureRecognizer() {
        guard let window = windows.first else {
            return
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }

    /// 화면 터치하는 경우 실행
    @objc private func handleTapGesture(_: UITapGestureRecognizer) {
        guard let window = windows.first else {
            return
        }

        // shouldDismissKeyboard가 true이면 키보드 닫기
        if UIApplication.shouldDismissKeyboard {
            window.endEditing(true)
        }
    }
}

// MARK: - UIApplication + UIGestureRecognizerDelegate

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
