
import SwiftUI

struct TargetAmountSetCompleteView: View {
    @ObservedObject var viewModel: TargetAmountSettingViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Group {
                    Spacer().frame(height: 65 * DynamicSizeFactor.factor())
                    
                    Image("icon_illust_goal setting")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160 * DynamicSizeFactor.factor(), height: 160 * DynamicSizeFactor.factor())
                    
                    Text("목표금액이 설정되었어요")
                        .font(.H1SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    
                    Text("\(Date.month(from: Date()))월 목표금액 \(viewModel.inputTargetAmount)원")
                        .font(.H4MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomBottomButton(action: {
//                    goToSecondView()
                }, label: "확인", isFormValid: .constant(true))
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
    
//    private func goToSecondView() {
//        if let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
//            navigationController.popToRootViewController(animated: true)
//            if let rootView = navigationController.viewControllers.first as? TotalTargetAmountView {
//                rootView.navigateToEditTarget = true
//            }
//        }
//    }
}

#Preview {
    TargetAmountSetCompleteView(viewModel: TargetAmountSettingViewModel())
}
