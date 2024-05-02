import SwiftUI

struct SignUpView: View {
    @StateObject var formViewModel = SignUpFormViewModel()
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var accountLinkingViewModel = OAuthAccountLinkingViewModel()
    
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
    @State private var isExistUser = OAuthRegistrationManager.shared.isExistUser
    private var buttonText: String {
        if !isOAuthRegistration && OAuthRegistrationManager.shared.isOAuthUser {
            return "연동하기"
        } else {
            return "계속하기"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 47) {
                VStack {
                    Spacer().frame(height: 15)
                    
                    NavigationCountView(selectedText: $viewModel.selectedText)
                        .onAppear {
                            viewModel.selectedText = 2
                        }
                    
                    Spacer().frame(height: 14)
                    
                    SignUpFormView(formViewModel: formViewModel)
                }
            }
        }
        
        VStack {
            CustomBottomButton(action: {
                if formViewModel.isFormValid {
                    viewModel.continueButtonTapped()
                    
                    if isOAuthRegistration {
                        OAuthRegistrationManager.shared.name = formViewModel.name
                        OAuthRegistrationManager.shared.username = formViewModel.id
                        OAuthRegistrationManager.shared.password = formViewModel.password
                    } else {
                        RegistrationManager.shared.name = formViewModel.name
                        RegistrationManager.shared.username = formViewModel.id
                        RegistrationManager.shared.password = formViewModel.password
                    }
                    
                } else {}
                
            }, label: buttonText, isFormValid: $formViewModel.isFormValid)
                .padding(.bottom, 34)
            
            NavigationLink(destination: destinationView(), tag: 3, selection: $viewModel.selectedText) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
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
                    
                }.offset(x: -10)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if !isOAuthRegistration && OAuthRegistrationManager.shared.isOAuthUser {
        } else {
            TermsAndConditionsView(viewModel: viewModel)
        }
    }
}

#Preview {
    SignUpView(viewModel: SignUpNavigationViewModel())
}
