import SwiftUI

struct ResetPwView: View {
    @StateObject var formViewModel = SignUpFormViewModel()
    @State private var navigateView = false
    @StateObject var resetPwViewModel = ResetPwViewModel()
    
    var body: some View {
        NavigationAvailable {
            VStack(spacing: 0) {
                ScrollView {
                    HStack(alignment: .top) {
                        Text("새로운 비밀번호를\n설정해주세요")
                            .font(.pretendard(.semibold, size: 24))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 15 * DynamicSizeFactor.factor())
                        
                        Spacer()
                    }
                    .padding(.leading, 20 * DynamicSizeFactor.factor())
                    
                    Spacer().frame(height: 33 * DynamicSizeFactor.factor())
                    
                    ResetPwFormView(formViewModel: formViewModel)
                }
                Spacer()
                
                CustomBottomButton(action: {
                    continueButtonAction()
                    
                }, label: "변경하기", isFormValid: $formViewModel.isFormValid)
                    .padding(.bottom, 34)
                
                NavigationLink(destination: CompleteChangePwView(), isActive: $navigateView) {
                    EmptyView()
                }.hidden()
            }
            
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
    }
    
    private func continueButtonAction() {
        if formViewModel.isFormValid {
            resetPwViewModel.newPassword = formViewModel.password
            resetPwViewModel.requestResetPwApi { success in
                DispatchQueue.main.async {
                    if success {
                        Log.debug("RequestResetPwApi 실행")
                        navigateView = true
                    } else {
                        Log.fault("fail ResetPw")
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
