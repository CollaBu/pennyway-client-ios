import SwiftUI

struct FindIDFormView: View {
    @State private var showingPopUp = false
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @State private var isNavigateToFindIDView: Bool = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var findUserNameViewModel = FindUserNameViewModel()
    @State private var isVerificationError: Bool = false
    
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
                        
                    }, label: "아이디 찾기", isFormValid: $phoneVerificationViewModel.isFormValid)
                        .padding(.bottom, 34)
                    
                    NavigationLink(destination: FindIDView(phoneVerificationViewModel: PhoneVerificationViewModel()), isActive: $isNavigateToFindIDView) {
                        EmptyView()
                    }.hidden()
                }
                if showingPopUp == true {
                    Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                    ErrorCodePopUpView(showingPopUp: $showingPopUp, isVerificationError: isVerificationError)
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
        phoneVerificationViewModel.requestUserNameVerifyVerificationCodeApi {
            checkFormValid()
        }
    }
    
    private func checkFormValid() {
        if !phoneVerificationViewModel.showErrorVerificationCode && !phoneVerificationViewModel.showErrorExistingUser && phoneVerificationViewModel.isFormValid {
            showingPopUp = false
            isNavigateToFindIDView = true
            viewModel.continueButtonTapped()

            RegistrationManager.shared.phoneNumber = phoneVerificationViewModel.phoneNumber
            RegistrationManager.shared.code = phoneVerificationViewModel.code
            
        } else {
            if phoneVerificationViewModel.showErrorVerificationCode {
                showingPopUp = true
                isVerificationError = true
            }
        }
    }
}

#Preview {
    FindIDFormView()
}
