//
//  HeightPreferenceView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - TextHeightPreferenceKey

struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - TextHeightPreferenceView

struct TextHeightPreferenceView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 1)
            .preference(key: TextHeightPreferenceKey.self, value: 1)
    }
}
