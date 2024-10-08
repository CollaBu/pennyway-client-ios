//
//  ChatReceiveCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatReceiveCell

struct ChatReceiveCell: View {
    let chat: Chat
    let sender: ChatMember

    var body: some View {
        HStack(alignment: .top, spacing: 11 * DynamicSizeFactor.factor()) {
            // 프로필 이미지

            ZStack {
                Rectangle()
                    .platformTextColor(color: Color("White01"))
                    .frame(width: 27 * DynamicSizeFactor.factor(), height: 27 * DynamicSizeFactor.factor())
                    .cornerRadius(3)
                Image("icon_ current_spending")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 27 * DynamicSizeFactor.factor(), height: 27 * DynamicSizeFactor.factor())
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 5 * DynamicSizeFactor.factor()) {
                // 사용자 이름
                Text(sender.username)
                    .font(.B3MediumFont())
                    .platformTextColor(color: Color("Gray06"))

                ChatMessage(content: chat.content, createdAt: chat.created_at, isSender: false)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
