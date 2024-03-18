
import SwiftUI

struct NumberVerificationView: View {
    @Binding var phoneNumber: String
    @Binding var verificationCode: String
    @State var showErrorPhoneNumber = false
    @State var showErrorVerificationCode = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("번호 인증")
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal,20)
            
            Spacer().frame(height: 32)
            
            VStack(alignment: .leading, spacing: 11){
                VStack(alignment: .leading, spacing: 13){
                    Text("휴대폰 번호")
                        .padding(.horizontal, 20)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color("Gray04"))
                    HStack(spacing: 11){
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("Gray01"))
                                .frame(height: 46)
                            
                            TextField("'-' 제외 입력", text: $phoneNumber)
                                .padding(.leading, 13)
                                .font(.system(size: 14, weight: .medium))
                        }
                        
                        
                        Button(action: {
                            showErrorPhoneNumber.toggle()
                            showErrorVerificationCode.toggle()
                        }) {
                            Text("인증번호 받기")
                                .foregroundColor(Color("Gray04"))
                                .font(.system(size: 13, weight: .medium))
                        }
                        .padding(.horizontal, 13)
                        .frame(height: 46)
                        .background(Color("Gray03"))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }.padding(.horizontal, 20)
                }
                if showErrorPhoneNumber{
                    if #available(iOS 15.0, *) {
                        Text("존재하지 않는 전화번호예요")
                            .padding(.horizontal, 20)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color("Red03"))
                        
                    } else {
                        Text("존재하지 않는 전화번호예요")
                            .padding(.horizontal, 20)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("Red03"))
                    }
                }
            }
            
            
            Spacer().frame(height: 21)
            
            VStack(alignment: .leading, spacing: 11){
                CustomInputView(inputText: $verificationCode, titleText: "인증 번호")
                if showErrorVerificationCode{
                    if #available(iOS 15.0, *) {
                        Text("잘못된 인증번호예요")
                            .padding(.horizontal, 20)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color("Red03"))
                        
                    } else {
                        Text("잘못된 인증번호예요")
                            .padding(.horizontal, 20)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("Red03"))
                    }
                }
            }
        }
    }
}

#Preview {
    NumberVerificationView(phoneNumber: .constant("01012345678"), verificationCode: .constant("123456"))
}
