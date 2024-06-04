import SwiftUI

struct NavBarItem: Hashable{
    var icon: String
    var title: String
}

struct NavBarView: View {
    @Binding var selectedIndex: Int
    @State private var items: [NavBarItem] = [
        NavBarItem(icon: "house", title: "Pulpit"),
        NavBarItem(icon: "creditcard", title: "Płatności"),
        NavBarItem(icon: "gear", title: "Ustawienia")
    ]
    
    var body: some View {
        HStack{
            ForEach(Array(items.enumerated()), id: \.element){ index, item in
                let isSelected = selectedIndex == index
                
                Button(action: {
                    self.selectedIndex = index
                }, label: {
                    VStack{
                        Image(systemName: item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                        Text(item.title)
                            .font(.system(size: 15))
                    }
                    .foregroundColor(isSelected ? Color("main") : .gray)
                    .frame(maxWidth: .infinity)
                })
            }
        }
        .padding(.vertical)
        .background(.white)
        .shadow(color: Color("shadow"), radius: 10, y: -10)
    }
}

#Preview {
    NavBarView(selectedIndex: .constant(0))
}
