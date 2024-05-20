

import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    @State var titleText: String?
    var onCommit: (() -> Void)?
    var isSecureText: Bool
    var isCustom: Bool

    let baseAttribute: BaseAttribute = BaseAttribute(font: .B1MediumFont(), color: Color("Gray07"))
    let stringAttribute: StringAttribute = StringAttribute(text: "*", font: .B1MediumFont(), color: Color("Mint03"))

    var body: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            if isCustom {
                titleText?.toAttributesText(base: baseAttribute, stringAttribute)
                    .padding(.horizontal, 20)
                    .font(.B1RegularFont())
                    .platformTextColor(color: Color("Gray04"))
            } else {
                Text(titleText!)
                    .padding(.horizontal, 20)
                    .font(.B1RegularFont())
                    .platformTextColor(color: Color("Gray04"))
            }

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    if isSecureText {
                        SecureField("", text: $inputText, onCommit: {
                            onCommit?()
                        })
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 12 * DynamicSizeFactor.factor())
                        .padding(.vertical, 16 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())

                    } else {
                        TextField("", text: $inputText, onCommit: {
                            onCommit?()
                        })
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 12 * DynamicSizeFactor.factor())
                        .padding(.vertical, 16 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
