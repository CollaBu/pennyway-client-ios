import SwiftUI

// MARK: - CustomPopUpView

struct CustomPopUpView: View {
    @Binding var showingPopUp: Bool
    let titleLabel: String
    let subTitleLabel: String
    let firstBtnLabel: String
    let secondBtnLabel: String
    let firstBtnColor: Color
    let secondBtnColor: Color
    let firstBtnTextColor: Color
    let secondBtnTextColor: Color

    var body: some View {
        if UIScreen.main.bounds.width <= 375 { // iPhone SE/iPhone mini
            PopupContent(frameHeight: 150, contentHeight: 70, titleFontSize: 16, subtitleFontSize: 12, titleLabel: titleLabel, subTitleLabel: subTitleLabel, firstBtnLabel: firstBtnLabel, secondBtnLabel: secondBtnLabel, firstBtnColor: firstBtnColor, secondBtnColor: secondBtnColor, firstBtnTextColor: firstBtnTextColor, secondBtnTextColor: secondBtnTextColor, showingPopUp: $showingPopUp)
        } else {
            PopupContent(frameHeight: 180, contentHeight: 90, titleFontSize: 16, subtitleFontSize: 12, titleLabel: titleLabel, subTitleLabel: subTitleLabel, firstBtnLabel: firstBtnLabel, secondBtnLabel: secondBtnLabel, firstBtnColor: firstBtnColor, secondBtnColor: secondBtnColor, firstBtnTextColor: firstBtnTextColor, secondBtnTextColor: secondBtnTextColor, showingPopUp: $showingPopUp)
        }
    }
}

// MARK: CustomPopUpView.PopupContent

extension CustomPopUpView {
    struct PopupContent: View {
        var frameHeight: CGFloat
        var contentHeight: CGFloat
        var titleFontSize: CGFloat
        var subtitleFontSize: CGFloat
        let titleLabel: String
        let subTitleLabel: String
        let firstBtnLabel: String
        let secondBtnLabel: String
        let firstBtnColor: Color
        let secondBtnColor: Color
        let firstBtnTextColor: Color
        let secondBtnTextColor: Color

        @Binding var showingPopUp: Bool

        var body: some View {
            VStack {
                Spacer().frame(height: 29 * DynamicSizeFactor.factor())
                Text(titleLabel)
                    .font(.headline)

                Spacer().frame(height: 7 * DynamicSizeFactor.factor())

                Text(subTitleLabel)
                    .font(.subheadline)

                Spacer().frame(height: 25 * DynamicSizeFactor.factor())

                HStack(spacing: 8 * DynamicSizeFactor.factor()) {
                    Button(action: {
                        showingPopUp = false
                    }, label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 97 * DynamicSizeFactor.factor(), height: 36 * DynamicSizeFactor.factor())
                                .background(firstBtnColor)
                                .cornerRadius(6)

                            Text(firstBtnLabel)
                                .platformTextColor(color: firstBtnTextColor)
                                .font(.pretendard(.medium, size: subtitleFontSize))
                        }
                        .padding(.leading, 13 * DynamicSizeFactor.factor())
                    })

                    Button(action: {
                        showingPopUp = false
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 97 * DynamicSizeFactor.factor(), height: 36 * DynamicSizeFactor.factor())
                                .background(secondBtnColor)
                                .cornerRadius(6)

                            Text(secondBtnLabel)
                                .platformTextColor(color: secondBtnTextColor)
                                .font(.pretendard(.medium, size: subtitleFontSize))
                        }
                        .padding(.trailing, 13 * DynamicSizeFactor.factor())
                    })
                }
                .padding(.horizontal, 14 * DynamicSizeFactor.factor())
                .padding(.bottom, 11 * DynamicSizeFactor.factor())
            }
            .frame(maxWidth: 229 * DynamicSizeFactor.factor())
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}
