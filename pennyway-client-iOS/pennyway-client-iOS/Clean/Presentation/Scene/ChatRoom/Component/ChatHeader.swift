//
//  ChatDateHeader.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatHeader: View {
    let data: String

    var body: some View {
        ZStack {
            Rectangle()
                .platformTextColor(color: Color("White01"))
                .cornerRadius(19)
                .frame(width: 106 * DynamicSizeFactor.factor(), height: 21 * DynamicSizeFactor.factor())

            Text(data)
                .font(.B3MediumFont())
                .platformTextColor(color: Color("Gray05"))
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
        }
    }
}

#Preview {
    ChatHeader(data: "2020년 8월 21일 금요일")
}
