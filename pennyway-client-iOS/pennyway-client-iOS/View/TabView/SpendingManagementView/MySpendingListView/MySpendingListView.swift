
import SwiftUI

// MARK: - MySpendingListView

struct MySpendingListView: View {
    var listItem: [MySpendingHistoryListItem]

    let categories = [
        ("icon_category_food_on", "식비"),
        ("icon_category_traffic_on", "교통"),
        ("icon_category_beauty_on", "미용/패션"),
        ("icon_category_market_on", "편의점/마트"),
        ("icon_category_education_on", "교육"),
        ("icon_category_life_on", "생활"),
        ("icon_category_health_on", "건강"),
        ("icon_category_hobby_on", "취미/여가"),
        ("icon_category_travel_on", "여행/숙박"),
        ("icon_category_drink_on", "술/유흥"),
        ("icon_category_event_on", "회비/경조사"),
        ("icon_category_plus_off", "추가하기")
    ]

    var body: some View {
        ZStack {
            VStack {
                SpendingWeekCalendarView()
                List {
                    if listItem.isEmpty {
                        NoSpendingHistoryView()
                    } else {
                        ForEach(listItem) { expense in
                            ExpenseRow(expense: expense, categories: categories)
                        }
                    }
                }
            }
        }
        .setTabBarVisibility(isHidden: true)
        .navigationBarColor(UIColor(named: "White01"), title: "소비 내역")
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
        }
    }
}

// MARK: - ExpenseRow

struct ExpenseRow: View {
    var expense: MySpendingHistoryListItem
    let categories: [(iconName: String, title: String)]
    var body: some View {
        HStack {
            Image("\(categoryIconName)")
                .resizable()
                .frame(width: 40, height: 40)
            Text(expense.category)
                .font(.B1SemiboldeFont())
                .platformTextColor(color: Color("Gray06"))
            Spacer()
            Text("\(expense.amount)원")
                .font(.B1SemiboldeFont())
                .platformTextColor(color: Color("Gray06"))
        }
    }

    private var categoryIconName: String {
        categories.first { $0.title == expense.category }?.iconName ?? "icon_category_plus_off"
    }
}

#Preview {
    MySpendingListView(listItem: [MySpendingHistoryListItem(category: "식비", amount: 32000, date: Date())])
}
