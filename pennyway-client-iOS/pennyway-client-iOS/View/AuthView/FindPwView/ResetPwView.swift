import SwiftUI

struct ResetPwView: View {
    @StateObject var formViewModel = SignUpFormViewModel()
    @State private var navigateView = false
    @StateObject var resetPwViewModel = ResetPwViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                HStack(alignment: .top) {
                    Text("새로운 비밀번호를\n설정해주세요")
                        .font(.H1SemiboldFont())
                        .multilineTextAlignment(.leading)
                        .padding(.top, 15 * DynamicSizeFactor.factor())                        
                    Spacer()
                }
                .padding(.leading, 20)
                    
                Spacer().frame(height: 33 * DynamicSizeFactor.factor())
                    
                ResetPwFormView(formViewModel: formViewModel)
            }
            Spacer()
                
            CustomBottomButton(action: {
                continueButtonAction()
                formViewModel.validatePwForm()
                    
            }, label: "변경하기", isFormValid: $formViewModel.isFormValid)
                .padding(.bottom, 34)
                
            NavigationLink(destination: CompleteChangePwView(), isActive: $navigateView) {
                EmptyView()
            }.hidden()
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxHeight: .infinity)
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
    
    private func continueButtonAction() {
        if formViewModel.isFormValid {
            formViewModel.validatePwForm()
            resetPwViewModel.newPassword = formViewModel.password
            resetPwViewModel.requestResetPwApi { success in
                DispatchQueue.main.async {
                    if success {
                        Log.debug("비밀번호 재설정 성공")
                        navigateView = true
                    } else {
                        Log.fault("비밀번호 재설정 실패")
                    }
                }
            }
            
            RegistrationManager.shared.password = formViewModel.password
            
        } else {
            Log.fault("유효하지 않은 형식")
        }
    }
}

#Preview {
    ResetPwView()
}
