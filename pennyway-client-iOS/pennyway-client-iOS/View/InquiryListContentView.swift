
import SwiftUI

struct InquiryListContentView: View {
    @State var listArray: [String] = ["이용 관련", "오류 신고", "서비스 제안", "기타"]
    @State var selectedItem: String? = nil
    @State var show = false
    @State var item = "Item1"
    var body: some View {
        VStack {
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
//                                    .padding(.horizontal, 2)

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
            }
            .frame(width: 159 * DynamicSizeFactor.factor(), height: 149 * DynamicSizeFactor.factor())
        }
//        .offset(x: -70, y: 10)
        .border(Color.black)
    }
}

#Preview {
    InquiryListContentView()
}
