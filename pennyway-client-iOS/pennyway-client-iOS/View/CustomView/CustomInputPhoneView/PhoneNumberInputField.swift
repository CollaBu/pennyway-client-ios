
import SwiftUI

struct PhoneNumberInputField: View {
    @Binding var phoneNumber: String
    let onPhoneNumberChange: (String) -> Void
    var onCommit: (() -> Void)?
    var showDeleteButton: Bool = false
    var deleteAction: (() -> Void)?

    @State private var isDeleteButtonVisible: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color("Gray01"))
                .frame(height: 46 * DynamicSizeFactor.factor())

            if phoneNumber.isEmpty {
                Text("01012345678")
                    .platformTextColor(color: Color("Gray03"))
                    .padding(.leading, 13 * DynamicSizeFactor.factor())
                    .font(.H4MediumFont())
            }

            TextField("", text: $phoneNumber, onCommit: {
                onCommit?()
                isDeleteButtonVisible.toggle()
            })
            .padding(.leading, 13 * DynamicSizeFactor.factor())
            .font(.H4MediumFont())
            .keyboardType(.numberPad)
            .platformTextColor(color: Color("Gray07"))
            .onChange(of: phoneNumber, perform: onPhoneNumberChange)

            if showDeleteButton {
                handleDeleteButtonUtil(isVisible: !phoneNumber.isEmpty && isDeleteButtonVisible, action: {
                    phoneNumber = ""
                    isDeleteButtonVisible = false
                    deleteAction?()
                })
                .offset(x: 10 * DynamicSizeFactor.factor(), y: 1 * DynamicSizeFactor.factor())
                .zIndex(1)
            }
        }
    }
}
