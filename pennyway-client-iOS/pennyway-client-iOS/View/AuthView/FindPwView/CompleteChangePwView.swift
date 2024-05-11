
import SwiftUI

struct CompleteChangePwView: View {
    var body: some View {
        VStack {
            ScrollView {
                Spacer().frame(height: 171)
                
                Image("icon_illust_completion")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 68, height: 68)
                
                Spacer().frame(height: 17)
                
                Text("새로운 비밀번호가\n성공적으로 설정되었어요")
                    .font(.pretendard(.semibold, size: 16))
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 16)
                
                Text("메인화면으로 돌아갈게요")
                    .font(.pretendard(.medium, size: 14))
                    .platformTextColor(color: Color("Gray04"))
                
                Spacer()
            }
            
            CustomBottomButton(action: {}, label: "메인으로 돌아가기", isFormValid: .constant(true))
                .padding(.bottom, 34)
        }
        
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CompleteChangePwView()
}
