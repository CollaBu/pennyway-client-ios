
import SwiftUI

struct EditPhoneNumberView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = EditPhoneNumberViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 32 * DynamicSizeFactor.factor())

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
//                            viewModel.validateForm()
                        }
                }

                Button(action: {
//                        viewModel.requestVerificationCodeApi { viewModel.judgeTimerRunning() }
                }, label: {
                    Text("인증번호 받기")
                        .font(.B1MediumFont())
                        .platformTextColor(color: !viewModel.isDisabledButton && viewModel.phoneNumber.count >= 11 ? Color("White01") : Color("Gray04"))
                })
                .padding(.horizontal, 13)
                .frame(height: 46 * DynamicSizeFactor.factor())
                .background(!viewModel.isDisabledButton && viewModel.phoneNumber.count == 11 ? Color("Gray05") : Color("Gray03"))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .disabled(viewModel.isDisabledButton)
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 21 * DynamicSizeFactor.factor())

//            NumberInputSectionView(viewModel: phoneVerificationViewModel)
        }

        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .navigationBarColor(UIColor(named: "White01"), title: "아이디 변경")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White01"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
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

#Preview {
    EditPhoneNumberView()
}
