import SwiftUI

struct FindPwView: View {
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @State private var showingPopUp = false
    @State private var navigateToFindPwView = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    
    var body: some View {
        NavigationAvailable {
            ZStack {
                ScrollView {
                    VStack {
                        Spacer().frame(height: 36)
                        
                        PhoneNumberInputSectionView(viewModel: phoneVerificationViewModel) //
                        
                        Spacer().frame(height: 21)
                        
                        NumberInputSectionView(viewModel: phoneVerificationViewModel)
                    }
                }
                Spacer().frame(height: 203)

                Spacer()
                
                VStack {
                    Spacer()
                    CustomBottomButton(action: {
                        // phoneVerificationViewModel.validateNumberVerification()
                        ResetPwView(formViewModel: SignUpFormViewModel())
                        // numberVerificationViewModel.requestVerifyVerificationCodeAPI()
                        if !phoneVerificationViewModel.showErrorVerificationCode, phoneVerificationViewModel.isFormValid {
                            showingPopUp = false
                            viewModel.continueButtonTapped()
                            
                            RegistrationManager.shared.phoneNumber = phoneVerificationViewModel.phoneNumber
                            RegistrationManager.shared.code = phoneVerificationViewModel.code
                            
                            navigateToFindPwView = true
                            
                        } else {
                            showingPopUp = true
                        }
                    }, label: "확인", isFormValid: $phoneVerificationViewModel.isFormValid)
                }
                .padding(.bottom, 34)
                
                NavigationLink(destination: ResetPwView(formViewModel: SignUpFormViewModel()), isActive: $navigateToFindPwView) {
                    EmptyView()
                }.hidden()
            }
        }
        .navigationTitle(Text("비밀번호 찾기"))
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
    FindPwView()
}
