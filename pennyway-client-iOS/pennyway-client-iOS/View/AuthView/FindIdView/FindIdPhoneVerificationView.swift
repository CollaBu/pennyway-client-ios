

import SwiftUI

struct FindIdPhoneVerificationView: View {
    @ObservedObject var viewModel: PhoneVerificationViewModel
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
                                .padding(.leading, 13 * DynamicSizeFactor.factor())
                                .font(.H4MediumFont())
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
                            Log.debug("아이디 찾기 api 요청")
                            viewModel.requestUserNameVerificationCodeApi { viewModel.judgeTimerRunning() }
                        }
                    }, label: {
                        Text("인증번호 받기")
                            .font(.pretendard(.medium, size: 13)) // DynamicFontSize에 없음
                            .platformTextColor(color: !viewModel.isDisabledButton && viewModel.phoneNumber.count >= 11 ? Color("White01") : Color("Gray04"))
                    })
                    .padding(.horizontal, 13)
                    .frame(height: 46 * DynamicSizeFactor.factor())
                    .background(!viewModel.isDisabledButton && viewModel.phoneNumber.count == 11 ? Color("Gray05") : Color("Gray03"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .disabled(viewModel.isDisabledButton)
                }
                .padding(.horizontal, 20)
            }
            if viewModel.showErrorPhoneNumberFormat {
                Text("올바른 전화번호 형식이 아니에요")
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

#Preview {
    FindIdPhoneVerificationView(viewModel: PhoneVerificationViewModel())
}
