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

    var heightSize: CGFloat? = nil

    var body: some View {
        ZStack {
            // 팝업 바깥 영역을 터치하면 닫히도록 설정
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showingPopUp = false
                }

            PopupContent(
                titleLabel: titleLabel,
                subTitleLabel: subTitleLabel,
                firstBtnAction: firstBtnAction,
                firstBtnLabel: firstBtnLabel,
                secondBtnAction: secondBtnAction,
                secondBtnLabel: secondBtnLabel,
                secondBtnColor: secondBtnColor,
                heightSize: heightSize,
                showingPopUp: $showingPopUp
            )
        }
    }
}

// MARK: CustomPopUpView.PopupContent

extension CustomPopUpView {
    struct PopupContent: View {
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

        let heightSize: CGFloat?

        @Binding var showingPopUp: Bool

        var body: some View {
            ZStack {
                VStack {
                    Spacer().frame(height: 29 * DynamicSizeFactor.factor())
                    Text(titleLabel)
                        .platformTextColor(color: Color("Gray07"))
                        .font(.H3SemiboldFont())
                        .multilineTextAlignment(.center) // 이 라인을 추가하여 텍스트를 가운데 정렬
                        .frame(maxWidth: .infinity)

                    Spacer().frame(height: 7 * DynamicSizeFactor.factor())

                    Text(subTitleLabel)
                        .platformTextColor(color: Color("Gray04"))
                        .font(.B1MediumFont())

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
                                    .font(.B1MediumFont())
                            }
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .buttonStyle(BasicButtonStyleUtil())

                        Button(action: secondBtnAction) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 97 * DynamicSizeFactor.factor(), height: 36 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: secondBtnColor)
                                    .cornerRadius(6)

                                Text(secondBtnLabel)
                                    .platformTextColor(color: Color("White01"))
                                    .font(.B1MediumFont())
                            }
                            .padding(.trailing, 13 * DynamicSizeFactor.factor())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .buttonStyle(BasicButtonStyleUtil())
                    }
                    .padding(.horizontal, 14 * DynamicSizeFactor.factor())
                    .padding(.bottom, 11 * DynamicSizeFactor.factor())
                }
                .frame(maxWidth: 229 * DynamicSizeFactor.factor())
                .background(Color("White01"))
                .cornerRadius(10)
            }
            .frame(width: 229 * DynamicSizeFactor.factor(), height: (heightSize ?? 147) * DynamicSizeFactor.factor())
        }
    }
}
