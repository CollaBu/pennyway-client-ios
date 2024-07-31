import os.log
import SwiftUI

struct FindIdFormView: View {
    @State private var showingCodeErrorPopUp = false
    @State private var showingApiRequestPopUp = false
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @State private var isNavigateToFindIDView: Bool = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    @StateObject var findUserNameViewModel = FindUserNameViewModel()

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    FindIdContentView(phoneVerificationViewModel: phoneVerificationViewModel, showingApiRequestPopUp: $showingApiRequestPopUp)
                }

                Spacer()

                CustomBottomButton(action: {
                    continueButtonAction()
                }, label: "아이디 찾기", isFormValid: $phoneVerificationViewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())

                NavigationLink(destination: FindIdView(phoneVerificationViewModel: PhoneVerificationViewModel()), isActive: $isNavigateToFindIDView) {
                    EmptyView()
                }.hidden()
            }
            if showingCodeErrorPopUp == true {
                Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showingCodeErrorPopUp, titleLabel: "사용자 정보를 찾을 수 없어요", subLabel: "다시 한번 확인해주세요")
            }

            if showingApiRequestPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showingApiRequestPopUp, titleLabel: "인증 요청 제한 횟수를 초과했어요", subLabel: "24시간 후에 다시 시도해주세요")
            }
        }
        .edgesIgnoringSafeArea(.bottom)
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

    private func continueButtonAction() {
        phoneVerificationViewModel.requestUserNameVerifyVerificationCodeApi {
            checkFormValid()
        }
    }

    private func checkFormValid() {
        if !phoneVerificationViewModel.showErrorVerificationCode && !phoneVerificationViewModel.showErrorExistingUser &&
            phoneVerificationViewModel.isFormValid
        {
            Log.debug("if문 시작")
            showingCodeErrorPopUp = false
            isNavigateToFindIDView = true
            viewModel.continueButtonTapped()

            RegistrationManager.shared.phoneNumber = phoneVerificationViewModel.phoneNumber
            RegistrationManager.shared.code = phoneVerificationViewModel.code

        } else {
            Log.debug("else문 시작")
            if phoneVerificationViewModel.showErrorVerificationCode {
                showingCodeErrorPopUp = true
            }
        }
    }
}

#Preview {
    FindIdFormView()
}
