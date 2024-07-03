
import SwiftUI

// MARK: - SpendingCategoryGridView

struct SpendingCategoryGridView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            ScrollView {
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                VStack(alignment: .leading, spacing: 0) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8 * DynamicSizeFactor.factor()) {
                        ForEach(viewModel.systemCategories) { category in
                            NavigationLink(destination: CategorySpendingListView(viewModel: viewModel, category: category)) {
                                VStack(spacing: 0) {
                                    Image("\(category.icon.rawValue)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 52 * DynamicSizeFactor.factor(), height: 52 * DynamicSizeFactor.factor())
                                                        
                                    Text(category.name)
                                        .font(.B1MediumFont())
                                        .platformTextColor(color: Color("Gray07"))
                                }
                                .frame(width: 88 * DynamicSizeFactor.factor(), height: 92 * DynamicSizeFactor.factor())
                                .background(Color("White01"))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                                        
                    Spacer().frame(height: 20 * DynamicSizeFactor.factor())
                                        
                    Text("내가 추가한")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.horizontal, 20)
                                        
                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                        
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8 * DynamicSizeFactor.factor()) {
                        ForEach(viewModel.customCategories) { category in
                            NavigationLink(destination: CategorySpendingListView(viewModel: viewModel, category: category)) {
                                VStack(spacing: 0) {
                                    Image("\(category.icon.rawValue)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 52 * DynamicSizeFactor.factor(), height: 52 * DynamicSizeFactor.factor())
                                                        
                                    Text(category.name)
                                        .font(.B1MediumFont())
                                        .platformTextColor(color: Color("Gray07"))
                                }
                                .frame(width: 88 * DynamicSizeFactor.factor(), height: 92 * DynamicSizeFactor.factor())
                                .background(Color("White01"))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                                        
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Gray01"))
            .navigationBarColor(UIColor(named: "Gray01"), title: "카테고리")
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
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
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        Button(action: {}, label: {
                            Image("icon_navigation_add_black")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                                .padding(5 * DynamicSizeFactor.factor())
                        })
                        .padding(.trailing, 5 * DynamicSizeFactor.factor())
                        .frame(width: 44, height: 44)
                    }.offset(x: 10)
                }
            }
        }
    }
}

#Preview {
    SpendingCategoryGridView(viewModel: AddSpendingHistoryViewModel())
}
