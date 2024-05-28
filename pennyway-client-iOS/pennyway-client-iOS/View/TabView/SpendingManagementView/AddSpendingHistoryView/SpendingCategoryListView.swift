
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
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 40, height: 4)
                .platformTextColor(color: Color("Gray03"))
                .padding(.top, 12)

            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())

                    Text("카테고리를 선택해 주세요")
                        .font(.H3SemiboldFont())

                    Spacer().frame(height: 22 * DynamicSizeFactor.factor())

                    VStack(spacing: 0) {
                        ForEach(categories, id: \.1) { icon, title in
                            HStack(spacing: 10) {
                                Image(icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())

                                Text(title)
                                    .font(.B1SemiboldeFont())
                                    .platformTextColor(color: title == "추가하기" ? Color("Gray04") : Color("Gray07"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 6 * DynamicSizeFactor.factor())
                            .onTapGesture {
                                if title == "추가하기" {
                                    viewModel.selectedCategoryIcon = "icon_category_etc_on" // icon 초기화
                                    viewModel.navigateToAddCategory = true
                                    isPresented = false
                                } else {
                                    viewModel.selectedCategory = (icon, title)
                                    isPresented = false
                                    viewModel.validateForm()
                                }
                            }
                        }
                        Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                    }
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
