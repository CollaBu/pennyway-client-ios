import SwiftUI

// MARK: - SpendingDetailSheetView

struct SpendingDetailSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showEditSpendingDetailView = false
    @State private var showAddSpendingHistoryView = false
    @State private var forceUpdate: Bool = false
    @State private var isDeleted: Bool = false
    @State private var showDetailSpendingView = false
    @State private var selectedSpendingId: Int? = nil

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
                        
                    if let clickDate = clickDate, SpendingHistoryUtil.getSpendingAmount(for: clickDate, using: Calendar.current, from: spendingHistoryViewModel) == nil || isDeleted {
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
                        .buttonStyle(BasicButtonStyleUtil())
                    }
                        
                    Button(action: {
                        showAddSpendingHistoryView = true
                    }, label: {
                        Image("icon_navigation_add")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 34, height: 34)
                            
                    })
                    .buttonStyle(BasicButtonStyleUtil())
                }
                .padding(.leading, 20)
                .padding(.trailing, 17)
                .padding(.top, 12)
                    
                if let clickDate = clickDate, SpendingHistoryUtil.getSpendingAmount(for: clickDate, using: Calendar.current, from: spendingHistoryViewModel) == nil || isDeleted {
                    NoSpendingHistorySheetView()
                        .analyzeEvent(SpendingEvents.spendingListView, additionalParams: [AnalyticsConstants.Parameter.date: clickDate])
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                            if let clickDate = clickDate, let dailyTotalAmount = SpendingHistoryUtil.getSpendingAmount(for: clickDate, using: Calendar.current, from: spendingHistoryViewModel) {
                                Text("-\(dailyTotalAmount)원")
                                    .font(.H1SemiboldFont())
                                    .platformTextColor(color: Color("Gray07"))
                                    .padding(.leading, 20)
                            }
                                
                            Spacer().frame(height: 32 * DynamicSizeFactor.factor())
                                
                            ForEach(spendingHistoryViewModel.filteredSpendings(for: clickDate), id: \.id) { item in
                                let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""
                                    
                                Button(action: {
                                    selectedSpendingId = item.id
                                    showDetailSpendingView = true
                                    Log.debug("selectedSpendingId: \(selectedSpendingId)")
                                }, label: {
                                    CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                        .contentShape(Rectangle())
                                })
                                .buttonStyle(PlainButtonStyle())
                                .buttonStyle(BasicButtonStyleUtil())

                                Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                            }
                        }
                    }
                    .analyzeEvent(SpendingEvents.spendingListView, additionalParams: [AnalyticsConstants.Parameter.date: clickDate])
                }
            }
            .fullScreenCover(isPresented: $showEditSpendingDetailView) {
                NavigationAvailable {
                    EditSpendingDetailView(spendingHistoryViewModel: spendingHistoryViewModel, clickDate: $clickDate, isDeleted: $isDeleted)
                }
            }
            .fullScreenCover(isPresented: $showAddSpendingHistoryView) {
                NavigationAvailable {
                    AddSpendingHistoryView(spendingCategoryViewModel: SpendingCategoryViewModel(), spendingHistoryViewModel: spendingHistoryViewModel, clickDate: $clickDate, isPresented: $showAddSpendingHistoryView, entryPoint: .detailSheet)
                }
            }
            .fullScreenCover(isPresented: $showDetailSpendingView) {
                NavigationAvailable { DetailSpendingView(clickDate: $clickDate, spendingId: $selectedSpendingId, isDeleted: $isDeleted, showToastPopup: .constant(false), spendingCategoryViewModel: SpendingCategoryViewModel())
                }
            }
        }
        .onAppear {
            Log.debug("SpendingDetailSheetView appeared. Selected date: \(String(describing: clickDate))")
            getDailyHistoryData()
        }
        .onChange(of: isDeleted) { newValue in
            if newValue {
                Log.debug("삭제됨")
                getDailyHistoryData()
                isDeleted = false
            }
        }
        .onChange(of: showAddSpendingHistoryView) { _ in
            getDailyHistoryData()
        }
        .setTabBarVisibility(isHidden: true)
    }
    
    private func getDailyHistoryData() {
        Log.debug("getDailyHistoryData 호출됨")
        spendingHistoryViewModel.checkSpendingHistoryApi { success in
            if success {
                Log.debug("뷰 새로고침 성공")
            } else {
                Log.debug("뷰 새로고침 실패")
            }
        }
    }
}
