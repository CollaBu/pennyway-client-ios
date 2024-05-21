import SwiftUI

struct InquiryListView: View {
    @State private var isSelectedCategory: Bool = false
    @State var listArray: [String] = ["이용 관련", "오류 신고", "서비스 제안", "기타"]
    @State var selectedItem: String? = nil

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 159 * DynamicSizeFactor.factor(), height: 46 * DynamicSizeFactor.factor())
                    .background(Color("Gray01"))
                    .cornerRadius(3)

                Text(selectedItem ?? "카테고리 선택")
                    .font(.B1MediumFont())
                    .platformTextColor(color: selectedItem != nil ? Color("Gray07") : Color("Gray03"))
                    .padding(.leading, 13 * DynamicSizeFactor.factor())

                Spacer()

                Button(action: {
                    isSelectedCategory.toggle()
                }, label: {
                    let selected = isSelectedCategory == true ? Image("icon_arrow_up") : Image("icon_arrow_down")

                    selected
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())

                })
                .offset(x: 124 * DynamicSizeFactor.factor())
                .overlay(
                    VStack(alignment: .center, spacing: 45) { // 동적ui 적용하면 간격 너무 넓어짐
                        if isSelectedCategory {
                            Spacer().frame(height: 6 * DynamicSizeFactor.factor())
                            ZStack {
                                Rectangle()
                                    .cornerRadius(3)
                                    .platformTextColor(color: Color("White01"))
                                    .padding(.vertical, 5)
                                    .shadow(color: .black.opacity(0.06), radius: 7, x: 0, y: 0)
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(listArray, id: \.self) { item in
                                        Button(action: {
                                            self.selectedItem = item
                                        }, label: {
                                            ZStack(alignment: .leading) {
                                                Rectangle()
                                                    .foregroundColor(.clear)
                                                    .frame(width: 148, height: 36 * DynamicSizeFactor.factor()) // 여기에 동적ui 적용하니 사이즈 너무 커짐
                                                    .cornerRadius(3)

                                                Text(item)
                                                    .font(.B1SemiboldeFont())
                                                    .multilineTextAlignment(.leading)
                                                    .platformTextColor(color: selectedItem == item ? Color("Gray05") : Color("Gray04"))
                                            }
                                            .padding(.horizontal, 11)
                                            .background(selectedItem == item ? Color("Gray03") : Color("White01"))

                                        })
                                    }
                                    .cornerRadius(3)
                                }
                                .padding(.vertical, 12 * DynamicSizeFactor.factor())
                                .zIndex(3)
                            }
                            .frame(width: 159 * DynamicSizeFactor.factor(), height: 149 * DynamicSizeFactor.factor())
                            .zIndex(3)
                        }
                    }, alignment: .topLeading
                )
            }
        }
    }
}

#Preview {
    InquiryListView()
}
