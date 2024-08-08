import SwiftUI

struct TermsAndConditionsView: View {
    @StateObject var termsAndConditionsViewModel = TermsAndConditionsViewModel()
    @State private var isAllAgreed = false
    @ObservedObject var viewModel: SignUpNavigationViewModel
    @StateObject var oauthSignUpViewModel = OAuthSignUpViewModel()
    
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    VStack {
                        Spacer().frame(height: 15 * DynamicSizeFactor.factor())
                        
                        NavigationCountView(selectedText: $viewModel.selectedText)
                            .onAppear {
                                viewModel.selectedText = 3
                            }
                        
                        Spacer().frame(height: 14 * DynamicSizeFactor.factor())
                        
                        TermsAndConditionsContentView(isSelectedAllBtn: $isAllAgreed)
                        
                        Spacer()
                    }
                }
            }
            Spacer()
            
            CustomBottomButton(action: {
                if isAllAgreed {
                    viewModel.continueButtonTapped()
                        
                    if isOAuthRegistration {
                        oauthSignUpViewModel.oauthSignUpApi()
                    } else {
                        termsAndConditionsViewModel.requestRegistApi()
                    }
                }
            }, label: "계속하기", isFormValid: $isAllAgreed)
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
                
            NavigationLink(destination: WelcomeView(), tag: 4, selection: $viewModel.selectedText) {
                EmptyView()
            }.hidden()
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
    TermsAndConditionsView(viewModel: SignUpNavigationViewModel())
}
