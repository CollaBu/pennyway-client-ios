import SwiftUI

struct SignUpFormView: View {
    @Binding var name: String
    @Binding var id: String
    @Binding var password: String
    @Binding var confirmPw: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text("회원가입")
                .font(.pretendard(.semibold, size: 24))
                .padding(.horizontal,20)
            
            Spacer().frame(height: 32)
            
            ScrollView() {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 21){
                        CustomInputView(inputText: $name, titleText: "이름")
                        CustomInputView(inputText: $id, titleText: "아이디")
                        CustomInputView(inputText: $password, titleText: "비밀번호")
                        CustomInputView(inputText: $confirmPw, titleText: "비밀번호 확인")
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpFormView(name: .constant("01097740978"), id: .constant("2weeksone"), password: .constant("* * * * * *"), confirmPw: .constant("* * * * * *"))
}
