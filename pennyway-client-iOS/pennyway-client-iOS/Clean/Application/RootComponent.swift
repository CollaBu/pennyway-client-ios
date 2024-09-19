//
//  RootComponent.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

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
