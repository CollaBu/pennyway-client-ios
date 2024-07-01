
import SwiftUI

struct TargetAmountSettingView: View {
    @Binding var targetAmount: String?
    @StateObject var viewModel = TargetAmountSettingViewModel()
    @State private var navigateToCompleteTarget = false
    
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

                        if targetAmount != nil {
                            Text("\(String(describing: targetAmount))")
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
                                viewModel.validateForm()
                            }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomBottomButton(action: {
                    if viewModel.isFormValid {
                        navigateToCompleteTarget = true
                    }
                }, label: "확인", isFormValid: $viewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                
                NavigationLink(destination: TargetAmountSetCompleteView(viewModel: viewModel)) {}
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
    }
}

#Preview {
    TargetAmountSettingView(targetAmount: .constant(nil), viewModel: TargetAmountSettingViewModel())
}
