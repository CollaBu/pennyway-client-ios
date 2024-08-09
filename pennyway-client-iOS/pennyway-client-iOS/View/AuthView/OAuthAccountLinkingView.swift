import SwiftUI

struct OAuthAccountLinkingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var signUpViewModel = SignUpNavigationViewModel()
    
    @State private var isActiveButton = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer().frame(height: 110 * DynamicSizeFactor.factor())
                
                Image("icon_illust_completion")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 68 * DynamicSizeFactor.factor(), height: 68 * DynamicSizeFactor.factor())
                
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                Text("현재 사용 중인 계정이 있어요\n이 아이디와 연동할까요?")
                    .multilineTextAlignment(.center)
                    .font(.H3SemiboldFont())
                
                Spacer().frame(height: 30 * DynamicSizeFactor.factor())
                
                ZStack {
                    Text("\(OAuthRegistrationManager.shared.username)")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.vertical, 20 * DynamicSizeFactor.factor())
                        .frame(maxWidth: .infinity)
                }
                .background(Color("Gray01"))
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomBottomButton(action: {
                    isActiveButton = true
                    
                }, label: "연동하기", isFormValid: .constant(true))
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                NavigationLink(destination: SignUpView(viewModel: signUpViewModel), isActive: $isActiveButton) {}
                    .hidden()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
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
