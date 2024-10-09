//
//  SideMenuCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/10/24.
//

import SwiftUI

struct SideMenuCell: View {
    let title: String
    let imageName: String

    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 17, height: 17)
            Text(title)
                .font(.system(size: 16))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
    }
}
