
import SwiftUI

// MARK: - RootDependency

protocol RootDependency {
    var profileFactory: any ProfileFactory { get }
}

// MARK: - RootComponent

final class RootComponent {
    private let dependency: RootDependency

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    func makeView() -> some View {
        ProfileMainView(
            profileFactory: dependency.profileFactory
        )
    }
}
