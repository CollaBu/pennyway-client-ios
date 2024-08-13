
import SwiftUI

// MARK: - CategoryDetailsView

struct CategoryDetailsView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isClickMenu = false
    @State private var selectedMenu: String? = nil // 선택한 메뉴
    @State private var listArray: [String] = ["수정하기", "카테고리 삭제"]
    @State private var showDeletePopUp = false
    @State private var showDeleteToastPopup = false
    @State private var showMoveToastPopup = false // 카테고리 이동
    @State var isDeleted = false
    @State private var isNavigateToEditCategoryView = false
    @State private var isNavigateToMoveCategoryView = false
    
    @Binding var showDeleteCategoryToastPopUp: Bool // 카테고리 삭제시

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())
                        
                    Image("\(viewModel.selectedCategory!.icon.rawValue)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor())
                        
                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                        
                    Text(viewModel.selectedCategory!.name)
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))
                        
                    Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                        
                    Text("\(viewModel.spedingHistoryTotalCount)개의 소비 내역")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                        
                    Spacer().frame(height: 28 * DynamicSizeFactor.factor())
                        
                    Rectangle()
                        .platformTextColor(color: Color("Gray01"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 1 * DynamicSizeFactor.factor())
                        
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                        
                    CategorySpendingListView(viewModel: viewModel, showDeleteToastPopup: $showDeleteToastPopup, isDeleted: $isDeleted)
                        
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            }
            .overlay(
                Group {
                    if showDeleteToastPopup || showMoveToastPopup {
                        CustomToastView(message: showDeleteToastPopup ? "소비 내역을 삭제했어요" : "소비 내역을 이동시켰어요")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                            .padding(.bottom, 34)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    if showDeleteToastPopup {
                                        showDeleteToastPopup = false
                                    } else {
                                        showMoveToastPopup = false
                                    }
                                }
                            }
                    }
                }, alignment: .bottom
            )
            
            .overlay(
                VStack(alignment: .leading) {
                    if isClickMenu {
                        CustomDropdownMenuView(
                            isClickMenu: $isClickMenu,
                            selectedMenu: $selectedMenu,
                            listArray: listArray,
                            onItemSelected: { item in
                                if item == "카테고리 삭제" {
                                    showDeletePopUp = true
                                } else {
                                    isNavigateToEditCategoryView = true
                                    viewModel.categoryName = ""
                                    viewModel.selectedCategoryIcon = viewModel.selectedCategory?.icon
                                }
                                Log.debug("Selected item: \(item)")
                            }
                        ).padding(.trailing, 20)
                    }
                }, alignment: .topTrailing
            )
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarColor(UIColor(named: "White01"), title: "")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationBackButton()
                            .padding(.leading, 5)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())

                    }.offset(x: -10)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.selectedCategory!.isCustom {
                        HStack {
                            Button(action: {
                                isClickMenu.toggle()
                                selectedMenu = nil
                            }, label: {
                                Image("icon_navigationbar_kebabmenu")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                    .padding(5)
                            })
                            .padding(.trailing, 5)
                            .frame(width: 44, height: 44)
                            .buttonStyle(BasicButtonStyleUtil())

                        }.offset(x: 10)
                    }
                }
            }
            .onAppear {
                refreshView {}
            }
            .onChange(of: isDeleted) { newValue in
                if newValue {
                    refreshView {
                        showDeleteToastPopup = true
                    }
                    isDeleted = false
                }
            }
            
            if showDeletePopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(
                    showingPopUp: $showDeletePopUp,
                    titleLabel: "카테고리를 삭제할까요?",
                    subTitleLabel: "\(viewModel.spedingHistoryTotalCount)개의 소비 내역이 모두 사라져요🥲",
                    firstBtnAction: {
                        self.isNavigateToMoveCategoryView = true
                        self.showDeletePopUp = false
                    },
                    firstBtnLabel: "내역 옮기기",
                    secondBtnAction: { 
                        viewModel.deleteCategoryApi { success in
                            if success {
                                viewModel.getSpendingCustomCategoryListApi { _ in
                                    self.showDeletePopUp = false
                                    self.presentationMode.wrappedValue.dismiss()
                                    self.showDeleteCategoryToastPopUp = true
                                }
                            }
                        }
                    },
                    secondBtnLabel: "삭제하기",
                    secondBtnColor: Color("Red03")
                )
            }
            NavigationLink(destination: AddSpendingCategoryView(viewModel: AddSpendingHistoryViewModel(), spendingCategoryViewModel: viewModel, entryPoint: .modify), isActive: $isNavigateToEditCategoryView) {}
                .hidden()
            
            NavigationLink(destination: MoveCategoryView(spendingCategoryViewModel: viewModel, addSpendingHistoryViewModel: AddSpendingHistoryViewModel(), showMoveToastPopup: $showMoveToastPopup), isActive: $isNavigateToMoveCategoryView) {}
                .hidden()
        }
    }

    private func refreshView(completion: @escaping () -> Void) {
        viewModel.initPage()
        viewModel.getCategorySpendingHistoryApi { success in
            if success {
                Log.debug("카테고리 지출내역 조회 성공")
                // 기존 데이터의 마지막 인덱스를 확인하고, 추가 데이터를 불러오는 로직 추가
                if let lastItem = viewModel.dailyDetailSpendings.last {
                    guard let index = viewModel.dailyDetailSpendings.firstIndex(where: { $0.id == lastItem.id }) else {
                        return
                    }
                    // 해당 인덱스가 마지막 인덱스라면 데이터 추가
                    if index == viewModel.dailyDetailSpendings.count - 1 {
                        Log.debug("지출 내역 index: \(index)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 임시 버퍼링
                            viewModel.getCategorySpendingHistoryApi { _ in }
                        }
                    }
                }
            } else {
                Log.debug("카테고리 지출내역 조회 실패")
            }
            completion()
        }
    }
}
