import SwiftUI

// MARK: - AmountInputView

struct AmountInputView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    var title: String
    var placeholder: String
    @State private var isDeleteButtonVisible: Bool = false

    let baseAttribute: BaseAttribute
    let stringAttribute: StringAttribute

    var body: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            title.toAttributesText(base: baseAttribute, stringAttribute)
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))
                .padding(.horizontal, 20)

            CustomInputView(inputText: $viewModel.amountSpentText, placeholder: placeholder, onCommit: {
                isDeleteButtonVisible = false
            }, isSecureText: false, isCustom: false, showDeleteButton: true, deleteAction: {
                viewModel.amountSpentText = ""
                isDeleteButtonVisible = false
            })
            .keyboardType(.numberPad)
            .onChange(of: viewModel.amountSpentText) { _ in
                viewModel.amountSpentText = NumberFormatterUtil.formatStringToDecimalString(viewModel.amountSpentText)
                viewModel.validateForm()
            }
        }
    }
}

// MARK: - MemoInputView

struct MemoInputView: View {
    @Binding var memoText: String
    var title: String
    var placeholder: String
    var maxCharacterCount: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))

            Spacer().frame(height: 13 * DynamicSizeFactor.factor())

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("Gray01"))
                    .frame(height: 104 * DynamicSizeFactor.factor())

                TextEditor(text: $memoText)
                    .font(.H4MediumFont())
                    .padding(.horizontal, 8 * DynamicSizeFactor.factor())
                    .padding(.vertical, 5 * DynamicSizeFactor.factor())
                    .zIndex(0)
                    .colorMultiply(Color("Gray01"))
                    .cornerRadius(4)
                    .TextAutocapitalization()
                    .AutoCorrectionExtensions()
                    .onChange(of: memoText) { _ in
                        if memoText.count > maxCharacterCount {
                            memoText = String(memoText.prefix(maxCharacterCount))
                        }
                    }
                    .frame(height: 104 * DynamicSizeFactor.factor())

                if memoText.isEmpty {
                    Text(placeholder)
                        .font(.H4MediumFont())
                        .padding(12 * DynamicSizeFactor.factor())
                        .platformTextColor(color: Color("Gray03"))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))

            Spacer().frame(height: 4 * DynamicSizeFactor.factor())

            HStack {
                Spacer()
                Text("\(memoText.count)/\(maxCharacterCount)")
                    .font(.B2MediumFont())
                    .platformTextColor(color: Color("Gray03"))
            }
        }
        .padding(.horizontal, 20)
    }
}
