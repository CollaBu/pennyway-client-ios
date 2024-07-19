
import SwiftUI

// MARK: - SpendingCategoryListView

struct SpendingCategoryListView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 40, height: 4)
                .platformTextColor(color: Color("Gray03"))
                .padding(.top, 12)

            Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            Text("카테고리를 선택해 주세요")
                .font(.H3SemiboldFont())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            Spacer().frame(height: 22 * DynamicSizeFactor.factor())

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.spendingCategories) { category in
                        HStack(spacing: 10) {
                            Image(category.icon.rawValue)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())

                            Text(category.name)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: category.name == "추가하기" ? Color("Gray04") : Color("Gray07"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6 * DynamicSizeFactor.factor())
                        .contentShape(Rectangle()) // This makes the entire HStack touchable
                        .onTapGesture {
                            if category.name == "추가하기" {
                                viewModel.selectedCategoryIcon = CategoryIconName(baseName: CategoryBaseName.etc, state: .on, totalName: nil) // icon 초기화
                                viewModel.categoryName = "" // name 초기화
                                viewModel.navigateToAddCategory = true
                                viewModel.isAddCategoryFormValid = false
                                isPresented = false
                            } else {
                                viewModel.selectedCategory = category
                                isPresented = false
                                viewModel.validateForm()
                            }
                        }
                    }
                    Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SpendingCategoryListView(viewModel: AddSpendingHistoryViewModel(), isPresented: .constant(true))
}
