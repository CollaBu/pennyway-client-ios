import SwiftUI

struct SignUpView: View {
    @StateObject var formViewModel = SignUpFormViewModel()
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var linkAccountToOAuthViewModel = LinkAccountToOAuthViewModel()

    @EnvironmentObject var authViewModel: AppViewModel
    let profileInfoViewModel = UserAccountViewModel()
    
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
    @State private var isExistUser = OAuthRegistrationManager.shared.isExistUser
    
    @State var initTargetAmount = TargetAmount(year: 0, month: 0, targetAmountDetail: AmountDetail(id: -1, amount: -1, isRead: false), totalSpending: 0, diffAmount: 0)
    
    private var buttonText: String {
        if !isOAuthRegistration && OAuthRegistrationManager.shared.isOAuthUser {
            return "연동하기"
        } else {
            return "계속하기"
        }
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 47 * DynamicSizeFactor.factor()) {
                    VStack {
                        Spacer().frame(height: 15 * DynamicSizeFactor.factor())
                        
                        NavigationCountView(selectedText: $viewModel.selectedText)
                            .onAppear {
                                viewModel.selectedText = 2
                            }
                        
                        Spacer().frame(height: 14 * DynamicSizeFactor.factor())
                        
                        SignUpFormView(formViewModel: formViewModel)
                        
                        Spacer().frame(height: 65 * DynamicSizeFactor.factor())
                    }
                }
            }
            Spacer()
            
            CustomBottomButton(action: {
                if formViewModel.isFormValid {
                    if isOAuthRegistration {
                        OAuthRegistrationManager.shared.name = formViewModel.name
                        OAuthRegistrationManager.shared.username = formViewModel.id
                        OAuthRegistrationManager.shared.password = formViewModel.password
                        viewModel.continueButtonTapped()
                    } else {
                        RegistrationManager.shared.name = formViewModel.name
                        RegistrationManager.shared.username = formViewModel.id
                        RegistrationManager.shared.password = formViewModel.password
                        if !isOAuthRegistration, OAuthRegistrationManager.shared.isOAuthUser {
                            handleLinkAccountToOAuth()
                        } else {
                            viewModel.continueButtonTapped()
                        }
                    }
                }
                
            }, label: buttonText, isFormValid: $formViewModel.isFormValid)
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
            
            NavigationLink(destination: destinationView(), tag: 3, selection: $viewModel.selectedText) {}.hidden()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        if isOAuthRegistration { // 소셜 회원가입 중 취소
                            KeychainHelper.deleteOAuthUserData()
                        }
                        NavigationUtil.popToRootView()
                    }, label: {
                        Image("icon_arrow_back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .padding(5)
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .buttonStyle(BasicButtonStyleUtil())
                    
                }.offset(x: -10)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if !(!isOAuthRegistration && OAuthRegistrationManager.shared.isOAuthUser) {
            TermsAndConditionsView(viewModel: viewModel)
        }
    }
    
    func handleLinkAccountToOAuth() {
        linkAccountToOAuthViewModel.linkAccountToOAuthApi { success in
            if success {
                profileInfoViewModel.getUserProfileApi { success in
                    authViewModel.login()
                }
            } else {
                Log.error("기존 계정에 소셜 계정 연동 실패")
            }
        }
    }
}

#Preview {
    SignUpView(viewModel: SignUpNavigationViewModel())
}
