
import SwiftUI

// MARK: - ErrorCodePopUpView

// TODO: 변수명 네이밍 수정필요
struct ErrorCodePopUpView: View {
    @Binding var showingPopUp: Bool
    let titleLabel: String
    let subLabel: String
    let iconType: String?

    var body: some View {
        if showingPopUp {
            Color(.black01).edgesIgnoringSafeArea(.all)
        }
        PopupContent(imageSize: CGSize(width: 44 * DynamicSizeFactor.factor(), height: 44 * DynamicSizeFactor.factor()), frameHeight: 145 * DynamicSizeFactor.factor(), contentHeight: 70 * DynamicSizeFactor.factor(), titleLabel: titleLabel, subLabel: subLabel, iconType: iconType, showingPopUp: $showingPopUp)
    }
}

// MARK: ErrorCodePopUpView.PopupContent

extension ErrorCodePopUpView {
    struct PopupContent: View {
        var imageSize: CGSize
        var frameHeight: CGFloat
        var contentHeight: CGFloat
        let titleLabel: String
        let subLabel: String
        let iconType: String?

        @Binding var showingPopUp: Bool
        
        var body: some View {
            ZStack {
                VStack(alignment: .center) {
                    Spacer().frame(height: 0)

                    ZStack {
                        GeometryReader { geometry in
                            HStack {
                                Spacer()
                                Button(action: {
                                    showingPopUp = false
                                }) {
                                    Image(iconName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                }
                                .frame(width: 44, height: 44)
                                .buttonStyle(BasicButtonStyleUtil())
                            }
                            .alignmentGuide(.top, computeValue: { _ in
                                geometry.frame(in: .global).midY
                            })
                        }

                        Image("icon_illust_error")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize.width, height: imageSize.height)
                            .offset(y: 10 * DynamicSizeFactor.factor())

                        Spacer()
                    }
                    .frame(height: contentHeight)

                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                    VStack(spacing: 2 * DynamicSizeFactor.factor()) {
                        Text(titleLabel)
                            .platformTextColor(color: Color("Gray07"))
                            .font(.H3SemiboldFont())

                        Spacer().frame(height: 1)

                        Text(subLabel)
                            .platformTextColor(color: Color("Gray04"))
                            .font(.B1MediumFont())
                    }
                    Spacer()
                }
                .frame(height: frameHeight)
            }
            .frame(maxWidth: .infinity)
            .background(Color("White01"))
            .cornerRadius(10)
            .padding(.horizontal, 40)
        }
        
        // 아이콘 타입에 따라 아이콘 이름 매핑
        private var iconName: String {
            switch iconType {
            case "check":
                return "icon_chatRoom_check"
            default:
                return "icon_close"
            }
        }
    }
}
