//
//  CustomRoundedBtn.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import SwiftUI

struct CustomRoundedBtn: View {
    var title: String // 버튼에 표시될 텍스트
    var fontSize: Font
    var fontColor: Color // 텍스트 색상 (폰트 색상)
    var backgroundColor: Color // 버튼의 배경 색상
    var horizontalPadding: CGFloat
    var verticalPadding: CGFloat
    var cornerRadius: CGFloat 
    var action: () -> Void // 버튼이 눌렸을 때 실행될 동작

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(fontSize)
                .foregroundColor(fontColor)
                .padding(.horizontal, horizontalPadding * DynamicSizeFactor.factor())
                .padding(.vertical, verticalPadding * DynamicSizeFactor.factor())
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius * DynamicSizeFactor.factor())
                        .fill(backgroundColor)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
