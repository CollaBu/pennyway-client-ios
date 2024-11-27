import SwiftUI

// MARK: - TotalTargetAmountView

struct TotalTargetAmountView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = TotalTargetAmountViewModel()
    @State private var isnavigateToPastSpendingView = false
    @State var showingDeletePopUp = false
    @State private var showToastPopup = false

    let hearderViewHeight = 173 * DynamicSizeFactor.factor()
    @State private var initialOffset: CGFloat = 0 // 초기 오프셋 값 저장
    @State private var adjustedOffset: CGFloat = 0 // (현재 오프셋 값 - 초기 오프셋 값) 계산
    @State private var updateCount = 0 // 업데이트 횟수를 추적하는 변수

    var body: some View {
        ZStack {
            ScrollView {
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())

                GeometryReader { geometry in
                    let offset = geometry.frame(in: .global).minY
//                    setOffset(offset: offset)

                    TotalTargetAmountHeaderView(showingDeletePopUp: $showingDeletePopUp, viewModel: viewModel)
                        .background(Color("Gray01"))
                        .offset(y: adjustedOffset > 0 ? -adjustedOffset : 0)

                    TotalTargetAmountContentView(viewModel: viewModel, isnavigateToPastSpendingView: $isnavigateToPastSpendingView)
                        .offset(y: adjustedOffset > 0 ? (hearderViewHeight - adjustedOffset) : hearderViewHeight)
                }
                .frame(height: ScreenUtil.calculateAvailableHeight() + calculateAdditionalHeight())
            }
            .overlay(
                Group {
                    if showToastPopup {
                        CustomToastView(message: "목표금액이 초기화되었어요")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                            .padding(.bottom, 34 * DynamicSizeFactor.factor())
                    }
                }, alignment: .bottom
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Gray01"))
            .navigationBarColor(UIColor(named: "Gray01"), title: "")
            .edgesIgnoringSafeArea(.bottom)
            .setTabBarVisibility(isHidden: true)
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
                        .buttonStyle(BasicButtonStyleUtil())

                    }.offset(x: -10)
                }
            }

            if showingDeletePopUp {
                CustomPopUpView(showingPopUp: $showingDeletePopUp,
                                titleLabel: "목표금액을 초기화할까요?",
                                subTitleLabel: "이번 달 목표금액이 사라져요",
                                firstBtnAction: { self.showingDeletePopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    deleteTargetAmountApi()
                                },
                                secondBtnLabel: "초기화하기",
                                secondBtnColor: Color("Mint03"))
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

    private func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            if updateCount < 4 {
                updateCount += 1
            } else if initialOffset == 0 {
                initialOffset = offset
            }

            adjustedOffset = offset - initialOffset
        }
        return EmptyView()
    }

    /// viewModel.targetAmounts의 개수에 따라 추가 높이를 계산하는 함수
    private func calculateAdditionalHeight() -> CGFloat {
        let count = viewModel.targetAmounts.count
        if count >= 2 {
            return CGFloat(min(count - 1, 5)) * 60 * DynamicSizeFactor.factor()
        } else {
            return 0
        }
    }
}

#Preview {
    TotalTargetAmountView()
}
