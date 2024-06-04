import SwiftUI

struct PreviewModel: View {
    var text1: String
    var text2: String
    var disabled: Bool
    
    var body: some View {
        HStack{
            Text(text1)
                .foregroundColor(.black)
            
            Spacer()
            
            Text(text2)
                .foregroundColor(disabled ? .gray : Color("main"))
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color("shadow"), radius: 10, y: 10)
        .padding(.horizontal, 20)
    }
}
