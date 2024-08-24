import SwiftUI

// MARK: - EditSpendingDetailView

struct EditSpendingDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel

    @State var showingDeletePopUp = false
    @State var showingClosePopUp = false
    @State private var isItemSelected: Bool = false
    @State private var selectedIds: Set<Int> = []

    @Binding var clickDate: Date?
    @Binding var isDeleted: Bool

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    Spacer().frame(height: 20 * DynamicSizeFactor.factor())

                    HStack(spacing: 4 * DynamicSizeFactor.factor()) {
                        Button(action: {
                            toggleAllSelections()
                        }, label: {
                            Image(selectedIds.count == spendingHistoryViewModel.filteredSpendings(for: clickDate).count ? "icon_checkone_on_small" : "icon_checkone_off_small_gray03")
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())

                            Text("전체 선택")
                                .font(.B2MediumFont())
                                .platformTextColor(color: Color("Gray05"))
                                .padding(.vertical, 4)

                        })

                        .padding(.vertical, 4)
                        .padding(.trailing, 8)

                        Spacer()
                    }
                    .padding(.leading, 14)

                    Spacer().frame(height: 20 * DynamicSizeFactor.factor())

                    VStack(spacing: 0) {
                        ForEach(spendingHistoryViewModel.filteredSpendings(for: clickDate), id: \.id) { item in
                            let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""
                            ZStack(alignment: .leading) {
                                Button(action: {
                                    toggleSelection(for: item)
                                }) {
                                    Image(selectedIds.contains(item.id) ? "icon_checkone_on_small" : "icon_checkone_off_small_gray03")
                                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                        .aspectRatio(contentMode: .fill)
                                }
                                .buttonStyle(BasicButtonStyleUtil())

                                CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                    .padding(.leading, 13 * DynamicSizeFactor.factor())
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.leading, 14)

                            Spacer().frame(height: 12) // 동적 ui 적용하니 너무 커짐
                        }
                    }
                    .padding(.bottom, 103)
                }

                Spacer()

                CustomBottomButton(action: {
                    if isItemSelected {
                        showingDeletePopUp = true
                        Log.debug("showingDeletePopUp: \(showingDeletePopUp)")
                    }

                }, label: "삭제하기", isFormValid: $isItemSelected)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
            }
            .padding(.leading, 3)
            .padding(.trailing, 5)
            .edgesIgnoringSafeArea(.bottom)
            .setTabBarVisibility(isHidden: true)
            .navigationBarColor(UIColor(named: "White01"), title: "편집하기")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            showingClosePopUp = true
                            Log.debug("showingClosePopUp: \(showingClosePopUp)")
                        }, label: {
                            Image("icon_close")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36, height: 36)
                        })
                        .buttonStyle(BasicButtonStyleUtil())
                        .padding(.leading, 11)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                    }.offset(x: -10)
                }
            }

            if showingClosePopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showingClosePopUp,
                                titleLabel: "편집을 끝낼까요?",
                                subTitleLabel: "변경된 내용은 자동 저장돼요",
                                firstBtnAction: { self.showingClosePopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.presentationMode.wrappedValue.dismiss()
                                },
                                secondBtnLabel: "끝낼래요",
                                secondBtnColor: Color("Mint03")
                )
            }

            if showingDeletePopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showingDeletePopUp,
                                titleLabel: "\(selectedIds.count)개의 내역을 삭제할까요?",
                                subTitleLabel: "선택한 소비 내역이 사라져요",
                                firstBtnAction: { self.showingDeletePopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: { self.deleteSelectedItems() },
                                secondBtnLabel: "삭제하기",
                                secondBtnColor: Color("Red03")
                )
            }
        }
    }

    private func toggleAllSelections() { // 전체 선택시
        let allSelected = selectedIds.count == spendingHistoryViewModel.filteredSpendings(for: clickDate).count
        if allSelected {
            selectedIds.removeAll()
        } else {
            selectedIds = Set(spendingHistoryViewModel.filteredSpendings(for: clickDate).map { $0.id })
        }
        isItemSelected = !selectedIds.isEmpty
    }

    private func toggleSelection(for item: IndividualSpending) { // 개인 선택 시
        if selectedIds.contains(item.id) {
            selectedIds.remove(item.id)
        } else {
            selectedIds.insert(item.id)
        }
        isItemSelected = !selectedIds.isEmpty
    }

    private func deleteSelectedItems() {
        let spendingIds = Array(selectedIds)
        let totalSelectedCount = selectedIds.count
        let totalSpendingsCount = spendingHistoryViewModel.filteredSpendings(for: clickDate).count

        spendingHistoryViewModel.deleteSpendingHistory(spendingIds: spendingIds) { success in
            if success {
                Log.debug("지출내역 삭제 성공")
                selectedIds.removeAll()
                isItemSelected = false
                isDeleted = spendingHistoryViewModel.filteredSpendings(for: clickDate).isEmpty
                self.showingDeletePopUp = false

                // 내역을 전체 삭제한 경우에만 현재 창을 닫기
                if totalSelectedCount == totalSpendingsCount {
                    presentationMode.wrappedValue.dismiss()
                } 
            } else {
                Log.debug("지출내역 삭제 실패")
            }
        }
        isItemSelected = !selectedIds.isEmpty
    }
}

#Preview {
    EditSpendingDetailView(spendingHistoryViewModel: SpendingHistoryViewModel(), clickDate: .constant(Date()), isDeleted: .constant(true))
}
