
import SwiftUI

struct PhoneNumberInputField: View {
    @Binding var phoneNumber: String
    let onPhoneNumberChange: (String) -> Void

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

            TextField("", text: $phoneNumber)
                .padding(.leading, 13 * DynamicSizeFactor.factor())
                .font(.H4MediumFont())
                .keyboardType(.numberPad)
                .platformTextColor(color: Color("Gray07"))
                .onChange(of: phoneNumber, perform: onPhoneNumberChange)
        }
    }
}
