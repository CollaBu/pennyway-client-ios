
import SwiftUI

// MARK: - SpendingCategoryListView

struct SpendingCategoryListView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel

    @Binding var isPresented: Bool

    let categories = [
        ("icon_category_food_on", "식비"),
        ("icon_category_traffic_on", "교통"),
        ("icon_category_beauty_on", "미용/패션"),
        ("icon_category_market_on", "편의점/마트"),
        ("icon_category_education_on", "교육"),
        ("icon_category_life_on", "생활"),
        ("icon_category_health_on", "건강"),
        ("icon_category_hobby_on", "취미/여가"),
        ("icon_category_travel_on", "여행/숙박"),
        ("icon_category_drink_on", "술/유흥"),
        ("icon_category_event_on", "회비/경조사"),
        ("icon_category_plus_off", "추가하기")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Image("icon_close")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                }
                .frame(width: 44 * DynamicSizeFactor.factor(), height: 44 * DynamicSizeFactor.factor())
                Spacer()
            }

            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 16 * DynamicSizeFactor.factor())

                    Text("카테고리를 선택해 주세요")
                        .font(.H2SemiboldFont())

                    Spacer().frame(height: 40 * DynamicSizeFactor.factor())

                    ForEach(categories, id: \.1) { icon, title in
                        HStack {
                            Image(icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                .padding(.trailing, 8)

                            Text(title)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: title == "추가하기" ? Color("Gray04") : Color("Gray07"))
                        }
                        .onTapGesture {
                            if title == "추가하기" {
                                viewModel.navigateToAddCategory = true
                                isPresented = false
                            } else {
                                viewModel.categoryName = title
                                viewModel.selectedCategoryIcon = icon
                                isPresented = false
                                viewModel.validateForm()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    }
                    Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SpendingCategoryListView(viewModel: AddSpendingHistoryViewModel(), isPresented: .constant(true))
}
