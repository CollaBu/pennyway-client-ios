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
    let maxWidth: CGFloat = 151 * DynamicSizeFactor.factor()

    var body: some View {
        HStack(spacing: 9) {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color("White01"))
                        .cornerRadius(6)
                        .border(Color.black, width: 1)

                    Text(content)
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(width: min(geometry.size.width, maxWidth),
                       height: geometry.size.height)
            }
            .frame(maxWidth: maxWidth)
            .fixedSize(horizontal: false, vertical: true)

            VStack {
                Spacer()
                // 타임스탬프
                Text(createdAt, style: .time)
                    .font(.B4MediumFont())
                    .platformTextColor(color: Color("Gray05"))
            }
        }
    }
}
