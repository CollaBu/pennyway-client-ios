//
//  ChatUserCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/10/24.
//

import SwiftUI

struct ChatUserCell: View {
    let member: ChatMember
    let currentUserId: Int64

    var body: some View {
        HStack(spacing: 3 * DynamicSizeFactor.factor()) {
            Image("icon_illust_error")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 23 * DynamicSizeFactor.factor(), height: 23 * DynamicSizeFactor.factor())
                .cornerRadius(5)

            Text(member.username)
                .font(.B3MediumFont())
                .platformTextColor(color: Color("Gray07"))
                .padding(.leading, 6 * DynamicSizeFactor.factor())

            if member.user_id == currentUserId {
                CustomRoundedBtn(
                    title: "나",
                    fontSize: .B4MediumFont(),
                    fontColor: Color("Gray05"),
                    backgroundColor: Color("Gray01"),
                    horizontalPadding: 4,
                    verticalPadding: 2,
                    cornerRadius: 6,
                    action: {}
                )
            }

            if member.role == "Admin" {
                CustomRoundedBtn(
                    title: "방장",
                    fontSize: .B4MediumFont(),
                    fontColor: Color("Mint03"),
                    backgroundColor: Color("Mint01"),
                    horizontalPadding: 4,
                    verticalPadding: 2,
                    cornerRadius: 6,
                    action: {}
                )
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 27 * DynamicSizeFactor.factor())
    }
}
