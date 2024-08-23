import SwiftUI

// MARK: - SpendingManagementMainView

struct SpendingManagementMainView: View {
    @StateObject var spendingHistoryViewModel = SpendingHistoryViewModel()
    @StateObject var targetAmountViewModel = TargetAmountViewModel()
    @StateObject var notificationViewModel = ProfileNotificationViewModel()

    @State private var navigateToAddSpendingHistory = false
    @State private var navigateToMySpendingList = false
    @State private var navigateToMainAlarmView = false
    @State private var showSpendingDetailView = false
    @State private var showEditSpendingDetailView: Bool = false
    @State private var ishidden = false
    @State private var clickDate: Date? // 선택된 날짜 저장
    @State private var addSpendingClickDate: Date?
    @State private var addSpendingSelectedDate: Date?
    @State private var entryPoint: EntryPoint = .main
    @State private var showToastPopup = false

    var body: some View {
        NavigationAvailable {
            ScrollView {
                VStack {
                    Spacer().frame(height: 16 * DynamicSizeFactor.factor())

                    if !targetAmountViewModel.isHiddenSuggestionView {
                        RecentTargetAmountSuggestionView(viewModel: targetAmountViewModel, showToastPopup: $showToastPopup, isHidden: $targetAmountViewModel.isHiddenSuggestionView)

                        Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                    }

                    SpendingCheckBoxView(viewModel: targetAmountViewModel)
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                    SpendingCalenderView(spendingHistoryViewModel: spendingHistoryViewModel, showSpendingDetailView: $showSpendingDetailView, date: $spendingHistoryViewModel.currentDate, clickDate: $clickDate)
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                    CustomRectangleButton(action: {
                        navigateToMySpendingList = true
                        Log.debug(navigateToMySpendingList)
                    }, label: "나의 소비 내역")

                    Spacer().frame(height: 23 * DynamicSizeFactor.factor())
                }
                .analyzeEvent(SpendingEvents.spendingTabView)
            }
            .onAppear {
                spendingHistoryViewModel.checkSpendingHistoryApi { _ in }
                targetAmountViewModel.getTargetAmountForDateApi { _ in }
                notificationViewModel.checkUnReadNotificationsApi { _ in }
                Log.debug("hasUnread : \(notificationViewModel.hasUnread)")
            }
            .setTabBarVisibility(isHidden: ishidden)
            .navigationBarColor(UIColor(named: "Gray01"), title: "")
            .background(Color("Gray01"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("icon_logo_text")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 99 * DynamicSizeFactor.factor(), height: 18 * DynamicSizeFactor.factor())
                }

                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        Button(action: {
                            clickDate = Date() // +아이콘을 통해 들어간 경우 현재날짜 고정
                            entryPoint = .main
                            navigateToAddSpendingHistory = true
                        }, label: {
                            Image("icon_navigation_add_black")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                                .padding(5 * DynamicSizeFactor.factor())
                        })
                        .padding(.trailing, 5 * DynamicSizeFactor.factor())
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())

                        Button(action: {
                            navigateToMainAlarmView = true
                        }, label: {
                            Image(notificationViewModel.hasUnread ? "icon_navigationbar_bell_dot" : "icon_navigationbar_bell")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5 * DynamicSizeFactor.factor())
                        })
                        .padding(.trailing, 5 * DynamicSizeFactor.factor())
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())
                    }
                    .offset(x: 10)
                }
            }
            .overlay(
                Group {
                    if showToastPopup {
                        CustomToastView(message: "\(Date.month(from: Date()))월의 새로운 목표금액을 설정했어요")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                            .padding(.bottom, 10)
                    }
                }, alignment: .bottom
            )
            .background(
                NavigationLink(destination: MySpendingListView(spendingHistoryViewModel: SpendingHistoryViewModel(), currentMonth: .constant(Date()), clickDate: $clickDate), isActive: $navigateToMySpendingList) {
                    EmptyView()
                }
                .hidden()
            )

            if #available(iOS 15.0, *) {
            } else {
                NavigationLink(destination: MySpendingListView(spendingHistoryViewModel: SpendingHistoryViewModel(), currentMonth: .constant(Date()), clickDate: $clickDate), isActive: $navigateToMySpendingList) {
                    EmptyView()
                }
                .hidden()
            }

            NavigationLink(destination: AddSpendingHistoryView(spendingCategoryViewModel: SpendingCategoryViewModel(), spendingHistoryViewModel: spendingHistoryViewModel, spendingId: .constant(0), clickDate: $clickDate, isPresented: $navigateToAddSpendingHistory, isEditSuccess: .constant(false), entryPoint: .main), isActive: $navigateToAddSpendingHistory) {
                EmptyView()
            }
            .hidden()

            NavigationLink(destination: ProfileAlarmView(), isActive: $navigateToMainAlarmView) {
                EmptyView()
            }
            .hidden()
        }
        .dragBottomSheet(isPresented: $showSpendingDetailView, minHeight: bottomSheetMinHeight, maxHeight: 524 * DynamicSizeFactor.factor()) {
            SpendingDetailSheetView(clickDate: $clickDate, viewModel: AddSpendingHistoryViewModel(), spendingHistoryViewModel: spendingHistoryViewModel)
                .zIndex(2)
        }
        .onChange(of: showSpendingDetailView) { isPresented in
            ishidden = isPresented
            Log.debug("ishidden: \(isPresented)")
        }
        .onChange(of: navigateToAddSpendingHistory) { newValue in
            if newValue {
                addSpendingClickDate = clickDate
                addSpendingSelectedDate = clickDate ?? Date()
            }
        }
        .id(ishidden)
    }

    private var bottomSheetMinHeight: CGFloat {
        if let clickDate = clickDate {
            let filteredSpendings = spendingHistoryViewModel.filteredSpendings(for: clickDate)
            switch filteredSpendings.count {
            case 0 ..< 2: // 지출내역 0~1
                return 255 * DynamicSizeFactor.factor()
            case 2 ..< 6: // 지출내역 2~5
                return 412 * DynamicSizeFactor.factor()
            default: // 지출내역 5이상일 경우
                return 524 * DynamicSizeFactor.factor()
            }
        } else {
            return 255 * DynamicSizeFactor.factor()
        }
    }
}

#Preview {
    SpendingManagementMainView()
}
