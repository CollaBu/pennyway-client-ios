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
        HStack(spacing: 7) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
            Text(title)
                .font(.B2SemiboldFont())
                .platformTextColor(color: Color("Gray07"))
            Spacer()

            if isAlarmCell {
                Toggle(isOn: $isAlarmOn) {}
                    .toggleStyle(CustomToggleStyle(hasAppeared: $isAlarmOn))
                    .animation(.easeInOut(duration: 0.5))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 27 * DynamicSizeFactor.factor())
    }
}
