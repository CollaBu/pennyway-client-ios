
import SwiftUI

// MARK: - CategoryIcon

struct CategoryIcon: Identifiable, Hashable {
    let id = UUID()
    let offIcon: String
    let onIcon: String
}

// MARK: - SelectCategoryIconView

struct SelectCategoryIconView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: AddSpendingHistoryViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let icons: [CategoryIcon] = [
        CategoryIcon(offIcon: "icon_category_food_off", onIcon: "icon_category_food_on"),
        CategoryIcon(offIcon: "icon_category_traffic_off", onIcon: "icon_category_traffic_on"),
        CategoryIcon(offIcon: "icon_category_beauty_off", onIcon: "icon_category_beauty_on"),
        CategoryIcon(offIcon: "icon_category_market_off", onIcon: "icon_category_market_on"),
        CategoryIcon(offIcon: "icon_category_education_off", onIcon: "icon_category_education_on"),
        CategoryIcon(offIcon: "icon_category_life_off", onIcon: "icon_category_life_on"),
        CategoryIcon(offIcon: "icon_category_health_off", onIcon: "icon_category_health_on"),
        CategoryIcon(offIcon: "icon_category_hobby_off", onIcon: "icon_category_hobby_on"),
        CategoryIcon(offIcon: "icon_category_travel_off", onIcon: "icon_category_travel_on"),
        CategoryIcon(offIcon: "icon_category_drink_off", onIcon: "icon_category_drink_on"),
        CategoryIcon(offIcon: "icon_category_event_off", onIcon: "icon_category_event_on"),
        CategoryIcon(offIcon: "icon_category_etc_off", onIcon: "icon_category_etc_on")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("아이콘 선택")
                    .font(.H3SemiboldFont())
                    .padding(.leading, 20)
                    .padding(.top, 28)
                Spacer()
            }

            Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            LazyVGrid(columns: columns, spacing: 20 * DynamicSizeFactor.factor()) {
                ForEach(icons) { icon in
                    Image(viewModel.selectedCategoryIcon == icon.onIcon ? icon.onIcon : icon.offIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                        .onTapGesture {
                            viewModel.selectedCategoryIcon = icon.onIcon
                        }
                }
            }

            Spacer()

            CustomBottomButton(action: {
                isPresented = false
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
