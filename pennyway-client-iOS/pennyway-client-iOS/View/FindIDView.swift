import SwiftUI

struct FindIDView: View {
    @StateObject var numberVerificationViewModel = NumberVerificationViewModel()
    @State private var showingPopUp = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    
    var body: some View {
        NavigationAvailable {
            ZStack {
                VStack {
                    Spacer().frame(height: 36)
                    
                    PhoneNumberInputSectionView(viewModel: NumberVerificationViewModel())
                    
                    Spacer().frame(height: 21)
                    
                    NumberInputSectionView(viewModel: NumberVerificationViewModel())
                    
                    Spacer().frame(height: 203)
                    Spacer()
                    
                    VStack {
                        CustomBottomButton(action: {
                            numberVerificationViewModel.validateNumberVerification()
                            // numberVerificationViewModel.requestVerifyVerificationCodeAPI()
                            if !numberVerificationViewModel.showErrorVerificationCode, numberVerificationViewModel.isFormValid {
                                showingPopUp = false
                                viewModel.continueButtonTapped()
                                
                                RegistrationManager.shared.phoneNumber = numberVerificationViewModel.phoneNumber
                                RegistrationManager.shared.verificationCode = numberVerificationViewModel.verificationCode
                                
                            } else {
                                showingPopUp = true
                            }
                        }, label: "아이디 찾기", isFormValid: $numberVerificationViewModel.isFormValid)
                    }
                    .padding(.bottom, 34)
                }
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

#Preview {
    FindIDView()
}
