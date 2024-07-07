
import SwiftUI

// MARK: - SelectCategoryIconView

struct SelectCategoryIconView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @State var selectedCategoryIcon: CategoryIconName = .etcOnMint

    let columns = [
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32)
    ]

    let icons: [CategoryIconListItem] = [
        CategoryIconListItem(offIcon: .foodOff, onIcon: .foodOnMint),
        CategoryIconListItem(offIcon: .trafficOff, onIcon: .trafficOnMint),
        CategoryIconListItem(offIcon: .beautyOff, onIcon: .beautyOnMint),
        CategoryIconListItem(offIcon: .marketOff, onIcon: .marketOnMint),
        CategoryIconListItem(offIcon: .educationOff, onIcon: .educationOnMint),
        CategoryIconListItem(offIcon: .lifeOff, onIcon: .lifeOnMint),
        CategoryIconListItem(offIcon: .healthOff, onIcon: .healthOnMint),
        CategoryIconListItem(offIcon: .hobbyOff, onIcon: .hobbyOnMint),
        CategoryIconListItem(offIcon: .travelOff, onIcon: .travelOnMint),
        CategoryIconListItem(offIcon: .drinkOff, onIcon: .drinkOnMint),
        CategoryIconListItem(offIcon: .eventOff, onIcon: .eventOnMint),
        CategoryIconListItem(offIcon: .etcOff, onIcon: .etcOnMint)
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
                if let selectedCategory = SpendingCategoryIconList.fromIcon(selectedCategoryIcon) {
                    viewModel.selectedCategoryIconTitle = selectedCategory.rawValue
                    viewModel.selectedCategoryIcon = mapToOnIcon(selectedCategoryIcon)
                    Log.debug(viewModel.selectedCategoryIconTitle)
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

    private func mapToOnIcon(_ icon: CategoryIconName) -> CategoryIconName {
        switch icon {
        case .foodOnMint: return .foodOn
        case .trafficOnMint: return .trafficOn
        case .beautyOnMint: return .beautyOn
        case .marketOnMint: return .marketOn
        case .educationOnMint: return .educationOn
        case .lifeOnMint: return .lifeOn
        case .healthOnMint: return .healthOn
        case .hobbyOnMint: return .hobbyOn
        case .travelOnMint: return .travelOn
        case .drinkOnMint: return .drinkOn
        case .eventOnMint: return .eventOn
        case .etcOnMint: return .etcOn
        default: return icon
        }
    }
}
