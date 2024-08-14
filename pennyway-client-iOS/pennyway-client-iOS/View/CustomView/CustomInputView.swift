import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    @State var titleText: String?
    @State var placeholder: String?
    var onCommit: (() -> Void)?
    var isSecureText: Bool
    var isCustom: Bool?
    var showDeleteButton: Bool = false
    var deleteAction: (() -> Void)?

    let baseAttribute: BaseAttribute = BaseAttribute(font: .B1MediumFont(), color: Color("Gray07"))
    let stringAttribute: StringAttribute = StringAttribute(text: "*", font: .B1MediumFont(), color: Color("Mint03"))

    @State private var isDeleteButtonVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            if titleText != nil {
                if isCustom ?? false {
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
            }

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    if inputText.isEmpty {
                        Text(placeholder ?? "")
                            .platformTextColor(color: Color("Gray03"))
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                    }
                    if isSecureText {
                        SecureField("", text: $inputText, onCommit: {
                            onCommit?()
                            isDeleteButtonVisible.toggle()
                        })
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 12 * DynamicSizeFactor.factor())
                        .padding(.vertical, 16 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                        .onChange(of: inputText) { newValue in
                            isDeleteButtonVisible = !newValue.isEmpty
                        }

                    } else {
                        TextField("", text: $inputText, onCommit: {
                            onCommit?()
                            isDeleteButtonVisible.toggle()
                        })
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 12 * DynamicSizeFactor.factor())
                        .padding(.trailing, 35 * DynamicSizeFactor.factor())
                        .padding(.vertical, 16 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                        .onChange(of: inputText) { newValue in
                            isDeleteButtonVisible = !newValue.isEmpty
                        }
                    }
                    if showDeleteButton {
                        handleDeleteButtonUtil(isVisible: !inputText.isEmpty && isDeleteButtonVisible, action: {
                            inputText = ""
                            isDeleteButtonVisible = false
                            deleteAction?()

                            AnalyticsManager.shared.trackEvent(AuthEvents.cancelBtnTapped, additionalParams: [AnalyticsConstants.Parameter.btnName: titleText ?? "미설정"])
                        })
                        .offset(x: 130 * DynamicSizeFactor.factor())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
