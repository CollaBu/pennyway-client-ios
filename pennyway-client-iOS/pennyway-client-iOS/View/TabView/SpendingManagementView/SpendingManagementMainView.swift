
import SwiftUI

struct SpendingManagementMainView: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Gray01")
        appearance.shadowColor = .clear // 구분선 hide

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var body: some View {
        NavigationAvailable {
            ScrollView {
                VStack {
                    Spacer().frame(height: 16 * DynamicSizeFactor.factor())

                    SpendingCheckBoxView()
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                    CalenderView(month: Date())
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                    ZStack {
                        Rectangle()
                            .frame(height: 50 * DynamicSizeFactor.factor())
                            .cornerRadius(8)
                            .platformTextColor(color: Color("White01"))

                        HStack {
                            Text("나의 소비 내역")
                                .font(.ButtonH4SemiboldFont())
                                .platformTextColor(color: Color("Gray07"))
                                .padding(.leading, 18 * DynamicSizeFactor.factor())

                            Spacer()

                            Image("icon_arrow_front_small")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(.trailing, 10 * DynamicSizeFactor.factor())
                        }
                    }
                    .onTapGesture {
                        Log.debug("나의 소비 내역 click")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50 * DynamicSizeFactor.factor())
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 23 * DynamicSizeFactor.factor())
                }
            }
            .background(Color("Gray01"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("icon_logo_text")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 99 * DynamicSizeFactor.factor(), height: 18 * DynamicSizeFactor.factor())
                }

                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        Button(action: {}, label: {
                            Image("icon_navigation_add")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)

                        Button(action: {}, label: {
                            Image("icon_navigationbar_bell")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)
                    }
                    .offset(x: 10)
                }
            }
        }
    }
}

#Preview {
    SpendingManagementMainView()
}
