import SwiftUI

struct FindIDFormView: View {
    @State private var showingPopUp = false
    ///    @State private var isFindUsername = RegistrationManager.shared.isFindUsername
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @State private var navigateToFindIDView = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var findUserNameViewModel = FindUserNameViewModel()
    
    var body: some View {
        NavigationAvailable {
            ZStack {
                ScrollView {
                    FindIDContentView(phoneVerificationViewModel: phoneVerificationViewModel)
                }
                Spacer().frame(height: 203)
                
                Spacer()
                
                VStack {
                    Spacer()
                    
                    CustomBottomButton(action: {
                        continueButtonAction()
                        navigateToFindIDView = true
                        
                    }, label: "아이디 찾기", isFormValid: $phoneVerificationViewModel.isFormValid)
                        .padding(.bottom, 34)
                    
                    NavigationLink(destination: FindIDView(phoneVerificationViewModel: PhoneVerificationViewModel()), isActive: $navigateToFindIDView) {
                        EmptyView()
                    }.hidden()
                }
            }
            .navigationTitle(Text("아이디 찾기"))
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
        if phoneVerificationViewModel.isFormValid {
            phoneVerificationViewModel.requestUserNameVerifyVerificationCodeApi {
                checkFormValid()
            }
        }
    }
    
    private func checkFormValid() {
        if !phoneVerificationViewModel.showErrorVerificationCode && !phoneVerificationViewModel.showErrorExistingUser && phoneVerificationViewModel.isFormValid {
            showingPopUp = false
            viewModel.continueButtonTapped()
            
            //            RegistrationManager.shared.phoneNumber = phoneVerificationViewModel.phoneNumber
            //            RegistrationManager.shared.code = phoneVerificationViewModel.code
            
        } else {
            if phoneVerificationViewModel.showErrorVerificationCode {
                showingPopUp = true
            }
        }
    }
}

#Preview {
    FindIDFormView()
}
