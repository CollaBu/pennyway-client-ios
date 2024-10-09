
import SwiftUI

struct EditPhoneNumberView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = PhoneVerificationViewModel()
    @State private var showCodeErrorPopUp = false // 인증번호 오류
    @State private var showManyRequestPopUp = false // api 요청 오류
    @State private var showDiffNumberPopUp = false
    @State private var showErrorExistingUser = false
    @State private var isDeleteButtonVisible: Bool = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Spacer().frame(height: 35 * DynamicSizeFactor.factor())

                VStack(alignment: .leading, spacing: 11 * DynamicSizeFactor.factor()) {
                    phoneNumberSection
                    if viewModel.showErrorPhoneNumberFormat {
                        ErrorText(message: "올바른 전화번호 형식이 아니에요", color: Color("Red03"))
                    }
                    if showErrorExistingUser {
                        ErrorText(message: "이미 가입된 전화번호예요", color: Color("Red03"))
                    }
                }

                Spacer().frame(height: 21 * DynamicSizeFactor.factor())

                CodeInputSectionView(viewModel: viewModel)

                Spacer()

                CustomBottomButton(action: {
                    if !viewModel.requestedPhoneNumber.isEmpty, viewModel.requestedPhoneNumber != viewModel.phoneNumber,
                       !viewModel.showErrorExistingUser
                    {
                        showDiffNumberPopUp = true
                    } else {
                        continueButtonAction()
                    }

                }, label: "변경 완료", isFormValid: $viewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarColor(UIColor(named: "White01"), title: "휴대폰 번호 변경")
            .background(Color("White01"))
            .edgesIgnoringSafeArea(.bottom)
            .setTabBarVisibility(isHidden: true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        NavigationBackButton()
                            .padding(.leading, 5)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())

                    }.offset(x: -10)
                }
            }

            if showCodeErrorPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showCodeErrorPopUp, titleLabel: "잘못된 인증번호예요", subLabel: "다시 한번 확인해주세요")
            }
            if showManyRequestPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showManyRequestPopUp, titleLabel: "인증 요청 제한 횟수를 초과했어요", subLabel: "24시간 후에 다시 시도해주세요")
            }

            if showDiffNumberPopUp {
                CustomPopUpView(showingPopUp: $showDiffNumberPopUp,
                                titleLabel: "인증 요청 번호와\n현재 입력된 번호가 달라요",
                                subTitleLabel: "기존 번호(\(viewModel.requestedPhoneNumber))로 인증할까요?",
                                firstBtnAction: { self.showDiffNumberPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showDiffNumberPopUp = false
                                    viewModel.phoneNumber = viewModel.requestedPhoneNumber
                                    continueButtonAction()
                                },
                                secondBtnLabel: "인증할게요",
                                secondBtnColor: Color("Gray05"),
                                heightSize: 166)
            }
        }
        .onChange(of: viewModel.showErrorExistingUser) { newValue in
            showErrorExistingUser = newValue
        }
    }

    @ViewBuilder
    private var phoneNumberSection: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("휴대폰 번호")
                .padding(.horizontal, 20)
                .font(.B1RegularFont())
                .platformTextColor(color: Color("Gray04"))

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                PhoneNumberInputField(phoneNumber: $viewModel.phoneNumber, onPhoneNumberChange: handlePhoneNumberChange, onCommit: {
                    isDeleteButtonVisible = false
                }, showDeleteButton: true, deleteAction: {
                    viewModel.phoneNumber = ""
                    viewModel.showErrorExistingUser = false
                    viewModel.showErrorPhoneNumberFormat = false
                })
                VerificationButton(isEnabled: isVerificationButtonEnabled(), action: handleVerificationButtonTap)
            }
            .padding(.horizontal, 20)
        }
        .analyzeEvent(ProfileEvents.phoneEditView)
    }

    private func handlePhoneNumberChange(_ newValue: String) {
        if Int(newValue) != nil {
            if newValue.count > 11 {
                viewModel.phoneNumber = String(newValue.prefix(11))
            }

            if viewModel.showErrorExistingUser {
                if viewModel.phoneNumber != viewModel.requestedPhoneNumber {
                    showErrorExistingUser = false
                } else {
                    showErrorExistingUser = true
                }
            }
        } else {
            viewModel.phoneNumber = ""
        }
        viewModel.validateForm()
    }

    private func handleVerificationButtonTap() {
        viewModel.requestEditVerificationCodeApi { 
            if viewModel.showErrorManyRequest {
                showManyRequestPopUp = true
            } else {
                viewModel.judgeTimerRunning()
            }
        }
    }

    private func checkFormValid(completion: @escaping (Bool) -> Void) {
        if !viewModel.showErrorVerificationCode && !viewModel.showErrorExistingUser &&
            !viewModel.showErrorManyRequest && viewModel.isFormValid
        {
            showCodeErrorPopUp = false
            completion(true)
        } else {
            if viewModel.showErrorVerificationCode {
                showCodeErrorPopUp = true
                completion(false)
            }
        }
    }

    private func isVerificationButtonEnabled() -> Bool {
        return !viewModel.isDisabledButton && viewModel.phoneNumber.count == 11 && viewModel.phoneNumber != viewModel.requestedPhoneNumber
    }

    private func continueButtonAction() {
        viewModel.editUserPhoneNumberApi {
            checkFormValid { success in
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    EditPhoneNumberView()
}
