

import SwiftUI

struct EditIdView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var editIdViewModel = EditIdViewModel()

    var body: some View {
        VStack {
            Spacer().frame(height: 35 * DynamicSizeFactor.factor())

            CustomInputView(inputText: $editIdViewModel.inputId, titleText: "아이디", placeholder: "", isSecureText: false, isCustom: false)

            Spacer()

            CustomBottomButton(action: {}, label: "변경 완료", isFormValid: .constant(true))
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
}

#Preview {
    EditIdView()
}
