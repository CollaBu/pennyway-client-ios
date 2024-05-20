
import SwiftUI

struct AddSpendingHistoryView: View {
    init() {
        baseAttribute = BaseAttribute(font: .B1MediumFont(), color: Color("Gray07"))
        stringAttribute = StringAttribute(text: "*", font: .B1MediumFont(), color: Color("Mint03"))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "White01")
        appearance.shadowColor = .clear // 구분선 hide
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    let baseAttribute: BaseAttribute
    let stringAttribute: StringAttribute
    
    let titleCustomTextList: [String] = ["카테고리*", "날짜*"]
    
    var body: some View {
        VStack {
            ScrollView {
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
                            .platformTextColor(color: Color("Gray04"))
                        
                        Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("Gray01"))
                                .frame(height: 104 * DynamicSizeFactor.factor())
                            
                            TextEditor(text: .constant("Placeholder\n dl"))
                                .padding(12 * DynamicSizeFactor.factor())
                        }
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear
                        }
                        
                        Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                        
                        HStack{
                            Spacer()
                            Text("글자수")
                                .font(.B2MediumFont())
                                .platformTextColor(color: Color("Gray03"))
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            Spacer()
            
            CustomBottomButton(action: {}, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {}, label: {
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
    AddSpendingHistoryView()
}
