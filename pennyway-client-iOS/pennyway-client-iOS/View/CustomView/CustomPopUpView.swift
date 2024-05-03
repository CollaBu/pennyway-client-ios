

import SwiftUI

// MARK: - CustomPopUpView

struct CustomPopUpView: View {
    @Binding var showingPopUp: Bool
    let titleLabel: String // title text 지정
    let subTitleLabel: String // subtitle text 지정
    let firstBtnLabel: String // 첫번째 버튼 text 지정
    let secondBtnLabel: String // 두번째 버튼 text 지정
    let firstBtnColor: Color // 첫번째 버튼 배경색 지정
    let secondBtnColor: Color // 두번째 버튼 배경색 지정
    let firstBtnTextColor: Color // 첫번째 버튼 글자색 지정
    let secondBtnTextColor: Color // 두번째 버튼 글자색 지정

    var body: some View {
        if UIScreen.main.bounds.width <= 375 { // iPhone SE/iPhone mini
            PopupContent(frameHeight: 150, contentHeight: 70, titleFontSize: 16, subtitleFontSize: 12, titleLabel: titleLabel, subTitleLabel: subTitleLabel, firstBtnLabel: firstBtnLabel, secondBtnLabel: secondBtnLabel, firstBtnColor: firstBtnColor, secondBtnColor: secondBtnColor, firstBtnTextColor: firstBtnTextColor, secondBtnTextColor: secondBtnTextColor, showingPopUp: $showingPopUp)
        } else {
            PopupContent(frameHeight: 180, contentHeight: 90, titleFontSize: 20, subtitleFontSize: 15, titleLabel: titleLabel, subTitleLabel: subTitleLabel, firstBtnLabel: firstBtnLabel, secondBtnLabel: secondBtnLabel, firstBtnColor: firstBtnColor, secondBtnColor: secondBtnColor, firstBtnTextColor: firstBtnTextColor, secondBtnTextColor: secondBtnTextColor, showingPopUp: $showingPopUp)
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
            VStack(alignment: .center) {
                VStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Text(titleLabel)
                            .platformTextColor(color: Color.black)
                            .font(.pretendard(.semibold, size: titleFontSize))

                        Spacer().frame(height: 7)
                        Text(subTitleLabel)
                            .platformTextColor(color: Color("Gray04"))
                            .font(.pretendard(.medium, size: subtitleFontSize))
                    }

                    .frame(height: contentHeight)

                    HStack {
                        Button(action: {
                            showingPopUp = false
                        }, label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 97 * DynamicSizeFactor.factor(), height: 37 * DynamicSizeFactor.factor())
                                    .background(firstBtnColor)
                                    .cornerRadius(6)

                                Text(firstBtnLabel)
                                    .platformTextColor(color: firstBtnTextColor)
                                    .font(.pretendard(.medium, size: subtitleFontSize))
                            }
                        })

                        Spacer()

                        Button(action: {
                            // logoutApi()
                        }, label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 97 * DynamicSizeFactor.factor(), height: 37 * DynamicSizeFactor.factor())
                                    .background(secondBtnColor)
                                    .cornerRadius(6)

                                Text(secondBtnLabel)
                                    .platformTextColor(color: secondBtnTextColor)
                                    .font(.pretendard(.medium, size: subtitleFontSize))
                            }
                        })
                    }
                    .padding(.horizontal, 14 * DynamicSizeFactor.factor())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: UIScreen.main.bounds.width - 120, height: frameHeight)
            .background(Color("White01"))
            .cornerRadius(10)
        }
    }
}
