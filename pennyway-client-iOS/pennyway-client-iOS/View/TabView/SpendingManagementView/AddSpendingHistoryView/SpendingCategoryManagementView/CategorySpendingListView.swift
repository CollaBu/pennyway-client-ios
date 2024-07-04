
import SwiftUI

// MARK: - CategorySpendingListView

struct CategorySpendingListView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    var category: SpendingCategoryData
    @State private var isClickMenu = false
    @State private var selectedMenu: String? = nil // 선택한 메뉴
    @State private var listArray: [String] = ["수정하기", "카테고리 삭제"]

    var body: some View {
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

                LazyVStack(spacing: 0) {
                    ForEach(groupedSpendings(), id: \.key) { date, spendings in
                        Spacer().frame(height: 10 * DynamicSizeFactor.factor())

                        Section(header: headerView(for: date)) {
                            Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                            ForEach(spendings, id: \.id) { item in
                                let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""
                                NavigationLink(destination: DetailSpendingView()) {
                                    ExpenseRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                }
                                .buttonStyle(PlainButtonStyle())

                                Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                            }
                            .onAppear {
                                Log.debug("spendings: \(spendings)")
                                Log.debug("group: \(groupedSpendings())")
                            }
                        }
                    }
                    Spacer().frame(height: 18 * DynamicSizeFactor.factor())
                }
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
                            isClickMenu = true
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

    private func headerView(for date: String) -> some View {
        Text(dateFormatter(from: date))
            .font(.B2MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .padding(.leading, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - ExpenseRow

    struct ExpenseRow: View {
        var categoryIcon: String
        var category: String
        var amount: Int
        var memo: String

        var body: some View {
            ZStack(alignment: .leading) {
                HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                    Image(categoryIcon)
                        .resizable()
                        .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())

                    VStack(alignment: .leading, spacing: 1) {
                        if memo.isEmpty {
                            Text(category)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Gray06"))
                                .multilineTextAlignment(.leading)
                        } else {
                            Text(category)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Gray06"))
                                .multilineTextAlignment(.leading)

                            Text(memo)
                                .font(.B3MediumFont())
                                .platformTextColor(color: Color("Gray04"))
                                .multilineTextAlignment(.leading)
                        }
                    }

                    Spacer()

                    Text("\(amount)원")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray06"))
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func groupedSpendings() -> [(key: String, values: [IndividualSpending])] {
        let grouped = Dictionary(grouping: viewModel.dailyDetailSpendings, by: { String($0.spendAt.prefix(10)) })
        let sortedGroup = grouped.map { (key: $0.key, values: $0.value) }
            .sorted { group1, group2 -> Bool in
                if let date1 = dateFromString(group1.key + " 00:00:00"), let date2 = dateFromString(group2.key + " 00:00:00") {
                    return date1 > date2
                }
                return false
            }

        return sortedGroup
    }

    /// 받아온 날짜가 string이기 때문에 날짜 문자열을 Date객체로 변환
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString)
    }

    private func dateFormatter(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMMM d일"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
        return dateString
    }
}
