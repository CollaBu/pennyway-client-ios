import SwiftUI

struct DetailSpendingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isSelectedCategory: Bool = false
    @State var selectedItem: String? = nil
    @State var listArray: [String] = ["수정하기", "내역 삭제"]
    @State var navigateModifySpendingHistoryView = false
    @StateObject var spendingHistoryViewModel = SpendingHistoryViewModel()
    @Binding var clickDate: Date?
    @State private var forceUpdate: Bool = false

    @State var spendingId: Int = 0
    @State var newDetails = AddSpendingHistoryRequestDto(amount: 0, categoryId: 0, icon: "", spendAt: "", accountName: "", memo: "")

    init(clickDate: Binding<Date?>) {
        _clickDate = clickDate
        _spendingHistoryViewModel = StateObject(wrappedValue: SpendingHistoryViewModel())
    }

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 26 * DynamicSizeFactor.factor())

                if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                    MoreDetailSpendingView(clickDate: $clickDate, spendingHistoryViewModel: spendingHistoryViewModel)
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
        }
        .onChange(of: clickDate) { _ in
            loadDataForSelectedDate()
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
                                    navigateModifySpendingHistoryView = true
//                                    if item == "수정하기" {
//                                        editSpending()
//                                    }
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

//        NavigationLink(destination: AddSpendingHistoryView(clickDate: <#T##Binding<Date?>#>), isActive: $navigateModifySpendingHistoryView) {}
    }

//    private func editSpending() {
//        viewModel.editSpendingHistoryApi(spendingId: spendingId, dto: newDetails) { success in
//            if success {
//                Log.debug("지출 내역 수정 성공")
//            } else {
//                Log.error("지출 내역 수정 실패")
//            }
//        }
//    }

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
}

#Preview {
    DetailSpendingView(clickDate: .constant(Date()))
}
