
import SwiftUI

struct TargetAmountSettingView: View {
    @Binding var currentData: TargetAmount
    @StateObject var viewModel: TargetAmountSettingViewModel
    @StateObject var targetAmountViewModel = TargetAmountViewModel()
    @State private var navigateToCompleteTarget = false

    var entryPoint: TargetAmountEntryPoint
    
    init(currentData: Binding<TargetAmount>, entryPoint: TargetAmountEntryPoint) {
        _currentData = currentData
        _viewModel = StateObject(wrappedValue: TargetAmountSettingViewModel(currentData: currentData.wrappedValue))
        self.entryPoint = entryPoint
    }
    
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
                            targetAmountViewModel.deleteCurrentMonthTargetAmountApi()
                            // Delete 요청
                            
                        }, label: {
                            Text("나중에 할게요")
                                .font(.B2SemiboldFont())
                                .platformTextColor(color: Color("Gray03"))
                            
                        })
                        
                        Spacer()
                    }                  
                }
                
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                CustomBottomButton(action: {
                    if viewModel.isFormValid {
                        viewModel.editCurrentMonthTargetAmountApi { success in
                            if success {
                                Log.debug("목표 금액 수정 성공")
                                navigateToCompleteTarget = true
                            } else {
                                Log.debug("목표 금액 수정 실패")
                            }
                        }
                    }
                }, label: "확인", isFormValid: $viewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                
                NavigationLink(destination: TargetAmountSetCompleteView(viewModel: viewModel, entryPoint: entryPoint), isActive: $navigateToCompleteTarget) {}
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton(action: {})
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }.offset(x: -10)
            }
        }
        .onAppear {
            if entryPoint == .signUp {
                // 더미값 생성
                targetAmountViewModel.generateCurrentMonthDummyDataApi {
                    viewModel.currentData?.targetAmountDetail.id = targetAmountViewModel.generateTargetAmountId
                }
            }
        }
    }
}

#Preview {
    TargetAmountSettingView(currentData: .constant(TargetAmount(year: 0, month: 0, targetAmountDetail: AmountDetail(id: -1, amount: -1, isRead: false), totalSpending: 0, diffAmount: 0)), entryPoint: .signUp)
}
