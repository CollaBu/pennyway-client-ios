import os.log
import SwiftUI

struct FindIdFormView: View {
    @State private var showCodeErrorPopUp = false
    @State private var showManyRequestPopUp = false
    @State private var showNotFoundUserPopUp = false
    @State private var showDiffNumberPopUp = false
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @State private var isNavigateToFindIDView: Bool = false
    @StateObject var viewModel = SignUpNavigationViewModel()

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    FindIdContentView(phoneVerificationViewModel: phoneVerificationViewModel, showManyRequestPopUp: $showManyRequestPopUp)
                }

                Spacer()

                CustomBottomButton(action: {
                    if !phoneVerificationViewModel.requestedPhoneNumber.isEmpty, phoneVerificationViewModel.requestedPhoneNumber != phoneVerificationViewModel.phoneNumber {
                        showDiffNumberPopUp = true
                    } else {
                        continueButtonAction()
                    }
                }, label: "아이디 찾기", isFormValid: $phoneVerificationViewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())

                NavigationLink(destination: FindIdView(phoneVerificationViewModel: PhoneVerificationViewModel()), isActive: $isNavigateToFindIDView) {
                    EmptyView()
                }.hidden()
            }
            if showNotFoundUserPopUp == true {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showNotFoundUserPopUp, titleLabel: "사용자 정보를 찾을 수 없어요", subLabel: "다시 한번 확인해주세요")
            }

            if showManyRequestPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showManyRequestPopUp, titleLabel: "인증 요청 제한 횟수를 초과했어요", subLabel: "24시간 후에 다시 시도해주세요")
            }

            if showCodeErrorPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showCodeErrorPopUp, titleLabel: "잘못된 인증번호예요", subLabel: "다시 한번 확인해주세요")
            }

            if showDiffNumberPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showDiffNumberPopUp,
                                titleLabel: "인증 요청 번호와\n현재 입력된 번호가 달라요",
                                subTitleLabel: "기존 번호(\(phoneVerificationViewModel.requestedPhoneNumber))로 인증할까요?",
                                firstBtnAction: { self.showDiffNumberPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showDiffNumberPopUp = false
                                    phoneVerificationViewModel.phoneNumber = phoneVerificationViewModel.requestedPhoneNumber
                                    continueButtonAction()
                                },
                                secondBtnLabel: "인증할게요",
                                secondBtnColor: Color("Gray05"),
                                heightSize: 166)
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
            showCodeErrorPopUp = false
            showNotFoundUserPopUp = false
            isNavigateToFindIDView = true
            viewModel.continueButtonTapped()

            RegistrationManager.shared.phoneNumber = phoneVerificationViewModel.phoneNumber
            RegistrationManager.shared.code = phoneVerificationViewModel.code

        } else {
            Log.debug("else문 시작")

            if phoneVerificationViewModel.showErrorExistingUser {
                showNotFoundUserPopUp = true
                Log.debug("사용자 없음: \(showNotFoundUserPopUp)")

            } else if phoneVerificationViewModel.showErrorVerificationCode {
                showCodeErrorPopUp = true
                Log.debug("인증번호 오류: \(showCodeErrorPopUp)")
            }
        }
    }
}

#Preview {
    FindIdFormView()
}
