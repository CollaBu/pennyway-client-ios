import SwiftUI

struct DetailSpendingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isSelectedCategory: Bool = false

    @State var selectedItem: String? = nil
    @State var listArray: [String] = ["수정하기", "내역 삭제"]
    @State var navigateModifySpendingHistoryView = false
    @StateObject var spendingHistoryViewModel = SpendingHistoryViewModel()

    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    @Binding var clickDate: Date?
    @Binding var spendingId: Int?
    @Binding var isDeleted: Bool
    @Binding var showToastPopup: Bool
    @State private var forceUpdate: Bool = false
    @State private var showingPopUp: Bool = false

    @State var newDetails = AddSpendingHistoryRequestDto(amount: 0, categoryId: 0, icon: "", spendAt: "", accountName: "", memo: "")

    init(clickDate: Binding<Date?>, spendingId: Binding<Int?>, isDeleted: Binding<Bool>, showToastPopup: Binding<Bool>, spendingCategoryViewModel: SpendingCategoryViewModel) {
        _clickDate = clickDate
        _spendingId = spendingId
        _isDeleted = isDeleted
        _showToastPopup = showToastPopup
        _spendingCategoryViewModel = ObservedObject(wrappedValue: spendingCategoryViewModel)
        _spendingHistoryViewModel = StateObject(wrappedValue: SpendingHistoryViewModel())
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Spacer().frame(height: 26 * DynamicSizeFactor.factor())

                if let spendingDetail = spendingCategoryViewModel.selectSpending {
                    // 지출 카테고리 리스트로 조회시
                    MoreDetailSpendingView(clickDate: $clickDate, spendingHistoryViewModel: spendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, spendingId: spendingDetail.id)
                } else {
                    if let spendingId = spendingId {
                        MoreDetailSpendingView(clickDate: $clickDate, spendingHistoryViewModel: spendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, spendingId: spendingId)
                    }
                }
            }
            if showingPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showingPopUp,
                                titleLabel: "내역을 삭제할까요?",
                                subTitleLabel: "선택한 소비 내역이 사라져요",
                                firstBtnAction: { self.showingPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: { DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 버튼 액션 보이기 위해 임시로 0.2초 지연 후 뷰 넘어가도록 설정
                                    deleteSingleSpending()

                                }},
                                secondBtnLabel: "삭제하기",
                                secondBtnColor: Color("Red03"))
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .setTabBarVisibility(isHidden: true)
        .edgesIgnoringSafeArea(.bottom)
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
                HStack(spacing: 0) {
                    Button(action: {
                        isSelectedCategory.toggle()
                        self.selectedItem = nil
                        Log.debug("isSelectedCategory: \(isSelectedCategory)")
                    }, label: {
                        Image("icon_navigationbar_kebabmenu")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            .padding(5)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .buttonStyle(BasicButtonStyleUtil())
                    .padding(.trailing, 5)
                    .frame(width: 44, height: 44)
                }
                .offset(x: 10)
            }
        }
        .onAppear {
            loadDataForSelectedDate()
            isSelectedCategory = false
            self.selectedItem = nil
//            isDeleted = false
        }
        .overlay(
            VStack(alignment: .center) {
                Spacer().frame(height: 6 * DynamicSizeFactor.factor())
                if isSelectedCategory {
                    CustomDropdownMenuView(
                        isClickMenu: $isSelectedCategory,
                        selectedMenu: $selectedItem,
                        listArray: listArray,
                        onItemSelected: { item in
                            if item == "수정하기" {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 버튼 액션 보이기 위해 임시로 0.2초 지연 후 뷰 넘어가도록 설정
                                    navigateModifySpendingHistoryView = true
                                }
                            } else { // 내역 삭제일 경우
                                showingPopUp = true
                                isSelectedCategory = false
                            }
                            Log.debug("Selected item: \(item)")
                        }
                    ).padding(.trailing, 20)
                }
            }, alignment: .topTrailing
        )

        NavigationLink(destination: AddSpendingHistoryView(spendingCategoryViewModel: spendingCategoryViewModel, spendingHistoryViewModel: spendingHistoryViewModel, clickDate: $clickDate, isPresented: .constant(false), entryPoint: .detailSpendingView), isActive: $navigateModifySpendingHistoryView) {}
            .hidden()
    }

    private func loadDataForSelectedDate() {
        guard let date = clickDate else {
            return
        }
        spendingHistoryViewModel.selectedDate = date
        spendingHistoryViewModel.checkSpendingHistoryApi { success in
            if success {
                Log.debug("선택한 날짜의 지출 내역 조회 성공")
                forceUpdate.toggle()
            } else {
                Log.debug("선택한 날짜의 지출 내역 조회 실패")
            }
        }
    }

    private func deleteSingleSpending() {
        guard let spendingId = spendingId else {
            return
        }
        spendingHistoryViewModel.deleteSingleSpendingHistory(spendingId: spendingId) { success in
            if success {
                isDeleted = true
                Log.debug("지출내역 단일 삭제 성공")
                showToastPopup = true

                if let spendingDetail = spendingCategoryViewModel.selectSpending {
                    spendingCategoryViewModel.dailyDetailSpendings.removeAll { $0.id == spendingDetail.id }
                    Log.debug("spendingCategoryViewModel에서 지출 내역 삭제")
                }

                self.presentationMode.wrappedValue.dismiss()

            } else {
                Log.debug("지출내역 단일 삭제 실패")
                isDeleted = false
            }
            isSelectedCategory = false
        }
    }
}
