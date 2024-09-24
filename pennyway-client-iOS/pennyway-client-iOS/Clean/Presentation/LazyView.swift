//
//  LazyView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/24/24.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
