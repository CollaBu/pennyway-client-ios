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
    let isAlarmCell: Bool
    @Binding var isAlarmOn: Bool

    var body: some View {
        HStack(spacing: 7 * DynamicSizeFactor.factor()) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 18 * DynamicSizeFactor.factor(), height: 18 * DynamicSizeFactor.factor())
            Text(title)
                .font(.B2SemiboldFont())
                .platformTextColor(color: Color("Gray07"))
            Spacer()

            if isAlarmCell {
                Toggle(isOn: $isAlarmOn) {}
                    .toggleStyle(CustomToggleStyle(hasAppeared: $isAlarmOn))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 27 * DynamicSizeFactor.factor())
    }
}
