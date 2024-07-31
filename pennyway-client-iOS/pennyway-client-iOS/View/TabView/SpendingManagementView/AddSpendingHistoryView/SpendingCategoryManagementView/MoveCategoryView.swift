
import SwiftUI

// MARK: - MoveCategoryView

struct MoveCategoryView: View {
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    @ObservedObject var addSpendingHistoryViewModel: AddSpendingHistoryViewModel

    var body: some View {
        ZStack {
            ScrollView {
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(addSpendingHistoryViewModel.spendingCategories) { category in
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
                                addSpendingHistoryViewModel.selectedCategoryIcon = CategoryIconName(baseName: CategoryBaseName.etc, state: .on) // icon 초기화
                                addSpendingHistoryViewModel.categoryName = "" // name 초기화
//                                viewModel.navigateToAddCategory = true
//                                isPresented = false
                            } else {
                                addSpendingHistoryViewModel.selectedCategory = category
//                                isPresented = false
                                addSpendingHistoryViewModel.validateForm()
                            }
                        }
                    }
                    Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Gray01"))
            .navigationBarColor(UIColor(named: "Gray01"), title: "카테고리")
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        NavigationBackButton()
                            .padding(.leading, 5)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())

                    }.offset(x: -10)
                }
            }
        }
    }
}

#Preview {
    MoveCategoryView(spendingCategoryViewModel: SpendingCategoryViewModel(), addSpendingHistoryViewModel: AddSpendingHistoryViewModel())
}
