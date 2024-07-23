
import SwiftUI

struct CompleteChangePwView: View {
    @Binding var firstNaviLinkActive: Bool

    var body: some View {
        VStack {
            ScrollView {
                Spacer().frame(height: 171 * DynamicSizeFactor.factor())
                    
                Image("icon_illust_completion")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 68 * DynamicSizeFactor.factor(), height: 68 * DynamicSizeFactor.factor())
                    
                Spacer().frame(height: 17 * DynamicSizeFactor.factor())
                    
                Text("새로운 비밀번호가\n성공적으로 설정되었어요")
                    .font(.H3SemiboldFont())
                    .multilineTextAlignment(.center)
                    
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                    
                Text("메인화면으로 돌아갈게요")
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray04"))
                    
                Spacer()
            }
                
            CustomBottomButton(action: {
                firstNaviLinkActive = false
                    NavigationUtil.popToRootView()
                    
                Log.debug("firstNaviLinkActive: \(firstNaviLinkActive)")
            }, label: "메인으로 돌아가기", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CompleteChangePwView(firstNaviLinkActive: .constant(true))
}
