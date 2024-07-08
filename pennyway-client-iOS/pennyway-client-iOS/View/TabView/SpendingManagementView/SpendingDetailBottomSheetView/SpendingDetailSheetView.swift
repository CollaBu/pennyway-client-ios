import SwiftUI

// MARK: - SpendingDetailSheetView

struct SpendingDetailSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showEditSpendingDetailView = false
    @State private var showAddSpendingHistoryView = false
    @State private var forceUpdate: Bool = false
    @Binding var clickDate: Date?

    @StateObject var viewModel: AddSpendingHistoryViewModel
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 4)
                    .platformTextColor(color: Color("Gray03"))
                    .padding(.top, 12)
                    
                HStack {
                    if let date = clickDate {
                        Text(Date.getFormattedDate(from: date))
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: Color("Gray07"))
                    }
                        
                    Spacer()
                    
                    if let clickDate = clickDate, getSpendingAmount(for: clickDate) == nil {
                        // 지출내역이 없을 경우 편집버튼 없음
                    } else {
                        Button(action: {
                            showEditSpendingDetailView = true
                        }, label: {
                            Image("icon_navigationbar_write_gray05")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                                
                        })
                        .padding(10)
                    }
                
                    Button(action: {
                        showAddSpendingHistoryView = true
                    }, label: {
                        Image("icon_navigation_add")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 34, height: 34)
                            
                    })
                }
                .padding(.leading, 20)
                .padding(.trailing, 17)
                .padding(.top, 12)
                
                if let clickDate = clickDate, getSpendingAmount(for: clickDate) == nil {
                    NoSpendingHistorySheetView()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                            if let clickDate = clickDate, let dailyTotalAmount = getSpendingAmount(for: clickDate) {
                                Text("-\(dailyTotalAmount)원")
                                    .font(.H1SemiboldFont())
                                    .platformTextColor(color: Color("Gray07"))
                                    .padding(.leading, 20)
                            }
                                
                            Spacer().frame(height: 32 * DynamicSizeFactor.factor())

                            ForEach(spendingHistoryViewModel.filteredSpendings(for: clickDate), id: \.id) { item in
                                let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""

                                CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                            }
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showEditSpendingDetailView) {
                NavigationAvailable {
                    EditSpendingDetailView(clickDate: $clickDate, spendingHistoryViewModel: spendingHistoryViewModel)
                }
            }
            .fullScreenCover(isPresented: $showAddSpendingHistoryView) {
                NavigationAvailable {
                    AddSpendingHistoryView(clickDate: $clickDate, selectedDate: $clickDate)
                }
            }
        }
        .onAppear {
            Log.debug("SpendingDetailSheetView appeared. Selected date: \(String(describing: clickDate))")
        }
        .onChange(of: clickDate) { _ in
            Log.debug("clickDate changed to: \(String(describing: clickDate))")
            forceUpdate.toggle()
        }
        .setTabBarVisibility(isHidden: true)
    }
    
    private func getSpendingAmount(for date: Date) -> Int? {
        let day = Calendar.current.component(.day, from: date)
        Log.debug(day)
        return spendingHistoryViewModel.dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }
    
//    private func filteredSpendings() -> [IndividualSpending] {
//        guard let clickDate = clickDate else {
//            return []
//        }
//        return spendingHistoryViewModel.dailyDetailSpendings.filter { spending in
//            if let spendDate = spendingHistoryViewModel.dateFromString(spending.spendAt) {
//                return Calendar.current.isDate(spendDate, inSameDayAs: clickDate)
//            }
//            return false
//        }
//    }
}
