import SwiftUI

struct FindIDFormView: View {
    @State private var showingPopUp = false
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
                        //                    CustomBottomButton(action: {
                        ////                        numberVerificationViewModel.validateNumberVerification()
                        //                        FindIDView(findUserNameViewModel: FindUserNameViewModel())
                        //                        // numberVerificationViewModel.requestVerifyVerificationCodeApi()
                        //                        if !numberVerificationViewModel.showErrorVerificationCode, numberVerificationViewModel.isFormValid {
                        //                            showingPopUp = false
                        //                            viewModel.continueButtonTapped()
                        //
                        //                            RegistrationManager.shared.phoneNumber = numberVerificationViewModel.phoneNumber
                        //                            RegistrationManager.shared.code = numberVerificationViewModel.code
                        //
                        //                            navigateToFindIDView = true
                        //
                        //                        } else {
                        //                            showingPopUp = true
                        //                        }
                        //                    }, label: "아이디 찾기", isFormValid: $numberVerificationViewModel.isFormValid)
                        //                }
                        .padding(.bottom, 34)
                    
                    NavigationLink(destination: FindIDView(findUserNameViewModel: FindUserNameViewModel()), isActive: $navigateToFindIDView) {
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
        findUserNameViewModel.findUserNameApi {
            checkFormValid()
        }
    }
    
    private func checkFormValid() {
        if !phoneVerificationViewModel.showErrorVerificationCode && !phoneVerificationViewModel.showErrorExistingUser && phoneVerificationViewModel.isFormValid {
            showingPopUp = false
            viewModel.continueButtonTapped()
            
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
