
import SwiftUI

struct NumberVerificationContentView: View {
    
    @ObservedObject var viewModel: NumberVerificationViewModel

    var timerString: String {
        let minutes = viewModel.timerSeconds / 60
        let seconds = viewModel.timerSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("번호인증")
                .font(.pretendard(.semibold, size: 24))
                .padding(.horizontal,20)
            
            Spacer().frame(height: 32)
            
            phoneNumberInputSection()
       
            Spacer().frame(height: 21)
            
            numberInputSection()

        }
    }
    
    private func phoneNumberInputSection() -> some View {
        VStack(alignment: .leading, spacing: 11){
            VStack(alignment: .leading, spacing: 13){
                Text("휴대폰 번호")
                    .padding(.horizontal, 20)
                    .font(.pretendard(.regular, size: 12))
                    .platformTextColor(color: Color("Gray04"))
                HStack(spacing: 11){
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46)
                        TextField("'-' 제외 입력", text: $viewModel.phoneNumber)
                            .padding(.leading, 13)
                            .font(.pretendard(.medium, size: 14))
                            .keyboardType(.numberPad)
                        
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
                        viewModel.validatePhoneNumber()
                        viewModel.generateRandomVerificationCode()
                        viewModel.judgeTimerRunning()
                        
                    }, label: {
                        Text("인증번호 받기")
                            .font(.pretendard(.medium, size: 13))
                            .platformTextColor(color: !viewModel.isDisabledButton && viewModel.phoneNumber.count >= 11 ? Color("White01") : Color("Gray04"))
                    })
                    .padding(.horizontal, 13)
                    .frame(height: 46)
                    .background(!viewModel.isDisabledButton && viewModel.phoneNumber.count == 11 ? Color("Gray05"): Color("Gray03"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .disabled(viewModel.isDisabledButton)
                }
                .padding(.horizontal, 20)
            }
            if viewModel.showErrorPhoneNumberFormat {
                Text("존재하지 않는 전화번호예요")
                    .padding(.horizontal, 20)
                    .font(.pretendard(.medium, size: 12))
                    .platformTextColor(color: Color("Red03"))
            }
        }
    }
    
    private func numberInputSection() -> some View {
        VStack(alignment: .leading, spacing: 13){
            Text("인증 번호")
                .padding(.horizontal, 20)
                .font(.pretendard(.regular, size: 12))
                .platformTextColor(color: Color("Gray04"))
            
            HStack(spacing: 11){
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46)
                    HStack {
                        TextField("", text: $viewModel.verificationCode)
                            .padding(.leading, 13)
                            .font(.pretendard(.medium, size: 14))
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.verificationCode) { newValue in
                                if Int(newValue) != nil {
                                    viewModel.verificationCode = String(newValue)
                                }else{
                                    viewModel.verificationCode = ""
                                }
                                viewModel.validateForm()
                            }
                        Spacer()
                        Text(timerString)
                            .padding(.trailing, 13)
                            .font(.pretendard(.regular, size: 12))
                            .platformTextColor(color: Color("Mint03"))
                        
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    NumberVerificationContentView(viewModel: NumberVerificationViewModel())
}
