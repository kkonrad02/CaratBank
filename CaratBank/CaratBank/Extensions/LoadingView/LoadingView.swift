import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack{
            VStack {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: Color("shadow"), radius: 10, y: 10)
        }
    }
}

#Preview {
    LoadingView()
}
