
import SwiftUI

// MARK: - AddSpendingHistoryView

struct AddSpendingHistoryView: View {
    @StateObject var viewModel = AddSpendingHistoryViewModel()
    @State private var navigateToAddSpendingCategory = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var clickDate: Date?
//    @Binding var selectedDate: Date?

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    AddSpendingInputFormView(viewModel: viewModel)
                }
                Spacer()

                CustomBottomButton(action: {
                    if viewModel.isFormValid {
                        viewModel.addSpendingHistoryApi { success in
                            if success {
                                navigateToAddSpendingCategory = true
                            }
                        }
                    }

                }, label: "확인", isFormValid: $viewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())

                NavigationLink(destination: AddSpendingCompleteView(viewModel: viewModel), isActive: $navigateToAddSpendingCategory) {}

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
        }
//        .onAppear {
//            viewModel.selectedDate = selectedDate
//        }
        .dragBottomSheet(isPresented: $viewModel.isCategoryListViewPresented) {
            SpendingCategoryListView(viewModel: viewModel, isPresented: $viewModel.isCategoryListViewPresented)
        }

        .bottomSheet(isPresented: $viewModel.isSelectDayViewPresented, maxHeight: 300 * DynamicSizeFactor.factor()) {
            SelectSpendingDayView(isPresented: $viewModel.isSelectDayViewPresented, selectedDate: $viewModel.selectedDate)
        }
    }
}

#Preview {
    AddSpendingHistoryView(clickDate: .constant(Date()))
}
