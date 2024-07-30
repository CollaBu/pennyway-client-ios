import SwiftUI

struct FindPwView: View {
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @State private var showingCodeErrorPopUp = false
    @State private var showingApiRequestPopUp = false
    @State private var isNavigateToFindPwView: Bool = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    @State private var isVerificationError: Bool = false

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        FindPwContentView(phoneVerificationViewModel: phoneVerificationViewModel, showingApiRequestPopUp: $showingApiRequestPopUp)
                    }
                }
                Spacer()
                
                CustomBottomButton(action: {
                    continueButtonAction()
                }, label: "확인", isFormValid: $phoneVerificationViewModel.isFormValid)
                
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                
                NavigationLink(destination: ResetPwView(formViewModel: SignUpFormViewModel(), firstNaviLinkActive: .constant(true), entryPoint: .findPw), isActive: $isNavigateToFindPwView) {
                    EmptyView()
                }.hidden()
            }
            if showingCodeErrorPopUp == true {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showingCodeErrorPopUp, titleLabel: "사용자 정보를 찾을 수 없어요", subLabel: "다시 한번 확인해주세요")
            }
            if showingApiRequestPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showingApiRequestPopUp, titleLabel: "인증 요청 제한 횟수를 초과했어요", subLabel: "24시간 후에 다시 시도해주세요")
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(Text("비밀번호 찾기"))
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
        phoneVerificationViewModel.requestPwVerifyVerificationCodeApi {
            checkFormValid()
            Log.debug("requestPwVerifyVerificationCodeApi 실행")
        }
    }
    
    private func checkFormValid() {
        if !phoneVerificationViewModel.showErrorVerificationCode && !phoneVerificationViewModel.showErrorExistingUser && phoneVerificationViewModel.isFormValid {
            Log.debug("비밀번호 찾기 checkFormValid if문 시작")
            showingCodeErrorPopUp = false
            isNavigateToFindPwView = true
            viewModel.continueButtonTapped()

            RegistrationManager.shared.code = phoneVerificationViewModel.code
            
        } else {
            Log.debug("비밀번호 찾기 checkFormValid else문 시작")
            if phoneVerificationViewModel.showErrorVerificationCode {
                showingCodeErrorPopUp = true
                isVerificationError = true
            }
        }
    }
}

#Preview {
    FindPwView()
}
