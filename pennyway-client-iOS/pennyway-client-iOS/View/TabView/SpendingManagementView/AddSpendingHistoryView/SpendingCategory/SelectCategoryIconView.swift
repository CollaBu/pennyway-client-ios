
import SwiftUI

// MARK: - SelectCategoryIconView

struct SelectCategoryIconView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @State var selectedCategoryIcon: CategoryIconName = .etcOn

    let columns = [
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32)
    ]

    let icons: [CategoryIconListItem] = [
        CategoryIconListItem(offIcon: .foodOff, onIcon: .foodOn),
        CategoryIconListItem(offIcon: .trafficOff, onIcon: .trafficOn),
        CategoryIconListItem(offIcon: .beautyOff, onIcon: .beautyOn),
        CategoryIconListItem(offIcon: .marketOff, onIcon: .marketOn),
        CategoryIconListItem(offIcon: .educationOff, onIcon: .educationOn),
        CategoryIconListItem(offIcon: .lifeOff, onIcon: .lifeOn),
        CategoryIconListItem(offIcon: .healthOff, onIcon: .healthOn),
        CategoryIconListItem(offIcon: .hobbyOff, onIcon: .hobbyOn),
        CategoryIconListItem(offIcon: .travelOff, onIcon: .travelOn),
        CategoryIconListItem(offIcon: .drinkOff, onIcon: .drinkOn),
        CategoryIconListItem(offIcon: .eventOff, onIcon: .eventOn),
        CategoryIconListItem(offIcon: .etcOff, onIcon: .etcOn)
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
                    Image((selectedCategoryIcon.rawValue == icon.onIcon.rawValue ? icon.onIcon : icon.offIcon).rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                        .onTapGesture {
                            selectedCategoryIcon = icon.onIcon
                        }
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            CustomBottomButton(action: {
                if let selectedCategory = SpendingCategoryIconList.fromIcon(viewModel.selectedCategoryIcon ?? .etcOn) {
                    viewModel.selectedCategoryIconTitle = selectedCategory.rawValue
                    viewModel.selectedCategoryIcon = selectedCategoryIcon
                    isPresented = false
                }
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if let icon = viewModel.selectedCategoryIcon {
                selectedCategoryIcon = icon
            }
        }
    }
}
