
import SwiftUI

// MARK: - MoveCategoryView

struct MoveCategoryView: View {
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    @ObservedObject var addSpendingHistoryViewModel: AddSpendingHistoryViewModel
    @Environment(\.presentationMode) var presentationMode

    @State var navigateToAddCategoryView = false

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 16 * DynamicSizeFactor.factor())

            Group {
                Text("\(spendingCategoryViewModel.spedingHistoryTotalCount)개의 소비 내역")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer().frame(height: 4 * DynamicSizeFactor.factor())

                Text("변경할 카테고리를 선택해 주세요")
                    .font(.H3SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 25 * DynamicSizeFactor.factor())

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(spendingCategoryViewModel.spendingCategories.enumerated()), id: \.element.id) { _, category in
                        HStack(spacing: 10) {
                            Image(getCategoryIcon(category: category, isSelected: category.id == spendingCategoryViewModel.selectedMoveCategoryId))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())

                            Text(category.name)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: category.name == "추가하기" ? Color("Gray04") : Color("Gray07"))

                            Spacer()

                            if category.id == spendingCategoryViewModel.selectedMoveCategoryId {
                                Image("icon_checkone_on_small")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6 * DynamicSizeFactor.factor())
                        .contentShape(Rectangle()) // This makes the entire HStack touchable
                        .onTapGesture {
                            if category.name == "추가하기" {
                                addSpendingHistoryViewModel.selectedCategoryIcon = CategoryIconName(baseName: CategoryBaseName.etc, state: .on) // icon 초기화
                                addSpendingHistoryViewModel.categoryName = "" // name 초기화
                                navigateToAddCategoryView = true
                            } else {
                                spendingCategoryViewModel.selectedMoveCategoryId = category.id // 선택한 카테고리 id
                            }
                        }
                    }
                    Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                }
                .padding(.horizontal, 20)
            }
            Spacer()

            CustomBottomButton(action: {
                if spendingCategoryViewModel.selectedMoveCategoryId != 0 {
                    presentationMode.wrappedValue.dismiss()
                    spendingCategoryViewModel.selectedMoveCategoryId = 0 // 선택한 카테고리 id 초기화
                }

            }, label: "확인", isFormValid: .constant(spendingCategoryViewModel.selectedMoveCategoryId != 0))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())

            NavigationLink(destination: AddSpendingCategoryView(viewModel: addSpendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, entryPoint: .create), isActive: $navigateToAddCategoryView) {}
        } 
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White01"))
        .navigationBarColor(UIColor(named: "White01"), title: "소비 내역 이동")
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    NavigationBackButton(action: {
                        spendingCategoryViewModel.selectedMoveCategoryId = 0
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }

    private func getCategoryIcon(category: SpendingCategoryData, isSelected: Bool) -> String {
        if category.name == "추가하기" {
            return category.icon.rawValue
        }
        let iconName = MapCategoryIconUtil.mapToCategoryIcon(category.icon, outputState: isSelected ? .onMint : .on) // 선택했다면 onMint 아니면 on으로 반환
        return iconName.rawValue
    }
}

#Preview {
    MoveCategoryView(spendingCategoryViewModel: SpendingCategoryViewModel(), addSpendingHistoryViewModel: AddSpendingHistoryViewModel())
}
