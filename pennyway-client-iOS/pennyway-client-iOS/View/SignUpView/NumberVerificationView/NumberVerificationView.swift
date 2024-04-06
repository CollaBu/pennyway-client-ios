import SwiftUI

struct NumberVerificationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var showingPopUp = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var numberVerificationViewModel = NumberVerificationViewModel()
    
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
                    
                    NumberVerificationContentView(viewModel: numberVerificationViewModel)
                    
                    Spacer()
                    
                    CustomBottomButton(action: {
                        numberVerificationViewModel.validateNumberVerification()
                        
                        if OAuthRegistrationManager.shared.isOAuthRegistration {
                            numberVerificationViewModel.requestOAuthVerifyVerificationCodeAPI()
                        } else {
                            // numberVerificationViewModel.requestVerifyVerificationCodeAPI()
                        }
                       
                        if !numberVerificationViewModel.showErrorVerificationCode, numberVerificationViewModel.isFormValid {
                            showingPopUp = false
                            viewModel.continueButtonTapped()
                            
                            RegistrationManager.shared.phoneNumber = numberVerificationViewModel.phoneNumber
                            RegistrationManager.shared.verificationCode = numberVerificationViewModel.verificationCode

                        } else {
                            showingPopUp = true
                        }
                    }, label: "계속하기", isFormValid: $numberVerificationViewModel.isFormValid)
                        .padding(.bottom, 34)
                    
                    NavigationLink(destination: SignUpView(viewModel: viewModel), tag: 2, selection: $viewModel.selectedText) { // 수정
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
}

#Preview {
    NumberVerificationView()
}
