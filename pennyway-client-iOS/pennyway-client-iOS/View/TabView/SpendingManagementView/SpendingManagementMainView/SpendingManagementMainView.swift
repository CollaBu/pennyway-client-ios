
import SwiftUI

struct SpendingManagementMainView: View {
    @StateObject var spendingHistoryViewModel = SpendingHistoryViewModel()
    @StateObject var targetAmountViewModel = TargetAmountViewModel()
    @State private var navigateToAddSpendingHistory = false
    @State private var navigateToMySpendingList = false
    @State private var showSpendingDetailView = false
    @State private var showEditSpendingDetailView: Bool = false
    @State private var showDetailView = false // 지출내역 상세조회 view 임시 연결

    @State private var ishidden = false // 변수명 바꿀 필요

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

                    SpendingCalenderView(spendingHistoryViewModel: spendingHistoryViewModel, showSpendingDetailView: $showSpendingDetailView)
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                    Button(action: {
                        navigateToMySpendingList = true
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(height: 50 * DynamicSizeFactor.factor())
                                .cornerRadius(8)
                                .platformTextColor(color: Color("White01"))

                            HStack {
                                Text("나의 소비 내역")
                                    .font(.ButtonH4SemiboldFont())
                                    .platformTextColor(color: Color("Gray07"))
                                    .padding(.leading, 18)

                                Spacer()

                                Image("icon_arrow_front_small")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                    .padding(.trailing, 10)
                            }
                        }

                    })
                    .onTapGesture {
                        Log.debug("나의 소비 내역 click")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50 * DynamicSizeFactor.factor())
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 23 * DynamicSizeFactor.factor())
                }
            }

            .setTabBarVisibility(isHidden: ishidden)
            .onAppear {
                spendingHistoryViewModel.checkSpendingHistoryApi { _ in }
                targetAmountViewModel.getTargetAmountForDateApi { _ in }
            }
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

                        Button(action: {
                            showDetailView = true
                        }, label: {
                            Image("icon_navigationbar_bell")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5 * DynamicSizeFactor.factor())
                        })
                        .padding(.trailing, 5 * DynamicSizeFactor.factor())
                        .frame(width: 44, height: 44)
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

            NavigationLink(destination: AddSpendingHistoryView(), isActive: $navigateToAddSpendingHistory) {
                EmptyView()
            }

            NavigationLink(destination: MySpendingListView(spendingHistoryViewModel: SpendingHistoryViewModel()), isActive: $navigateToMySpendingList) {
                EmptyView()
            }

            NavigationLink(destination: DetailSpendingView(), isActive: $showDetailView) {
                EmptyView()
            }
        }
        .dragBottomSheet(isPresented: $showSpendingDetailView) {
            SpendingDetailSheetView()
                .zIndex(2)
        }
        .onChange(of: showSpendingDetailView) { isPresented in
            ishidden = isPresented
        }
        .id(ishidden)
    }
}

#Preview {
    SpendingManagementMainView()
}
