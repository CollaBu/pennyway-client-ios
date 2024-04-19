import SwiftUI

struct SignUpView: View {
    @StateObject var formViewModel = SignUpFormViewModel()
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var accountLinkingViewModel = OAuthAccountLinkingViewModel()
    @StateObject var oauthRegistViewModel = OAuthRegistViewModel()
    
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
    @State private var isExistUser = OAuthRegistrationManager.shared.isExistUser
    
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
                        RegistrationManager.shared.performRegistration()
                    }
                    
                } else {}
                
            }, label: "계속하기", isFormValid: $formViewModel.isFormValid)
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
