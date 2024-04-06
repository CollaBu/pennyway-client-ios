import SwiftUI

struct OAuthAccountLinkingView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer().frame(height: 110)
                
                Image("icon_illust_completion")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 68, height: 68)
                
                Spacer().frame(height: 16)
                
                Text("현재 사용 중인 계정이 있어요\n이 아이디와 연동할까요?")
                    .multilineTextAlignment(.center)
                    .font(.pretendard(.semibold, size: 16))
                
                Spacer().frame(height: 30)
                
                ZStack {
                    Text("아이디")
                        .font(.pretendard(.medium, size: 14))
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.vertical, 20)
                }
                .background(Color("Gray01"))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomBottomButton(action: {}, label: "연동하기", isFormValid: .constant(true))
                    .padding(.bottom, 34)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                    
                }.offset(x: -10)
            }
        }
    }
}

#Preview {
    OAuthAccountLinkingView()
}
