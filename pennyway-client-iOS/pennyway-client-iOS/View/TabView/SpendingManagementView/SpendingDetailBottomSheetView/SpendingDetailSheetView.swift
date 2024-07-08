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
                            }
                                
                            Spacer().frame(height: 32 * DynamicSizeFactor.factor())

//                            ForEach(filteredSpendings(), id: \.id) { detail in
//                                ExpenseRow(categoryIcon: SpendingListViewCategoryIconList(rawValue: detail.category.icon, category: detail.category.name, amount: detail.amount, memo: detail.memo)
//                                Spacer().frame(height: 12 * DynamicSizeFactor.factor())
//                            }
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showEditSpendingDetailView) {
                NavigationAvailable {
                    EditSpendingDetailView()
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
        .padding(.leading, 20)
    }
    
    private func getSpendingAmount(for date: Date) -> Int? {
        let day = Calendar.current.component(.day, from: date)
        Log.debug(day)
        return spendingHistoryViewModel.dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }

    private func filteredSpendings() -> [IndividualSpending] {
        guard let clickDate = clickDate else {
            return []
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // adjust the format as per your date string format
        
        return spendingHistoryViewModel.dailyDetailSpendings.filter { spending in
            if let spendDate = formatter.date(from: spending.spendAt) {
                return Calendar.current.isDate(spendDate, inSameDayAs: clickDate)
            }
            return false
        }
    }
}

// #Preview {
//     SpendingDetailSheetView(clickDate: $clickDate, viewModel: AddSpendingHistoryViewModel(), spendingHistoryViewModel: SpendingHistoryViewModel())
// }
