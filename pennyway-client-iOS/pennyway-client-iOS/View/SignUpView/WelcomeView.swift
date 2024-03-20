import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack{
            Image("icon_illust_welcome")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 160)
                .padding(.horizontal, 80)
                .padding(.bottom, 20) //임시 작성한 패딩 값
            
            
            Text("이주원님 환영해요!")
                .font(.pretendard(.semibold, size: 24))
                .padding(.horizontal, 73)
                .padding(.bottom, 12)
            
            Text("페니웨이와 절약을 시작해볼까요?")
                .font(.pretendard(.medium, size: 14))
                .platformTextColor(color: Color("Gray04"))
            
            Spacer().frame(height: 158)
            
            Button(action: {
                
            }, label: {
                ZStack{
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 47)
                        .platformTextColor(color: Color("Mint03"))
                        .cornerRadius(4)
                        .padding(.horizontal, 20)
                    
                    Text("확인")
                        .font(.pretendard(.semibold, size: 14))
                        .platformTextColor(color: .white)
                }
            })
            .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
        }
    }
}

#Preview {
    WelcomeView()
}
