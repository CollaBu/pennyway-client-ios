//
//  CustomRoundedBtn.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import SwiftUI

struct CustomRoundedBtn: View {
    var title: String // 버튼에 표시될 텍스트
    var fontColor: Color // 텍스트 색상 (폰트 색상)
    var backgroundColor: Color // 버튼의 배경 색상
    var style: ButtonStyleType // case-based style
    var action: () -> Void // 버튼이 눌렸을 때 실행될 동작

    enum ButtonStyleType {
        case large
        case small

        var fontSize: Font {
            switch self {
            case .large:
                return .B2MediumFont()
            case .small:
                return .B4MediumFont()
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .large:
                return 10
            case .small:
                return 4
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .large:
                return 7
            case .small:
                return 2
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .large:
                return 14
            case .small:
                return 6
            }
        }
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(style.fontSize)
                .foregroundColor(fontColor)
                .padding(.horizontal, style.horizontalPadding * DynamicSizeFactor.factor())
                .padding(.vertical, style.verticalPadding * DynamicSizeFactor.factor())
                .background(
                    RoundedRectangle(cornerRadius: style.cornerRadius * DynamicSizeFactor.factor())
                        .fill(backgroundColor)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
