//
//  ChatMessage.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatMessage: View {
    let content: String
    let createdAt: Date
    let isSender: Bool
    let maxWidth: CGFloat = 151 * DynamicSizeFactor.factor()
    @State private var textWidth: CGFloat = .zero

    var body: some View {
        HStack(spacing: 9 * DynamicSizeFactor.factor()) {
            if isSender {
                // 타임스탬프 왼쪽 (isSender가 true일 때)
                VStack {
                    Spacer()
                    Text(createdAt, style: .time)
                        .font(.B4MediumFont())
                        .platformTextColor(color: Color("Gray05"))
                }
            }

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(isSender ? Color("Yellow01") : Color("White01"))
                    .cornerRadius(6)

                Text(content)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(key: TextHeightPreferenceKey.self, value: geo.size.height)
                            Color.clear.preference(key: TextWidthPreferenceKey.self, value: geo.size.width)
                        }
                    )
            }
            .onPreferenceChange(TextWidthPreferenceKey.self) { width in
                self.textWidth = width
            }
            .frame(minWidth: textWidth, maxWidth: maxWidth)
            .fixedSize(horizontal: false, vertical: true)

            if !isSender {
                // 타임스탬프 오른쪽 (isSender가 false일 때)
                VStack {
                    Spacer()
                    Text(createdAt, style: .time)
                        .font(.B4MediumFont())
                        .platformTextColor(color: Color("Gray05"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: isSender ? .trailing : .leading)
    }
}
