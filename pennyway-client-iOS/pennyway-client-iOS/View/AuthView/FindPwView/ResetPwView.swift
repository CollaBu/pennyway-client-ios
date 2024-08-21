import SwiftUI

struct ResetPwView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var formViewModel = SignUpFormViewModel()
    @State private var navigateView = false
    @StateObject var resetPwViewModel = ResetPwViewModel()
    @StateObject var accountViewModel = UserAccountViewModel()
    @Binding var firstNaviLinkActive: Bool
    let entryPoint: PasswordChangeTypeNavigation
    
    var body: some View {
        ZStack {
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
                    
                    ResetPwFormView(formViewModel: formViewModel, accountViewModel: accountViewModel)
                }
                Spacer()
                
                CustomBottomButton(action: {
                    continueButtonAction()
                    formViewModel.validatePwForm()
                    
                }, label: "변경하기", isFormValid: $formViewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                
                NavigationLink(destination: CompleteChangePwView(firstNaviLinkActive: $firstNaviLinkActive), isActive: $navigateView) {
                    EmptyView()
                }.hidden()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        NavigationUtil.popToRootView()
                        firstNaviLinkActive = false
                        
                        if entryPoint == .modifyPw {
                            self.presentationMode.wrappedValue.dismiss()
                        }
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
        .onAppear {
            if entryPoint == .findPw {
                AnalyticsManager.shared.trackEvent(AuthCheckEvents.findPasswordView, additionalParams: nil)
            }
            if entryPoint == .modifyPw {
                AnalyticsManager.shared.trackEvent(ProfileEvents.passwordEditView, additionalParams: nil)
            }
        }
    }
    
    private func continueButtonAction() {
        if formViewModel.isFormValid {
            formViewModel.validatePwForm()
            resetPwViewModel.newPassword = formViewModel.password

            if entryPoint == .modifyPw { // 프로필 비밀번호 변경 시
                accountViewModel.resetMyPwApi { success in
                    if success {
                        Log.debug("사용자 비밀번호 변경 성공")
                        navigateView = true

                    } else {
                        Log.debug("사용자 비밀번호 변경 실패")
                    }
                }
            } else { // 비밀번호 찾기에서 진입했을 시
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
            }
            
            RegistrationManager.shared.password = formViewModel.password
            
        } else {
            Log.fault("유효하지 않은 형식")
        }
    }
}

#Preview {
    ResetPwView(firstNaviLinkActive: .constant(true), entryPoint: .modifyPw)
}
