

import SwiftUI

struct EditIdView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var editIdViewModel = EditViewModel()
    @State private var isDeleteButtonVisible: Bool = false

    private let maxLength = 20

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 35 * DynamicSizeFactor.factor())

            CustomInputView(inputText: $editIdViewModel.inputId, titleText: "아이디", placeholder: "", onCommit: {
                editIdViewModel.validateId()
                isDeleteButtonVisible = false
            }, isSecureText: false, isCustom: false, showDeleteButton: true, deleteAction: {
                editIdViewModel.inputId = ""
                editIdViewModel.showErrorId = false
                editIdViewModel.isDuplicateId = false
                editIdViewModel.isFormValid = false
                isDeleteButtonVisible = false
            })
            .onChange(of: editIdViewModel.inputId) { newValue in
                if newValue.count > maxLength {
                    editIdViewModel.inputId = String(newValue.prefix(maxLength))
                }
                isDeleteButtonVisible = !newValue.isEmpty
            }

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
                    editIdViewModel.editUserIdApi { success in
                        if success {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
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
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
        .analyzeEvent(ProfileEvents.usernameEditView)
    }
}

#Preview {
    EditIdView()
}
