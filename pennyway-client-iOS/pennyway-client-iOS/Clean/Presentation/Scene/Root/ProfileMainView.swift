//
//  ProfileMainView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import SwiftUI

struct ProfileMainView: View {
    private let profileFactory: any ProfileFactory

    init(
        profileFactory: any ProfileFactory
    ) {
        self.profileFactory = profileFactory
    }

    var body: some View {
        Group {
            profileFactory.makeProfileView()
                .wrapAnyView()
        }
    }
}
