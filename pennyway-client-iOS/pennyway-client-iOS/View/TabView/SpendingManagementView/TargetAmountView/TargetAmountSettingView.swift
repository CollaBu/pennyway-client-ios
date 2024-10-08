
import SwiftUI

struct TargetAmountSettingView: View {
    var currentData: TargetAmount
    @StateObject var viewModel = TargetAmountSettingViewModel()
    @StateObject var targetAmountViewModel = TargetAmountViewModel()
    @State private var navigateToCompleteTarget = false
    
    let profileInfoViewModel = UserAccountViewModel()
    
    @EnvironmentObject var authViewModel: AppViewModel
    var entryPoint: TargetAmountEntryPoint

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Group {
                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())
                    
                    Text("\(Date.getYearMonthFormattedDate(from: Date()))")
                        .font(.ButtonH4SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                    
                    Text("목표금액을 설정해 주세요")
                        .font(.H1SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46 * DynamicSizeFactor.factor())

                        if currentData.targetAmountDetail.amount != -1 && viewModel.inputTargetAmount.isEmpty {
                            Text("\(currentData.targetAmountDetail.amount)")
                                .platformTextColor(color: Color("Gray03"))
                                .padding(.leading, 13 * DynamicSizeFactor.factor())
                                .font(.H2SemiboldFont())
                        }
                        TextField("", text: $viewModel.inputTargetAmount)
                            .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                            .font(.H2SemiboldFont())
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.inputTargetAmount) { _ in
                                viewModel.inputTargetAmount = NumberFormatterUtil.formatStringToDecimalString(viewModel.inputTargetAmount)
                                Log.debug(viewModel.inputTargetAmount)
                                viewModel.validateForm()
                            }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                if entryPoint == .signUp {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            // Delete 요청
                            targetAmountViewModel.deleteCurrentMonthTargetAmountApi { success in
                                if success {
                                    Log.debug("목표 금액 삭제 성공")

                                    profileInfoViewModel.getUserProfileApi { success, _ in
                                        if success {
                                            AnalyticsManager.shared.trackEvent(TargetAmountEvents.postponeTargetAmount, additionalParams: nil)
                                            authViewModel.login()
                                        }
                                    }
                                }
                            }
                        }, label: {
                            Text("나중에 할게요")
                                .font(.B2SemiboldFont())
                                .platformTextColor(color: Color("Gray03"))
                            
                        })
                        .buttonStyle(PlainButtonStyle())
                        .buttonStyle(BasicButtonStyleUtil())

                        Spacer()
                    }
                }
                
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                CustomBottomButton(action: {
                    if viewModel.isFormValid {
                        viewModel.editCurrentMonthTargetAmountApi { success in
                            if success {
                                Log.debug("목표 금액 수정 성공")
                                
                                if entryPoint == .signUp {
                                    AnalyticsManager.shared.trackEvent(TargetAmountEvents.setInitialTargetAmount, additionalParams: nil)
                                }
                                
                                navigateToCompleteTarget = true
                            } else {
                                Log.debug("목표 금액 수정 실패")
                            }
                        }
                    }
                }, label: "확인", isFormValid: $viewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                
                NavigationLink(destination: TargetAmountSetCompleteView(viewModel: viewModel, entryPoint: entryPoint), isActive: $navigateToCompleteTarget) {}
                    .hidden()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if entryPoint == .afterLogin {
                    HStack {
                        NavigationBackButton()
                            .padding(.leading, 5)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }.offset(x: -10)
                } else {
                    Spacer().frame(height: 44)
                }
            }
        }
        .onAppear {
            if entryPoint == .signUp {
                // 더미값 생성
                targetAmountViewModel.generateCurrentMonthDummyDataApi { success in
                    if success {
                        Log.debug("더미데이터 목표 금액 생성 성공")
                        viewModel.currentData?.targetAmountDetail.id = targetAmountViewModel.generateTargetAmountId
                        
                        targetAmountViewModel.targetAmountData = viewModel.currentData
                    }
                }
            }
            viewModel.currentData = currentData
            
            if entryPoint == .signUp {
                AnalyticsManager.shared.trackEvent(TargetAmountEvents.targetAmountInitView, additionalParams: nil)
            } else if entryPoint == .afterLogin {
                AnalyticsManager.shared.trackEvent(TargetAmountEvents.targetAmountUpdateView, additionalParams: nil)
            }
        }
    }
}
