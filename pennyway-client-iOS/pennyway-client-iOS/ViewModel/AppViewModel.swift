
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func logout() {
        isLoggedIn = false
    }
}
