

import SwiftUI

struct FindPwPhoneVerificationView: View {
    @ObservedObject var viewModel: PhoneVerificationViewModel
    @Binding var showManyRequestPopUp: Bool
    @State private var isFindUser = true

    var body: some View {
        VStack(alignment: .leading, spacing: 11 * DynamicSizeFactor.factor()) {
            VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
                Text("휴대폰 번호")
                    .padding(.horizontal, 20)
                    .font(.B1RegularFont())
                    .platformTextColor(color: Color("Gray04"))
                HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46 * DynamicSizeFactor.factor())
                        if viewModel.phoneNumber.isEmpty {
                            Text("01012345678")
                                .platformTextColor(color: Color("Gray03"))
                                .font(.H4MediumFont())
                                .padding(.leading, 13 * DynamicSizeFactor.factor())
                        }

                        TextField("", text: $viewModel.phoneNumber)
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                            .keyboardType(.numberPad)
                            .platformTextColor(color: Color("Gray07"))

                            .onChange(of: viewModel.phoneNumber) { newValue in
                                if Int(newValue) != nil {
                                    if newValue.count > 11 {
                                        viewModel.phoneNumber = String(newValue.prefix(11))
                                    }
                                } else {
                                    viewModel.phoneNumber = ""
                                }
                                viewModel.validateForm()
                            }
                    }
                    Button(action: {
                        if isFindUser {
                            viewModel.requestPwVerificationCodeApi { if viewModel.showErrorApiRequest {
                                showManyRequestPopUp = true
                            } else {
                                viewModel.judgeTimerRunning()
                            }
                            }
                        }
                    }, label: {
                        Text("인증번호 받기")
                            .font(.B1MediumFont()) // 폰트 리스트에 없는 예외
                            .platformTextColor(color: !viewModel.isDisabledButton && viewModel.phoneNumber.count >= 11 ? Color("White01") : Color("Gray04"))
                    })
                    .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                    .frame(height: 46 * DynamicSizeFactor.factor())
                    .background(!viewModel.isDisabledButton && viewModel.phoneNumber.count == 11 ? Color("Gray05") : Color("Gray03"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .disabled(viewModel.isDisabledButton)
                }
                .padding(.horizontal, 20)
            }
            if viewModel.showErrorPhoneNumberFormat {
                Text("010, 011으로 시작하는 11자리 문자열을 입력해주세요")
                    .padding(.horizontal, 20)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Red03"))
            }

            if viewModel.showErrorExistingUser {
                Text("이미 가입된 전화번호예요")
                    .padding(.horizontal, 20)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Red03"))
            }
        }
    }
}
