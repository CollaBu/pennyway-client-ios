
import SwiftUI

// MARK: - MoveCategoryView

struct MoveCategoryView: View {
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    @ObservedObject var addSpendingHistoryViewModel: AddSpendingHistoryViewModel
    @Environment(\.presentationMode) var presentationMode

    @State var navigateToAddCategoryView = false

    var body: some View {
        VStack {
            ScrollView {
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())

                VStack(alignment: .leading, spacing: 0) {
                    Text("\(spendingCategoryViewModel.spedingHistoryTotalCount)개의 소비 내역")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer().frame(height: 4 * DynamicSizeFactor.factor())

                    Text("변경할 카테고리를 선택해 주세요")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer().frame(height: 25 * DynamicSizeFactor.factor())

                    ForEach(Array(spendingCategoryViewModel.spendingCategories.enumerated()), id: \.element.id) { _, category in
                        HStack(spacing: 10) {
                            Image(category.name == "추가하기" ? category.icon.rawValue : (category.id == spendingCategoryViewModel.selectedMoveCategoryId ? MapCategoryIconUtil.mapToCategoryIcon(category.icon, outputState: .onMint).rawValue : MapCategoryIconUtil.mapToCategoryIcon(category.icon, outputState: .on).rawValue))
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
                                spendingCategoryViewModel.selectedMoveCategoryId = category.id
                            }
                        }
                    }
                    Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                }
                .padding(.horizontal, 20)
            }
            Spacer()

            CustomBottomButton(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: "확인", isFormValid: .constant(true))
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
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        spendingCategoryViewModel.selectedMoveCategoryId = 0
                    }, label: {
                        Image("icon_arrow_back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .padding(5)
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }
}

#Preview {
    MoveCategoryView(spendingCategoryViewModel: SpendingCategoryViewModel(), addSpendingHistoryViewModel: AddSpendingHistoryViewModel())
}
