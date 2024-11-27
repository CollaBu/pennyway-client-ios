
import SwiftUI

struct TotalTargetAmountHeaderView: View {
    @State private var isClickMenu = false
    @State private var selectedMenu: String? = nil // 선택한 메뉴
    @State private var listArray: [String] = ["목표금액 수정", "초기화하기"]
    @State private var isnavigateToEditTargetView = false
    @Binding var showingDeletePopUp: Bool

    @ObservedObject var viewModel: TotalTargetAmountViewModel

    var body: some View {
        ZStack {
            Spacer().frame(height: 16 * DynamicSizeFactor.factor())

            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8 * DynamicSizeFactor.factor()) {
                    HStack {
                        Text("\(String(viewModel.currentData.year))년 \(viewModel.currentData.month)월 목표금액")
                            .font(.ButtonH4SemiboldFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        Button(action: {
                            isClickMenu.toggle()
                            selectedMenu = nil
                        }, label: {
                            Image("icon_navigationbar_kebabmenu")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())
                    }
                    
                    HStack(spacing: 0) {
                        Text(viewModel.currentData.targetAmountDetail.amount != -1 ? "\(viewModel.currentData.targetAmountDetail.amount)" : "-")
                            .font(.H1SemiboldFont())
                            .platformTextColor(color: Color("Gray07"))
                        Text(" 원")
                            .font(.H3SemiboldFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(1)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: 244 * DynamicSizeFactor.factor(), maxHeight: 0.5)
                    .background(Color("Gray02"))
                
                HStack {
                    HStack(spacing: 4) {
                        Image("icon_ current_spending")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        
                        Text("현재 소비 금액")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                    }
                    .padding(.leading, 14)
                    .padding(.top, 12)
                    
                    Spacer()
                    
                    Text("\(viewModel.currentData.totalSpending)원")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.trailing, 16)
                        .padding(.top, 12)
                }
                
                HStack {
                    HStack {
                        HStack(spacing: 4) {
                            Image("icon_remaining_amount")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            
                            Text("남은 금액")
                                .font(.B1MediumFont())
                                .platformTextColor(color: Color("Gray04"))
                        }
                        .padding(.leading, 14)
                        .padding(.bottom, 12)
                        
                        Spacer()
                        
                        Text(viewModel.currentData.targetAmountDetail.amount != -1 ? "\(viewModel.currentData.diffAmount <= 0 ? "" : "-")\(abs(viewModel.currentData.diffAmount))원" : "-원")
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: determineDiffAmountColor(for: viewModel.currentData.diffAmount))
                            .padding(.trailing, 16)
                            .padding(.bottom, 12)
                    }
                }
   
                NavigationLink(destination: TargetAmountSettingView(currentData: viewModel.currentData, entryPoint: .afterLogin), isActive: $isnavigateToEditTargetView) {}
                    .hidden()
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
            }
            .offset(y: 30 * DynamicSizeFactor.factor()),
            alignment: .topTrailing
        )
        .padding(.top, 18)
        .frame(maxWidth: .infinity)
        .frame(height: 177 * DynamicSizeFactor.factor())
        .background(
            RoundedCornerUtil(radius: 8, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                .fill(Color("White01"))
        )
        .padding(.horizontal, 20)
    }

    // Color 설정

    func determineDiffAmountColor(for diffAmount: Int64) -> Color {
        if viewModel.currentData.targetAmountDetail.amount != -1 {
            return diffAmount > 0 ? Color("Red03") : Color("Gray07")
        } else {
            return Color("Gray07")
        }
    }
}
