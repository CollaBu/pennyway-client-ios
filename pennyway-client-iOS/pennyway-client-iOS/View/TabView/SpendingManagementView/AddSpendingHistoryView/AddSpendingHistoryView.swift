
import SwiftUI

// MARK: - EntryPoint

enum EntryPoint {
    case main
    case detailSheet
}

// MARK: - AddSpendingHistoryView

struct AddSpendingHistoryView: View {
    @StateObject var viewModel = AddSpendingHistoryViewModel()
    @State private var navigateToAddSpendingCategory = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var clickDate: Date?
    @Binding var isPresented: Bool
    var entryPoint: EntryPoint

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    AddSpendingInputFormView(viewModel: viewModel, clickDate: $clickDate)
                }
                Spacer()

                CustomBottomButton(action: {
                    if viewModel.isFormValid, let date = clickDate {
                        viewModel.clickDate = date

                        viewModel.addSpendingHistoryApi { success in
                            if success {
                                navigateToAddSpendingCategory = true
                                Log.debug("\(viewModel.clickDate)에 해당하는 지출내역 추가 성공")
                            }
                        }
                    }
                }, label: "확인", isFormValid: $viewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())

                NavigationLink(destination: AddSpendingCompleteView(viewModel: viewModel, clickDate: $clickDate, isPresented: $isPresented, entryPoint: entryPoint), isActive: $navigateToAddSpendingCategory) {}

                NavigationLink(
                    destination: AddSpendingCategoryView(viewModel: viewModel, spendingCategoryViewModel: SpendingCategoryViewModel()), isActive: $viewModel.navigateToAddCategory) {}
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

                    }.offset(x: -10)
                }
            }
            .dragBottomSheet(isPresented: $viewModel.isCategoryListViewPresented) {
                SpendingCategoryListView(viewModel: viewModel, isPresented: $viewModel.isCategoryListViewPresented)
            }

            .bottomSheet(isPresented: $viewModel.isSelectDayViewPresented, maxHeight: 300 * DynamicSizeFactor.factor()) {
                SelectSpendingDayView(viewModel: viewModel, isPresented: $viewModel.isSelectDayViewPresented, clickDate: $clickDate)
            }
        }
    }
}

#Preview {
    AddSpendingHistoryView(clickDate: .constant(Date()), isPresented: .constant(true), entryPoint: .main)
}
