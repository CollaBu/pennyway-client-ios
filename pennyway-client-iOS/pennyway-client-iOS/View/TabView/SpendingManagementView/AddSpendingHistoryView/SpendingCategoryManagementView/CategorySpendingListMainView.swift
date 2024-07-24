import SwiftUI

struct CategorySpendingListMainView: View {
    @StateObject var spendingCategoryViewModel = SpendingCategoryViewModel()
    @State private var showToastPopup = false
    @State private var isDeleted = false

    var body: some View {
        ZStack {
            VStack {
                CategorySpendingListView(viewModel: spendingCategoryViewModel, showToastPopup: $showToastPopup, isDeleted: $isDeleted)
            }
            .overlay(
                Group {
                    if showToastPopup {
                        CustomToastView(message: "소비 내역을 삭제했어요")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                            .padding(.bottom, 34)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showToastPopup = false
                                    }
                                }
                            }
                    }
                }, alignment: .bottom
            )
        }
        .onChange(of: isDeleted) { newValue in
            if newValue {
                refreshView {
                    showToastPopup = true
                }
                isDeleted = false
            }
        }
    }

    private func refreshView(completion: @escaping () -> Void) {
        spendingCategoryViewModel.initPage()
        spendingCategoryViewModel.getCategorySpendingHistoryApi { success in
            if success {
                Log.debug("카테고리 지출내역 조회 성공")
            } else {
                Log.debug("카테고리 지출내역 조회 실패")
            }
            completion()
        }
    }
}

#Preview {
    CategorySpendingListMainView()
}
