//
//  ChatReceiveCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatReceiveCell

struct ChatReceiveCell: View, ImageLoadable {
    @State private var loadedImage: UIImage? = nil
    let chat: MessageItemModel
    let sender: ChatMemberItemModel

    var body: some View {
        HStack(alignment: .top, spacing: 11 * DynamicSizeFactor.factor()) {
            // 프로필 이미지

            if let image = loadedImage {
                // 프로필 이미지가 다운로드되었을 때
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 27 * DynamicSizeFactor.factor(), height: 27 * DynamicSizeFactor.factor())
                    .cornerRadius(3)
            } else {
                // 이미지가 없을 경우 기본 이미지
                Image("icon_chat_no profile picture_square")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 27 * DynamicSizeFactor.factor(), height: 27 * DynamicSizeFactor.factor())
                    .cornerRadius(3)
            }

            VStack(alignment: .leading, spacing: 5 * DynamicSizeFactor.factor()) {
                // 사용자 이름
                Text(sender.name)
                    .font(.B3MediumFont())
                    .platformTextColor(color: Color("Gray06"))

                ChatMessage(content: chat.content, createdAt: chat.createdAt, isSender: false)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear {
            if sender.profileImage != "" {
                loadImage(from: sender.profileImage ?? "") { image in
                    self.loadedImage = image
                }
            }
        }
    }
}
