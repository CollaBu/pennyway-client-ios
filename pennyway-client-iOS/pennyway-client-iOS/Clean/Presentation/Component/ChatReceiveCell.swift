//
//  ChatReceiveCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatReceiveCell: View {
    let chat: Chat
    let sender: ChatMember
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // 프로필 이미지
            AsyncImage(url: URL(string: sender.profile_image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                // 사용자 이름
                Text(sender.username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // 메시지 내용
                Text(chat.content)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                // 타임스탬프
                Text(chat.created_at, style: .time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
