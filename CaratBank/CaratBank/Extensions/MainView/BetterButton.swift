import SwiftUI

struct BetterButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("main"))
            .cornerRadius(10)
            .shadow(color: Color("mainShadow"), radius: 10, y: 5)
            .padding(.horizontal)
    }
}

struct BetterSecondaryButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(Color("main"))
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.white)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("main"), lineWidth: 2)
            }
            .cornerRadius(10)
            .shadow(color: Color("mainShadow"), radius: 10, y: 5)
            .padding(.horizontal)
    }
}

struct BetterWarningButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("warningRed"))
            .cornerRadius(10)
            .shadow(color: Color("warningRedShadow"), radius: 10, y: 5)
            .padding(.horizontal)
    }
}
