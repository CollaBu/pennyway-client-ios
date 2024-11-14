//
//  ChatUserCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/10/24.
//

import SwiftUI

struct ChatUserCell: View {
    let member: ChatMemberItemModel
    let currentUserId: Int64

    var body: some View {
        HStack(spacing: 3 * DynamicSizeFactor.factor()) {
            Image("icon_chat_no profile picture_square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 23 * DynamicSizeFactor.factor(), height: 23 * DynamicSizeFactor.factor())
                .cornerRadius(5)

            Text(member.name)
                .font(.B3MediumFont())
                .platformTextColor(color: Color("Gray07"))
                .padding(.leading, 6 * DynamicSizeFactor.factor())

            if member.userId == currentUserId {
                CustomRoundedBtn(
                    title: "나",
                    fontColor: Color("Gray05"),
                    backgroundColor: Color("Gray01"),
                    style: .small,
                    action: {}
                )
            }

            if member.role.rawValue == Role.admin.rawValue {
                CustomRoundedBtn(
                    title: "방장",
                    fontColor: Color("Mint03"),
                    backgroundColor: Color("Mint01"),
                    style: .small,
                    action: {}
                )
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 27 * DynamicSizeFactor.factor())
    }
}
