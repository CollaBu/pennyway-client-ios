import SwiftUI

struct InquiryListView: View {
    @ObservedObject var viewModel: InquiryViewModel
    @State private var isSelectedCategory: Bool = false
    @State var listArray: [String] = ["이용 관련", "오류 신고", "서비스 제안", "기타"]
    @State var selectedItem: String? = nil

    var body: some View {
        VStack {
            Button(action: {
                isSelectedCategory.toggle()
            }, label: {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 159 * DynamicSizeFactor.factor(), height: 46 * DynamicSizeFactor.factor())
                        .background(Color("Gray01"))
                        .cornerRadius(3)
                        .transition(.move(edge: .top))

                    Text(selectedItem ?? "카테고리 선택")
                        .font(.B1MediumFont())
                        .platformTextColor(color: selectedItem != nil ? Color("Gray07") : Color("Gray03"))
                        .padding(.leading, 13 * DynamicSizeFactor.factor())

                    Spacer()

                    Image("icon_arrow_down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(.degrees(isSelectedCategory ? 0 : 180))
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        .offset(x: 124 * DynamicSizeFactor.factor())
                }

            })
            .transition(.opacity.animation(.easeIn))
            .buttonStyle(PlainButtonStyle())
            .overlay(
                VStack(alignment: .center, spacing: 60 * DynamicSizeFactor.factor()) {
                    Spacer().frame(height: 6 * DynamicSizeFactor.factor())
                    if isSelectedCategory {
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
                                        self.viewModel.category = item
                                        isSelectedCategory = false
                                    }, label: {
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 148, height: 36 * DynamicSizeFactor.factor())
                                                .cornerRadius(3)
                                                .transition(.move(edge: .top))

                                            Text(item)
                                                .font(.B1SemiboldeFont())
                                                .multilineTextAlignment(.leading)
                                                .platformTextColor(color: selectedItem == item ? Color("Gray05") : Color("Gray04"))
                                        }
                                        .padding(.horizontal, 11)
                                        .padding(.vertical, 2)
                                        .background(selectedItem == item ? Color("Gray03") : Color("White01"))

                                    })

                                    .buttonStyle(PlainButtonStyle())
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
        .animation(.easeInOut(duration: 0.2))
    }
}

#Preview {
    InquiryListView(viewModel: InquiryViewModel())
}
