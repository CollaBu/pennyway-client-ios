import SwiftUI

struct PhoneVerificationView: View {
    @State private var showingPopUp = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @StateObject var oauthAccountLinkingViewModel = OAuthAccountLinkingViewModel()
    
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
   
    var body: some View {
        NavigationAvailable {
            ZStack {
                VStack {
                    Spacer().frame(height: 15)
                    
                    NavigationCountView(selectedText: $viewModel.selectedText)
                        .onAppear {
                            viewModel.selectedText = 1
                        }
                    
                    Spacer().frame(height: 14)
                    
                    PhoneVerificationContentView(phoneVerificationViewModel: phoneVerificationViewModel)
                    
                    Spacer()
                    
                    CustomBottomButton(action: {
                        continueButtonAction()
                    }, label: "계속하기", isFormValid: $phoneVerificationViewModel.isFormValid)
                        .padding(.bottom, 34)
                    
                    NavigationLink(destination: destinationView(), tag: 2, selection: $viewModel.selectedText) {
                        EmptyView()
                    }
                }
                
                if showingPopUp {
                    Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                    ErrorCodePopUpView(showingPopUp: $showingPopUp)
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
    
    private func continueButtonAction() {
        if isOAuthRegistration {
            phoneVerificationViewModel.requestOAuthVerifyVerificationCodeAPI {
                checkFormValid()
            }
        } else {
            phoneVerificationViewModel.requestVerifyVerificationCodeAPI {
                checkFormValid()
            }
        }
    }
    
    private func checkFormValid() {
        if !phoneVerificationViewModel.showErrorVerificationCode, phoneVerificationViewModel.isFormValid {
            showingPopUp = false
            viewModel.continueButtonTapped()
            
            if isOAuthRegistration {
                OAuthRegistrationManager.shared.phone = phoneVerificationViewModel.phoneNumber
                OAuthRegistrationManager.shared.code = phoneVerificationViewModel.verificationCode
                if OAuthRegistrationManager.shared.isExistUser {
                    oauthAccountLinkingViewModel.linkOAuthWithNormalAccountAPI()
                }
            } else {
                RegistrationManager.shared.phoneNumber = phoneVerificationViewModel.phoneNumber
                RegistrationManager.shared.verificationCode = phoneVerificationViewModel.verificationCode
            }
        } else {
            showingPopUp = true
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if !isOAuthRegistration && OAuthRegistrationManager.shared.isOAuthUser {
            OAuthAccountLinkingView(signUpViewModel: viewModel)
          
        } else if isOAuthRegistration && OAuthRegistrationManager.shared.isExistUser {
        } else {
            SignUpView(viewModel: viewModel)
        }
    }
}

#Preview {
    PhoneVerificationView()
}
