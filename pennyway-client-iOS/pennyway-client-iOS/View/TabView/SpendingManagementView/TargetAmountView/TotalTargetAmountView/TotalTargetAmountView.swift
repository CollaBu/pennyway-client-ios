import SwiftUI

// MARK: - TotalTargetAmountView

struct TotalTargetAmountView: View {
    @StateObject var viewModel = TotalTargetAmountViewModel()
    @State private var isClickMenu = false
    @State private var selectedMenu: String? = nil // 선택한 메뉴
    @State private var listArray: [String] = ["목표금액 수정", "초기화하기"]
    @State private var isnavigateToEditTargetView = false
    @State private var isnavigateToPastSpendingView = false
    @State private var showingDeletePopUp = false
    @State private var showToastPopup = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    TotalTargetAmountHeaderView(viewModel: viewModel)

                    TotalTargetAmountContentView(viewModel: viewModel, isnavigateToPastSpendingView: $isnavigateToPastSpendingView)

                    Spacer().frame(height: 29 * DynamicSizeFactor.factor())
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
                                if item == "목표금액 수정" {
                                    isnavigateToEditTargetView = true
                                } else {
                                    showingDeletePopUp = true
                                }
                                Log.debug("Selected item: \(item)")
                            }
                        ).padding(.trailing, 20)
                    }
                }, alignment: .topTrailing
            )
            .overlay(
                Group {
                    if showToastPopup {
                        CustomToastView(message: "목표금액이 초기화되었어요")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                            .padding(.bottom, 34)
                    }
                }, alignment: .bottom
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Gray01"))
            .navigationBarColor(UIColor(named: "Mint03"), title: "")
            .edgesIgnoringSafeArea(.bottom)
            .setTabBarVisibility(isHidden: true)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            NavigationUtil.popToRootView()
                        }, label: {
                            Image("icon_arrow_back_white")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 34, height: 34)
                                .padding(5)
                        })
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .buttonStyle(BasicButtonStyleUtil())

                    }.offset(x: -10)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        Button(action: {
                            isClickMenu.toggle()
                            selectedMenu = nil
                        }, label: {
                            Image("icon_navigationbar_kebabmenu_white")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())
                    }
                    .offset(x: 10)
                }
            }

            if showingDeletePopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showingDeletePopUp,
                                titleLabel: "목표금액을 초기화할까요?",
                                subTitleLabel: "이번 달 목표금액이 사라져요",
                                firstBtnAction: { self.showingDeletePopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    deleteTargetAmountApi()
                                },
                                secondBtnLabel: "초기화하기",
                                secondBtnColor: Color("Mint03")
                )
                .analyzeEvent(TargetAmountEvents.targetAmountResetPopUp)
            }
        }
        .onAppear {
            viewModel.getTotalTargetAmountApi { _ in
            }
        }
        .analyzeEvent(TargetAmountEvents.targetAmountView)
        .onChange(of: showingDeletePopUp, perform: { _ in
            if !showingDeletePopUp {
                AnalyticsManager.shared.trackEvent(TargetAmountEvents.targetAmountView, additionalParams: nil)
            }
        })

        NavigationLink(destination: TargetAmountSettingView(currentData: $viewModel.currentData, entryPoint: .afterLogin), isActive: $isnavigateToEditTargetView) {}
            .hidden()

        NavigationLink(destination: PastSpendingListView(viewModel: viewModel), isActive: $isnavigateToPastSpendingView) {}
            .hidden()
    }

    private func deleteTargetAmountApi() {
        viewModel.deleteCurrentMonthTargetAmountApi { success in
            if success {
                self.showingDeletePopUp = false
                showToastPopup = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToastPopup = false
                }
                viewModel.getTotalTargetAmountApi { _ in
                }
            } else {
                Log.fault("목표 금액 초기화 실패")
            }
        }
    }
}

#Preview {
    TotalTargetAmountView()
}
