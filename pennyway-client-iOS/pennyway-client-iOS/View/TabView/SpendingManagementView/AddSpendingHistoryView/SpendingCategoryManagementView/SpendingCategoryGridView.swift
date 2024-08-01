
import SwiftUI

// MARK: - SpendingCategoryGridView

struct SpendingCategoryGridView: View {
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    @ObservedObject var addSpendingHistoryViewModel: AddSpendingHistoryViewModel // 카테고리 생성 연동 처리
    @Environment(\.presentationMode) var presentationMode
    
    @State var navigateToCategoryDetails = false
    @State var navigateToAddCategoryView = false
    @State private var showToastDeletePopUp = false

    var body: some View {
        ZStack {
            ScrollView {
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                VStack(alignment: .leading, spacing: 0) {
                    // 시스템 카테고리
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8 * DynamicSizeFactor.factor()) {
                        ForEach(spendingCategoryViewModel.systemCategories) { category in
                            categoryVGridView(for: category)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 20 * DynamicSizeFactor.factor())
                    
                    Text("내가 추가한")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    
                    // 사용자 정의 카테고리
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8 * DynamicSizeFactor.factor()) {
                        ForEach(spendingCategoryViewModel.customCategories) { category in
                            categoryVGridView(for: category)
                        }
                    }
                    .padding(.horizontal, 20)
                                        
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                }
            }
            .overlay(
                Group {
                    if showToastDeletePopUp {
                        CustomToastView(message: "카테고리를 삭제했어요")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                            .padding(.bottom, 34)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    showToastDeletePopUp = false
                                }
                            }
                    }
                }, alignment: .bottom
            )
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
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        Button(action: {
                            navigateToAddCategoryView = true
                            addSpendingHistoryViewModel.selectedCategoryIcon = CategoryIconName(baseName: CategoryBaseName.etc, state: .on) // icon 초기화
                            addSpendingHistoryViewModel.categoryName = "" // name 초기화
                        }, label: {
                            Image("icon_navigation_add")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5 * DynamicSizeFactor.factor())
                        .frame(width: 44, height: 44)
                        .buttonStyle(PlainButtonStyle())
                    }.offset(x: 10)
                }
            }
        }

        NavigationLink(destination: CategoryDetailsView(viewModel: spendingCategoryViewModel, showToastDeletePopUp: $showToastDeletePopUp), isActive: $navigateToCategoryDetails) {}

        NavigationLink(destination: AddSpendingCategoryView(viewModel: addSpendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, entryPoint: .create), isActive: $navigateToAddCategoryView) {}
    }
    
    private func categoryVGridView(for category: SpendingCategoryData) -> some View {
        Button(action: {
            spendingCategoryViewModel.selectedCategory = category
            spendingCategoryViewModel.selectedCategory?.icon = MapCategoryIconUtil.mapToCategoryIcon(category.icon, outputState: .on) // onWhite -> on
            spendingCategoryViewModel.initPage() // 데이터 초기화
            spendingCategoryViewModel.getCategorySpendingCountApi { _ in } // 총 개수 조회
            spendingCategoryViewModel.getCategorySpendingHistoryApi { success in // 지출 내역 조회
                if success {
                    navigateToCategoryDetails = true
                    Log.debug(spendingCategoryViewModel.dailyDetailSpendings)
                }
            }
        }) {
            VStack(spacing: 2 * DynamicSizeFactor.factor()) {
                Spacer().frame(height: 8 * DynamicSizeFactor.factor())
                Image("\(category.icon.rawValue)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 52 * DynamicSizeFactor.factor(), height: 52 * DynamicSizeFactor.factor())
                
                Text(category.name)
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                
                Spacer()
            }
            .frame(width: 88 * DynamicSizeFactor.factor(), height: 92 * DynamicSizeFactor.factor())
            .background(Color("White01"))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SpendingCategoryGridView(spendingCategoryViewModel: SpendingCategoryViewModel(), addSpendingHistoryViewModel: AddSpendingHistoryViewModel())
}
