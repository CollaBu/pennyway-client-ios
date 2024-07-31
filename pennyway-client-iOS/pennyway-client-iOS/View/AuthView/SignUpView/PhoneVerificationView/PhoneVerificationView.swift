import SwiftUI

struct PhoneVerificationView: View {
    @State private var showCodeErrorPopUp = false
    @State private var showManyRequestPopUp = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @StateObject var oauthAccountLinkingViewModel = LinkOAuthToAccountViewModel()
    @EnvironmentObject var authViewModel: AppViewModel
    let profileInfoViewModel = UserAccountViewModel()
   
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 15 * DynamicSizeFactor.factor())
                
                NavigationCountView(selectedText: $viewModel.selectedText)
                    .onAppear {
                        viewModel.selectedText = 1
                    }
                
                Spacer().frame(height: 14 * DynamicSizeFactor.factor())
                
                PhoneVerificationContentView(phoneVerificationViewModel: phoneVerificationViewModel, showManyRequestPopUp: $showManyRequestPopUp)
                
                Spacer()
                
                CustomBottomButton(action: {
                    continueButtonAction()
                }, label: "계속하기", isFormValid: $phoneVerificationViewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                
                NavigationLink(destination: destinationView(), tag: 2, selection: $viewModel.selectedText) {
                    EmptyView()
                }
            }
            
            if showCodeErrorPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showCodeErrorPopUp, titleLabel: "잘못된 인증번호예요", subLabel: "다시 한번 확인해주세요")
            }
            
            if showManyRequestPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showManyRequestPopUp, titleLabel: "인증 요청 제한 횟수를 초과했어요", subLabel: "24시간 후에 다시 시도해주세요")
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton(action: {
                        if OAuthRegistrationManager.shared.isOAuthRegistration { 
                            KeychainHelper.deleteOAuthUserData()
                        }
                    })
                    
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    
                }.offset(x: -10)
            }
        }
    }
    
    private func continueButtonAction() {
        if OAuthRegistrationManager.shared.isOAuthRegistration {
            phoneVerificationViewModel.requestOAuthVerifyVerificationCodeApi {
                checkFormValid()
            }
        } else {
            phoneVerificationViewModel.requestVerifyVerificationCodeApi {
                checkFormValid()
            }
        }
    }
    
    private func checkFormValid() {
        if !phoneVerificationViewModel.showErrorVerificationCode && !phoneVerificationViewModel.showErrorExistingUser
            && phoneVerificationViewModel.isFormValid
        {
            showCodeErrorPopUp = false
            viewModel.continueButtonTapped()
            
            if OAuthRegistrationManager.shared.isOAuthRegistration {
                OAuthRegistrationManager.shared.phone = phoneVerificationViewModel.phoneNumber
                OAuthRegistrationManager.shared.code = phoneVerificationViewModel.code
                if OAuthRegistrationManager.shared.isExistUser {
                    oauthAccountLinkingViewModel.linkOAuthToAccountApi()
                }
            } else {
                RegistrationManager.shared.phoneNumber = phoneVerificationViewModel.phoneNumber
                RegistrationManager.shared.code = phoneVerificationViewModel.code
            }
        } else {
            if phoneVerificationViewModel.showErrorVerificationCode {
                showCodeErrorPopUp = true
            }
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if !OAuthRegistrationManager.shared.isOAuthRegistration && OAuthRegistrationManager.shared.isOAuthUser {
            OAuthAccountLinkingView(signUpViewModel: viewModel)

        } else if OAuthRegistrationManager.shared.isOAuthRegistration && OAuthRegistrationManager.shared.isExistUser { // 이미 계정이 있는 경우
            handleExistUserLogin()
        } else {
            SignUpView(viewModel: viewModel)
        }
    }
    
    func handleExistUserLogin() -> some View {
        authViewModel.login()
        profileInfoViewModel.getUserProfileApi { _ in }
        return EmptyView()
    }
}

#Preview {
    PhoneVerificationView()
}
