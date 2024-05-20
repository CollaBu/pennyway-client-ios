
import SwiftUI

// MARK: - AddSpendingInputFormView

struct AddSpendingInputFormView: View {
    let baseAttribute: BaseAttribute = BaseAttribute(font: .B1MediumFont(), color: Color("Gray07"))
    let stringAttribute: StringAttribute = StringAttribute(text: "*", font: .B1MediumFont(), color: Color("Mint03"))
    
    let titleCustomTextList: [String] = ["카테고리*", "날짜*"]
    
    @State private var memoText: String = "Placeholder"
    @State private var characterCount: Int = 0
    let maxCharacterCount: Int = 100

    var body: some View {
        VStack {
            Spacer().frame(height: 31 * DynamicSizeFactor.factor())
            
            // TODO: placeholder 수정
            CustomInputView(inputText: .constant("소비할 금액"), titleText: "금액*", isSecureText: false, isCustom: true)
            
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
            
            // TODO: 박스 터치영역 고려 필요
            HStack {
                titleCustomTextList[0].toAttributesText(base: baseAttribute, stringAttribute)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("카테고리를 선택해 주세요")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                    Button(action: {}, label: {
                        Image("icon_arrow_front_small")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    })
                }
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 20 * DynamicSizeFactor.factor())
            
            HStack {
                titleCustomTextList[1].toAttributesText(base: baseAttribute, stringAttribute)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("몇월 몇일")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                    Button(action: {}, label: {
                        Image("icon_arrow_front_small")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    })
                }
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
            
            // TODO: placeholder 수정
            CustomInputView(inputText: .constant("카페일 수혈"), titleText: "소비처", isSecureText: false, isCustom: true)
            
            Spacer().frame(height: 28 * DynamicSizeFactor.factor())
            
            VStack(alignment: .leading) {
                Text("메모")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                
                Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 104 * DynamicSizeFactor.factor())
                    
                    TextEditor(text: $memoText)
                        .font(.H4MediumFont())
                        .padding(12 * DynamicSizeFactor.factor())
                        .scrollContentBackgroundHidden()
                        .background(Color("Gray01"))
                        .textEditorBackground {
                            Color("Gray01") // Color works with earlier versions
                        }
                }
                
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
}

extension View {
    func scrollContentBackgroundHidden() -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollContentBackground(.hidden)
        } else {
            return self
        }
    }
    
    /// Layers the given views behind this ``TextEditor``.
    ///
    func textEditorBackground<V>(@ViewBuilder _ content: () -> V) -> some View where V: View {
        onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .background(content())
    }
}
