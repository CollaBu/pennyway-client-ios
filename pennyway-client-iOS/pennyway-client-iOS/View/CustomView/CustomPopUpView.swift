import SwiftUI

// MARK: - CustomPopUpView

struct CustomPopUpView: View {
    @Binding var showingPopUp: Bool

    /// title 지정
    let titleLabel: String
    let subTitleLabel: String

    /// 첫 번째 버튼 관련
    let firstBtnAction: () -> Void
    let firstBtnLabel: String

    /// 두 번째 버튼 관련
    let secondBtnAction: () -> Void
    let secondBtnLabel: String
    let secondBtnColor: Color

    var body: some View {
        PopupContent(titleFontSize: 16, subtitleFontSize: 12,
                     titleLabel: titleLabel,
                     subTitleLabel: subTitleLabel,
                     firstBtnAction: firstBtnAction,
                     firstBtnLabel: firstBtnLabel,
                     secondBtnAction: secondBtnAction,
                     secondBtnLabel: secondBtnLabel,
                     secondBtnColor: secondBtnColor,
                     showingPopUp: $showingPopUp)
    }
}

// MARK: CustomPopUpView.PopupContent

extension CustomPopUpView {
    struct PopupContent: View {
        var titleFontSize: CGFloat
        var subtitleFontSize: CGFloat
        /// title 지정
        let titleLabel: String
        let subTitleLabel: String

        /// 첫 번째 버튼 관련
        let firstBtnAction: () -> Void
        let firstBtnLabel: String

        /// 두 번째 버튼 관련
        let secondBtnAction: () -> Void
        let secondBtnLabel: String
        let secondBtnColor: Color

        @Binding var showingPopUp: Bool

        var body: some View {
            ZStack {
                VStack {
                    Spacer().frame(height: 29 * DynamicSizeFactor.factor())
                    Text(titleLabel)
                        .font(.pretendard(.semibold, size: titleFontSize))

                    Spacer().frame(height: 7 * DynamicSizeFactor.factor())

                    Text(subTitleLabel)
                        .platformTextColor(color: Color("Gray04"))
                        .font(.pretendard(.medium, size: subtitleFontSize))

                    Spacer().frame(height: 25 * DynamicSizeFactor.factor())

                    HStack(spacing: 8 * DynamicSizeFactor.factor()) {
                        Button(action: firstBtnAction) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 97 * DynamicSizeFactor.factor(), height: 36 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: Color("Gray02"))
                                    .cornerRadius(6)

                                Text(firstBtnLabel)
                                    .platformTextColor(color: Color("Gray04"))
                                    .font(.pretendard(.medium, size: subtitleFontSize))
                            }
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                        }

                        Button(action: secondBtnAction) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 97 * DynamicSizeFactor.factor(), height: 36 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: secondBtnColor)
                                    .cornerRadius(6)

                                Text(secondBtnLabel)
                                    .platformTextColor(color: Color("White01"))
                                    .font(.pretendard(.medium, size: subtitleFontSize))
                            }
                            .padding(.trailing, 13 * DynamicSizeFactor.factor())
                        }
                    }
                    .padding(.horizontal, 14 * DynamicSizeFactor.factor())
                    .padding(.bottom, 11 * DynamicSizeFactor.factor())
                }
                .frame(maxWidth: 229 * DynamicSizeFactor.factor())
                .background(Color.white)
                .cornerRadius(10)
            }
            .frame(width: 229 * DynamicSizeFactor.factor(), height: 147 * DynamicSizeFactor.factor())
        }
    }
}
