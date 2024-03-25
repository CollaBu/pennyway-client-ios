import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack{
            VStack{
                Image("icon_illust_welcome")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 160)
                    .padding(.top, 71)
                    .padding(.horizontal, 80)
                    .padding(.bottom, 20)
                
                Text("이주원님 환영해요!")
                    .font(.pretendard(.semibold, size: 24))
                    .padding(.horizontal, 73)
                    .padding(.bottom, 12)
                
                Text("페니웨이와 절약을 시작해볼까요?")
                    .font(.pretendard(.medium, size: 14))
                    .platformTextColor(color: Color("Gray04"))
                
                Spacer()
                
                CustomBottomButton(action: {
                    
                }, label: "확인")
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                .border(Color.black)
            }
            .border(Color.black)
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
    WelcomeView()
}
