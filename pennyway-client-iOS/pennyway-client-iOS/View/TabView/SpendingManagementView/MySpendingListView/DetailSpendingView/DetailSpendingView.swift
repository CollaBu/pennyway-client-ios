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
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 26 * DynamicSizeFactor.factor())

                if let spendingDetail = spendingCategoryViewModel.dailyDetailSpendings.first { // 지출 카테고리 리스트로 조회시
                    MoreDetailSpendingView(clickDate: $clickDate, spendingHistoryViewModel: spendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, spendingId: spendingDetail.id)
                } else {
                    if let spendingId = spendingId {
                        MoreDetailSpendingView(clickDate: $clickDate, spendingHistoryViewModel: spendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, spendingId: spendingId)
                    }
                }
            }
        }
        .padding(.bottom, 34 * DynamicSizeFactor.factor())
        .padding(.horizontal, 20)
        .setTabBarVisibility(isHidden: true)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarColor(UIColor(named: "White01"), title: "")
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
                HStack(spacing: 0) {
                    Button(action: {
                        isSelectedCategory.toggle()
                        Log.debug("isSelectedCategory: \(isSelectedCategory)")
                    }, label: {
                        Image("icon_navigationbar_kebabmenu")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            .padding(5)
                    })
                    .buttonStyle(PlainButtonStyle())
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
            Log.debug("DetailSpendingView: \(spendingId)")
        }
        .overlay(
            VStack(alignment: .center) {
                Spacer().frame(height: 6 * DynamicSizeFactor.factor())
                if isSelectedCategory {
                    ZStack {
                        Rectangle()
                            .cornerRadius(4)
                            .platformTextColor(color: Color("White01"))
                            .padding(.vertical, 8)
                            .shadow(color: .black.opacity(0.06), radius: 7, x: 0, y: 0)

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(listArray, id: \.self) { item in
                                Button(action: {
                                    self.selectedItem = item
                                    if item == "수정하기" {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 버튼 액션 보이기 위해 임시로 0.2초 지연 후 뷰 넘어가도록 설정
                                            navigateModifySpendingHistoryView = true
                                        }
                                    } else if item == "내역 삭제" {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 버튼 액션 보이기 위해 임시로 0.2초 지연 후 뷰 넘어가도록 설정
                                            deleteSingleSpending()
                                        }
                                    }
                                }, label: {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .platformTextColor(color: .clear)
                                            .frame(width: 120, height: 22)
                                            .cornerRadius(3)

                                        Text(item)
                                            .font(.B2MediumFont())
                                            .multilineTextAlignment(.leading)
                                            .platformTextColor(color: selectedItem == item ? Color("Gray05") : Color("Gray04"))
                                            .padding(.leading, 3)
                                    }
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 9)
                                    .background(selectedItem == item ? Color("Gray02") : Color("White01"))

                                })

                                .buttonStyle(PlainButtonStyle())
                            }
                            .cornerRadius(3)
                        }
                        .padding(.vertical, 12 * DynamicSizeFactor.factor())
                        .zIndex(5)
                    }
                    .frame(width: 125 * DynamicSizeFactor.factor(), height: 47 * DynamicSizeFactor.factor())
                    .zIndex(5)
                    .offset(x: 175 * DynamicSizeFactor.factor(), y: 13 * DynamicSizeFactor.factor())
                }
            }, alignment: .topLeading)

        NavigationLink(destination: AddSpendingHistoryView(spendingHistoryViewModel: spendingHistoryViewModel, clickDate: $clickDate, isPresented: .constant(false), entryPoint: .detailSpendingView), isActive: $navigateModifySpendingHistoryView) {}
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
                Log.debug("지출내역 단일 삭제 성공")
                self.presentationMode.wrappedValue.dismiss()
                showToastPopup = true
                isDeleted = true
            } else {
                Log.debug("지출내역 단일 삭제 실패")
            }
            isSelectedCategory = false
        }
    }

    private func getSpendingDetail(by id: Int) -> IndividualSpending? {
        return spendingHistoryViewModel.getSpendingDetail(by: id) ?? spendingCategoryViewModel.getSpendingDetail(by: id)
    }
}
