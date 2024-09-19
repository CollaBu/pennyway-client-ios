//
//  View+wrapAnyView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/19/24.
//

import SwiftUI

public extension View {
    func wrapAnyView() -> AnyView {
        AnyView(self)
    }
}
