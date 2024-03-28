
import SwiftUI

struct ErrorCodePopUpView: View {
    
    @Binding var showingPopUp: Bool
    
    var body: some View {
        if UIScreen.main.bounds.width <= 375 { // iPhone SE/iPhone mini
            PopupContent(imageSize: CGSize(width: 44, height: 44), frameHeight: 150, contentHeight: 70, titleFontSize: 16, subtitleFontSize: 12, showingPopUp: $showingPopUp)
        } else {
            PopupContent(imageSize: CGSize(width: 55, height: 55), frameHeight: 180, contentHeight: 90, titleFontSize: 20, subtitleFontSize: 15, showingPopUp: $showingPopUp)
        }
    }
}

extension ErrorCodePopUpView {
    struct PopupContent: View {

        var imageSize: CGSize
        var frameHeight: CGFloat
        var contentHeight: CGFloat
        var titleFontSize: CGFloat
        var subtitleFontSize: CGFloat
       
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
                                    Image("icon_close")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 24)
                                        .padding(10)
                                }

                            }
                            .alignmentGuide(.top, computeValue: { _ in
                                geometry.frame(in: .global).midY
                            })
                        }
                        
                        Image("icon_illust_error")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize.width, height: imageSize.height)
                            .offset(y:10)
                        
                        Spacer()
                    }
                    .frame(height: contentHeight)
                    
                    Spacer().frame(height: 9)
                    
                    VStack(spacing: 2) {
                        Text("잘못된 인증번호예요")
                            .platformTextColor(color: Color("Gray07"))
                            .font(.pretendard(.semibold, size: titleFontSize))
                        Text("다시 한 번 확인해주세요")
                            .platformTextColor(color: Color("Gray04"))
                            .font(.pretendard(.medium, size: subtitleFontSize))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: UIScreen.main.bounds.width - 120, height: frameHeight)
            .background(Color("White01"))
            .cornerRadius(10)
        }
    }
}
