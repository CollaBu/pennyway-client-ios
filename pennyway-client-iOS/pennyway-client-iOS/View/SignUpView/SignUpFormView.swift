import SwiftUI

struct SignUpFormView: View {
    @Binding var name: String
    @Binding var id: String
    @Binding var password: String
    @Binding var confirmPw: String
    @State var showErrorName = false
    
    
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
                        if showErrorName{
                            Text("입력 포멧 관련 문구")
                            .padding(.horizontal, 20)
                            .font(.pretendard(.medium, size: 12))
                            .platformTextColor(color: Color("Red03"))
                        }
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
