
import SwiftUI

// MARK: - EntryPoint

enum EntryPoint {
    case main
    case detailSheet
    case detailSpendingView
    case NoSpendingHistoryView
}

// MARK: - AddSpendingHistoryView

struct AddSpendingHistoryView: View {
    @StateObject var viewModel = AddSpendingHistoryViewModel()
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel

    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel
    @State var spendingId: Int = 0
    @State var newDetails = AddSpendingHistoryRequestDto(amount: 0, categoryId: 0, icon: "", spendAt: "", accountName: "", memo: "")
    @State private var navigateToAddSpendingCategory = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var clickDate: Date?
    @Binding var isPresented: Bool
    var entryPoint: EntryPoint

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    AddSpendingInputFormView(viewModel: viewModel, spendingHistoryViewModel: spendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, clickDate: $clickDate, entryPoint: entryPoint, spendingId: $spendingId)
                }
                Spacer()

                CustomBottomButton(action: {
                    if viewModel.isFormValid, let date = clickDate {
                        viewModel.clickDate = date
                        if entryPoint == .detailSpendingView { // 수정하기 api
                            viewModel.editSpendingHistoryApi(spendingId: spendingId) { success in
                                if success {
                                    self.presentationMode.wrappedValue.dismiss()

                                    Log.debug("지출 내역 수정 성공")
                                } else {
                                    Log.debug("지출 내역 수정 실패")
                                }
                            }

                        } else {
                            viewModel.addSpendingHistoryApi { success in
                                if success {
                                    navigateToAddSpendingCategory = true
                                    Log.debug("\(viewModel.clickDate)에 해당하는 지출내역 추가 성공")
                                }
                            }
                        }
                    }
                }, label: "확인", isFormValid: $viewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())

                NavigationLink(destination: AddSpendingCompleteView(viewModel: viewModel, clickDate: $clickDate, isPresented: $isPresented, entryPoint: entryPoint), isActive: $navigateToAddSpendingCategory) {}
                    .hidden()

                NavigationLink(
                    destination: AddSpendingCategoryView(viewModel: viewModel, spendingCategoryViewModel: SpendingCategoryViewModel(), entryPoint: .create), isActive: $viewModel.navigateToAddCategory) {}
                    .hidden()
            }
            .background(Color("White01"))
            .navigationBarColor(UIColor(named: "White01"), title: "소비 내역 추가하기")
            .edgesIgnoringSafeArea(.bottom)
            .setTabBarVisibility(isHidden: true)
            .navigationBarBackButtonHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationBackButton()
                            .padding(.leading, 5)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())

                    }.offset(x: -10)
                }
            }
            .dragBottomSheet(isPresented: $viewModel.isCategoryListViewPresented, minHeight: 524 * DynamicSizeFactor.factor(), maxHeight: 524 * DynamicSizeFactor.factor()) {
                SpendingCategoryListView(viewModel: viewModel, isPresented: $viewModel.isCategoryListViewPresented)
            }
            .bottomSheet(isPresented: $viewModel.isSelectDayViewPresented, maxHeight: 300 * DynamicSizeFactor.factor()) {
                SelectSpendingDayView(viewModel: viewModel, isPresented: $viewModel.isSelectDayViewPresented, clickDate: $clickDate)
            }
        }
    }
}

#Preview {
    AddSpendingHistoryView(spendingCategoryViewModel: SpendingCategoryViewModel(), spendingHistoryViewModel: SpendingHistoryViewModel(), clickDate: .constant(Date()), isPresented: .constant(true), entryPoint: .main)
}
