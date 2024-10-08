//
//  ChatDateHeader.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatDateHeader: View {
    let date: String

    var body: some View {
        ZStack {
            Rectangle()
                .platformTextColor(color: Color("White01"))
                .cornerRadius(19)
                .frame(width: 106 * DynamicSizeFactor.factor(), height: 21 * DynamicSizeFactor.factor())

            Text(date)
                .font(.B3MediumFont())
                .foregroundColor(Color("Gray05"))
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
        }
    }
}

#Preview {
    ChatDateHeader(date: "2020년 8월 21일 금요일")
}
