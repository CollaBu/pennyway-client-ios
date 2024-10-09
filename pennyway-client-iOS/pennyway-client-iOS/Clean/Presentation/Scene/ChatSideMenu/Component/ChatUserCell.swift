//
//  ChatUserCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/10/24.
//

import SwiftUI

struct ChatUserCell: View {
    let name: String
    let status: String

    var body: some View {
        HStack {
            Image("icon_illust_error")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 16))
                Text(status)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
}
