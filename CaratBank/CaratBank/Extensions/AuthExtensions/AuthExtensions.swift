import SwiftUI

struct AuthButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 25))
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: Color("shadow"), radius: 10, y: 10)
            .padding(.horizontal, 30)
    }
}

struct AuthSecondaryButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .font(.system(size: 25))
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(Color("main"))
            .cornerRadius(20)
            .shadow(color: Color("mainShadow"), radius: 10, y: 10)
            .padding(.horizontal, 30)
    }
}

struct AuthDivider: View {
    var body: some View {
        Divider()
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
    }
}

struct AuthLogo: View {
    var body: some View {
        Image("transparentFullLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
    }
}

public extension TextField{
    func authBetterField() -> some View{
        self
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding(.horizontal)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: Color("shadow"), radius: 10, y: 10)
            .padding(.horizontal, 30)
    }
}

public extension SecureField{
    func authBetterField() -> some View{
        self
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding(.horizontal)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: Color("shadow"), radius: 10, y: 10)
            .padding(.horizontal, 30)
    }
}
