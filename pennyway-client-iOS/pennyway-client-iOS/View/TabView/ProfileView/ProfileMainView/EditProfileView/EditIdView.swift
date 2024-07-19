

import SwiftUI

struct EditIdView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var editIdViewModel = EditIdViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 35 * DynamicSizeFactor.factor())
            
            CustomInputView(inputText: $editIdViewModel.inputId, titleText: "아이디", placeholder: "", onCommit: {
                editIdViewModel.validateId()
            }, isSecureText: false, isCustom: false)
            
            if editIdViewModel.showErrorId {
                ErrorText(message: "영문 소문자, 특수기호 (-), (_), (.) 만 사용하여,\n5~20자의 아이디를 입력해 주세요", color: Color("Red03"))
            }
            
            if editIdViewModel.isDuplicateId {
                ErrorText(message: "이미 사용 중인 아이디예요", color: Color("Red03"))
            }
            
            if editIdViewModel.isFormValid {
                ErrorText(message: "사용 가능한 아이디예요", color: Color("Mint03"))
            }
            
            Spacer()
            
            CustomBottomButton(action: {
                if editIdViewModel.isFormValid {
                    self.presentationMode.wrappedValue.dismiss()
                }

            }, label: "변경 완료", isFormValid: $editIdViewModel.isFormValid)
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
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

//    /// Error messiage
//    private func errorMessage(_ message: String, _ color: Color) -> some View {
//        Text(message)
//            .padding(.leading, 20)
//            .font(.B1MediumFont())
//            .platformTextColor(color: color)
//    }
}

#Preview {
    EditIdView()
}
