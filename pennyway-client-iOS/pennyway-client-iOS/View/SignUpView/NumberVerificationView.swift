import SwiftUI

struct NumberVerificationView: View {
    @State private var verificationCode: String = ""
    @Binding var showErrorVerificationCode: Bool
    @State var showErrorPhoneNumberFormat = false
    @State var phoneNumber: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("번호인증")
                .font(.pretendard(.semibold, size: 24))
                .padding(.horizontal,20)
            
            Spacer().frame(height: 32)
            
            phoneNumberInputSection()
       
            Spacer().frame(height: 21)
            
            VStack(alignment: .leading, spacing: 11){
                CustomInputView(inputText: $verificationCode, titleText: "인증 번호")
            }
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
                        TextField("'-' 제외 입력", text: $phoneNumber)
                            .padding(.leading, 13)
                            .font(.pretendard(.medium, size: 14))
                            .keyboardType(.numberPad)
                        
                            .onChange(of: phoneNumber) { newValue in
                                if Int(newValue) != nil {
                                    if newValue.count > 11 {
                                        phoneNumber = String(newValue.prefix(11))
                                    }
                                } else {
                                    phoneNumber = ""
                                }
                            }
                    }
                    Button(action: {
                 
                        if phoneNumber.prefix(3) != "010" && phoneNumber.prefix(3) != "011" {
                            showErrorPhoneNumberFormat = true
                        }
                        
                                 
                    }, label: {
                        Text("인증번호 받기")
                            .font(.pretendard(.medium, size: 13))
                            .platformTextColor(color: phoneNumber.count >= 11 ? Color("White") : Color("Gray04"))
                    })
                    .padding(.horizontal, 13)
                    .frame(height: 46)
                    .background(phoneNumber.count == 11 ? Color("Gray05"): Color("Gray03"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .padding(.horizontal, 20)
            }
            if showErrorPhoneNumberFormat {
                Text("존재하지 않는 전화번호예요")
                    .padding(.horizontal, 20)
                    .font(.pretendard(.medium, size: 12))
                    .platformTextColor(color: Color("Red03"))
            }
        }
    }
}

#Preview {
    NumberVerificationView(showErrorVerificationCode: .constant(false))
}
