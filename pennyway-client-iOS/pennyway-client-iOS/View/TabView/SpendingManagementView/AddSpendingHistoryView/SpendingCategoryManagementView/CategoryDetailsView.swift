
import SwiftUI

// MARK: - CategoryDetailsView

struct CategoryDetailsView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    var category: SpendingCategoryData // 받아온 카테고리 정보
    @State private var isClickMenu = false
    @State private var selectedMenu: String? = nil // 선택한 메뉴
    @State private var listArray: [String] = ["수정하기", "카테고리 삭제"]
    @State private var showingPopUp = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())

                    Image("\(category.icon.rawValue.split(separator: "_").dropLast().joined(separator: "_"))")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor())

                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())

                    Text(category.name)
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer().frame(height: 4 * DynamicSizeFactor.factor())

                    Text("몇개의 소비 내역")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))

                    Spacer().frame(height: 28 * DynamicSizeFactor.factor())

                    Rectangle()
                        .platformTextColor(color: Color("Gray01"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 8 * DynamicSizeFactor.factor())

                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())

                    CategorySpendingListView(groupedSpendings: groupedSpendings(), onItemAppear: { item in
                        Log.debug("spendings: \(item)")
                    })
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
                if category.isCustom {
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
    }

    private func groupedSpendings() -> [(key: String, values: [IndividualSpending])] {
        let grouped = Dictionary(grouping: viewModel.dailyDetailSpendings, by: { String($0.spendAt.prefix(10)) })
        let sortedGroup = grouped.map { (key: $0.key, values: $0.value) }
            .sorted { group1, group2 -> Bool in
                if let date1 = DateFormatterUtil.dateFromString(group1.key + " 00:00:00"), let date2 = DateFormatterUtil.dateFromString(group2.key + " 00:00:00") {
                    return date1 > date2
                }
                return false
            }
        return sortedGroup
    }
}
