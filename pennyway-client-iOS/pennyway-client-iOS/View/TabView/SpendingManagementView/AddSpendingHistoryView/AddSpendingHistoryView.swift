
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
    @StateObject private var keyboardHandler = KeyboardHandlerManager()
    @StateObject var viewModel = AddSpendingHistoryViewModel()
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel

    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel
    @Binding var spendingId: Int?
    @State var newDetails = AddSpendingHistoryRequestDto(amount: 0, categoryId: 0, icon: "", spendAt: "", accountName: "", memo: "")

    @State private var navigateToAddSpendingComplete = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var clickDate: Date?
    @Binding var isPresented: Bool
    @Binding var isEditSuccess: Bool
    @Binding var isAddSpendingData: Bool

    var entryPoint: EntryPoint

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    AddSpendingInputFormView(viewModel: viewModel, spendingHistoryViewModel: spendingHistoryViewModel, spendingCategoryViewModel: spendingCategoryViewModel, clickDate: $clickDate, entryPoint: entryPoint, spendingId: $spendingId)
                }

                Spacer()

                CustomBottomButton(action: { handleConfirmBtnTap() }, label: "확인", isFormValid: $viewModel.isFormValid)
                    .padding(.bottom, keyboardHandler.keyboardHeight > 0 ? nil : 34 * DynamicSizeFactor.factor())
            }
            .padding(.bottom, keyboardHandler.keyboardHeight)
            .animation(keyboardHandler.keyboardHeight > 0 ? .easeOut(duration: 0.3) : nil)

            NavigationLink(destination: AddSpendingCompleteView(viewModel: viewModel, clickDate: $clickDate, isPresented: $isPresented, isAddSpendingData: $isAddSpendingData, entryPoint: entryPoint), isActive: $navigateToAddSpendingComplete, label: { EmptyView() })
                .hidden()

            NavigationLink(destination: AddSpendingCategoryView(viewModel: viewModel, spendingCategoryViewModel: spendingCategoryViewModel, entryPoint: .create), isActive: $viewModel.navigateToAddCategory, label: { EmptyView() })
                .hidden()
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color("White01"))
        .navigationBarColor(UIColor(named: "White01"), title: "소비 내역 추가하기")
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
        .onChange(of: SheetState(isCategoryListViewPresented: viewModel.isCategoryListViewPresented,
                                 isSelectDayViewPresented: viewModel.isSelectDayViewPresented))
        { state in
            if !state.isCategoryListViewPresented && !state.isSelectDayViewPresented {
                analyzeEvent()
            }
        }
        .onAppear { analyzeEvent() }

        .dragBottomSheet(isPresented: $viewModel.isCategoryListViewPresented, minHeight: 524 * DynamicSizeFactor.factor(), maxHeight: 524 * DynamicSizeFactor.factor()) {
            SpendingCategoryListView(viewModel: viewModel, isPresented: $viewModel.isCategoryListViewPresented)
        }
        .bottomSheet(isPresented: $viewModel.isSelectDayViewPresented, maxHeight: 300 * DynamicSizeFactor.factor()) {
            SelectSpendingDayView(viewModel: viewModel, isPresented: $viewModel.isSelectDayViewPresented, clickDate: $clickDate)
        }
        .onAppear {
            Log.debug("AddSpendingHistoryView에서 spendingId: \(spendingId)")
        }
    }

    private func handleConfirmBtnTap() {
        guard viewModel.isFormValid else {
            Log.debug("폼이 유효하지 않습니다.")
            return
        }

        if let date = clickDate {
            viewModel.clickDate = date
            if isAddSpendingMode() {
                addSpendingHistory()
            } else {
                editSpendingHistory(spendingDetailViewUpdated: false)
            }
        } else {
            editSpendingHistory(spendingDetailViewUpdated: true)
        }
    }

    private func isAddSpendingMode() -> Bool {
        return entryPoint == .main || entryPoint == .detailSheet || entryPoint == .NoSpendingHistoryView
    }

    private func addSpendingHistory() {
        Log.debug("추가하기")

        viewModel.addSpendingHistoryApi { success in
            if success {
                self.navigateToAddSpendingComplete = true
                Log.debug("\(viewModel.clickDate)에 해당하는 지출내역 추가 성공")
            }
        }
    }

    private func editSpendingHistory(spendingDetailViewUpdated: Bool) {
        guard let spendingId = spendingId else {
            Log.debug("spendingId가 nil입니다.")
            return
        }
        Log.debug("수정하기")

        viewModel.editSpendingHistoryApi(spendingId: spendingId) { response in

            switch response {
            case let .success(data):
                self.presentationMode.wrappedValue.dismiss()
                self.spendingHistoryViewModel.spendingDetailViewUpdated = spendingDetailViewUpdated

                self.isEditSuccess = true

                spendingCategoryViewModel.updateSpending(dto: data!)

            case let .failure(error):
                Log.debug("error")
            }
        }
    }

    private func analyzeEvent() {
        if entryPoint == .detailSpendingView {
            AnalyticsManager.shared.trackEvent(SpendingEvents.spendingUpdateView, additionalParams: nil)
        } else {
            AnalyticsManager.shared.trackEvent(SpendingEvents.spendingAddView, additionalParams: nil)
        }
    }
}

// MARK: - SheetState

struct SheetState: Equatable {
    let isCategoryListViewPresented: Bool
    let isSelectDayViewPresented: Bool
}
