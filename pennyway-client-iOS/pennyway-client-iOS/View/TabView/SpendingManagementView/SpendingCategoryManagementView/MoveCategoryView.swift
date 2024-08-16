
import SwiftUI

// MARK: - MoveCategoryView

struct MoveCategoryView: View {
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    @ObservedObject var addSpendingHistoryViewModel: AddSpendingHistoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var showMoveToastPopup: Bool

    @State var navigateToAddCategoryView = false
    @State var showingPopUp = false

    var body: some View {
        ZStack {
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
                        ForEach(spendingCategoryViewModel.spendingCategories.filter { $0.id != spendingCategoryViewModel.selectedCategory?.id }, id: \.id) { category in
                            HStack(spacing: 10) {
                                Image(getCategoryIcon(category: category, isSelected: category.id == spendingCategoryViewModel.selectedMoveCategory?.id))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                
                                Text(category.name)
                                    .font(.B1SemiboldeFont())
                                    .platformTextColor(color: category.name == "추가하기" ? Color("Gray04") : Color("Gray07"))
                                
                                Spacer()
                                
                                if category.id == spendingCategoryViewModel.selectedMoveCategory?.id {
                                    Image("icon_checkone_on_small")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 6 * DynamicSizeFactor.factor())
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if category.name == "추가하기" {
                                    addSpendingHistoryViewModel.selectedCategoryIcon = CategoryIconName(baseName: CategoryBaseName.etc, state: .on) // icon 초기화
                                    addSpendingHistoryViewModel.categoryName = "" // name 초기화
                                    navigateToAddCategoryView = true
                                } else {
                                    spendingCategoryViewModel.selectedMoveCategory = category // 선택한 카테고리
                                }
                            }
                        }
                        Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
                
                CustomBottomButton(action: {
                    showingPopUp = true
                }, label: "확인", isFormValid: .constant(spendingCategoryViewModel.selectedMoveCategory != nil))
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
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
                            spendingCategoryViewModel.selectedMoveCategory = nil
                        })
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                    }.offset(x: -10)
                }
            }
            
            if showingPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showingPopUp,
                                titleLabel: "'\(spendingCategoryViewModel.selectedMoveCategory?.name ?? "")'으로 옮길까요?",
                                subTitleLabel: "소비 내역 \(spendingCategoryViewModel.spedingHistoryTotalCount)개의 카테고리가 변경돼요",
                                firstBtnAction: { self.showingPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: { DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    if spendingCategoryViewModel.selectedMoveCategory != nil {
                                        moveCategoryApi()
                                    }

                                }},
                                secondBtnLabel: "옮길래요",
                                secondBtnColor: Color("Mint03"))
            }
            
            NavigationLink(destination: AddSpendingCategoryView(viewModel: addSpendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, entryPoint: .create), isActive: $navigateToAddCategoryView) {}
                .hidden()
        }
        .analyzeEvent(SpendingCategoryEvents.categoryMigrateView)
    }

    private func getCategoryIcon(category: SpendingCategoryData, isSelected: Bool) -> String {
        if category.name == "추가하기" {
            return category.icon.rawValue
        }
        let iconName = MapCategoryIconUtil.mapToCategoryIcon(category.icon, outputState: isSelected ? .onMint : .on) // 선택했다면 onMint 아니면 on으로 반환
        return iconName.rawValue
    }
    
    private func moveCategoryApi() {
        spendingCategoryViewModel.moveCategoryApi { success in
            if success {
                presentationMode.wrappedValue.dismiss()
                spendingCategoryViewModel.selectedCategory = spendingCategoryViewModel.selectedMoveCategory // 이동할 카테고리로 변경
                spendingCategoryViewModel.selectedCategory?.icon = MapCategoryIconUtil.mapToCategoryIcon(spendingCategoryViewModel.selectedMoveCategory!.icon, outputState: .on) // icon 회색으로 변경
                spendingCategoryViewModel.selectedMoveCategory = nil // 선택한 카테고리 초기화
                showMoveToastPopup = true
                spendingCategoryViewModel.getCategorySpendingCountApi { _ in } // 총 개수 조회
                spendingCategoryViewModel.getCategorySpendingHistoryApi { success in // 지출 내역 조회
                    if success {
                        Log.debug(spendingCategoryViewModel.dailyDetailSpendings)
                    }
                }
            }
        }
    }
}

#Preview {
    MoveCategoryView(spendingCategoryViewModel: SpendingCategoryViewModel(), addSpendingHistoryViewModel: AddSpendingHistoryViewModel(), showMoveToastPopup: .constant(false))
}
