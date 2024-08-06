
import SwiftUI

struct EditProfilePopUpView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity, maxHeight: 120 * DynamicSizeFactor.factor())
                            .background(Color("White01"))
                            .cornerRadius(7)
                            .shadow(color: .black.opacity(0.06), radius: 7.29745, x: 0, y: 0)
                        
                        VStack(spacing: 12 * DynamicSizeFactor.factor()) {
                            
                            Spacer().frame(height: 8 * DynamicSizeFactor.factor())
                            
                            Text("앨범에서 사진 선택")
                                .font(.H4MediumFont())
                                .platformTextColor(color: Color("Gray05"))
                            
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(maxWidth: .infinity, maxHeight: 1)
                              .background(Color("Gray01"))
                            
                            Text("사진 촬영")
                                .font(.H4MediumFont())
                                .platformTextColor(color: Color("Gray05"))
                            
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(maxWidth: .infinity, maxHeight: 1)
                              .background(Color("Gray01"))
                            
                            Text("삭제")
                                .font(.H4MediumFont())
                                .platformTextColor(color: Color("Gray05"))
                            
                            
                            Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                            
                            
                        }
                        .padding(.horizontal, 18)
                        
                    }
                })
               
                
                Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity, maxHeight: 46 * DynamicSizeFactor.factor())
                            .background(Color("Gray05"))
                            .cornerRadius(4)
                        
                        Text("취소")
                            .platformTextColor(color: Color("White01"))
                            .font(.H4MediumFont())
                    }
                    
                })
            }
            .padding(.horizontal, 20)
            
        }
        .padding(.bottom, 34)
        
    }
}

#Preview {
    EditProfilePopUpView()
}
