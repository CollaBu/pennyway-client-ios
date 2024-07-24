
import SwiftUI

// MARK: - CategoryDetailsView

struct CategoryDetailsView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isClickMenu = false
    @State private var selectedMenu: String? = nil // 선택한 메뉴
    @State private var listArray: [String] = ["수정하기", "카테고리 삭제"]
    @State private var showingPopUp = false
    @State private var showToastPopup = false
    @State var isDeleted = false
    @State private var isNavigateToEditCategoryView = false

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

                    CategorySpendingListView(viewModel: viewModel, showToastPopup: $showToastPopup, isDeleted: $isDeleted)
                }
            }

            if showingPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(
                    showingPopUp: $showingPopUp,
                    titleLabel: "카테고리를 삭제할까요?",
                    subTitleLabel: "몇개의 소비 내역이 모두 사라져요🥲",
                    firstBtnAction: { self.showingPopUp = false },
                    firstBtnLabel: "내역 옮기기",
                    secondBtnAction: { self.showingPopUp = false },
                    secondBtnLabel: "삭제하기",
                    secondBtnColor: Color("Red03")
                )
            }
        }
        .onAppear {
            refreshView {}
        }
        .onChange(of: isDeleted) { newValue in
            if newValue {
                refreshView {
                    showToastPopup = true
                }
                isDeleted = false
            }
        }
        .overlay(
            Group {
                if showToastPopup {
                    CustomToastView(message: "소비내역이 삭제되었어요")
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                showToastPopup = false
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
                                showingPopUp = true
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
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
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
                    }.offset(x: 10)
                }
            }
        }
        NavigationLink(destination: AddSpendingCategoryView(viewModel: AddSpendingHistoryViewModel(), spendingCategoryViewModel: viewModel, entryPoint: .modify), isActive: $isNavigateToEditCategoryView) {}
    }

    private func refreshView(completion: @escaping () -> Void) {
        viewModel.initPage()
        viewModel.getCategorySpendingHistoryApi { success in
            if success {
                Log.debug("카테고리 지출내역 조회 성공")
            } else {
                Log.debug("카테고리 지출내역 조회 실패")
            }
            completion()
        }
    }
}
