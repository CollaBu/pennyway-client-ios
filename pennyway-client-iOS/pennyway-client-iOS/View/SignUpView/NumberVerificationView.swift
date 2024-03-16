
import SwiftUI

struct NumberVerificationView: View {
    @Binding var phoneNumber: String
    @Binding var verificationCode: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("번호 인증")
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal,20)
            
            Spacer().frame(height: 32)
            
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
            
            Spacer().frame(height: 21)
            
            VStack(alignment: .leading, spacing: 13){
                Text("인증 번호")
                    .padding(.horizontal, 20)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color("Gray04"))
                
                HStack(spacing: 11){
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46)
                        
                        TextField("", text: $verificationCode)
                            .padding(.leading, 13)
                            .font(.system(size: 14, weight: .medium))
                    }
                }.padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    NumberVerificationView(phoneNumber: .constant("01012345678"), verificationCode: .constant("123456"))
}
