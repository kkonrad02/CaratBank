import SwiftUI

struct HistoryModel: View {
    var item: HistoryItem
    
    var body: some View {
        HStack{
            Image(systemName: "creditcard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .padding(7)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: Color("shadow"), radius: 10)
                .padding(.leading)
            
            VStack(alignment: .leading){
                Text(item.title)
                
                Text(item.date)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .frame(height: 30)
            
            Spacer()
            
            HStack {
                Text("\(item.amount) \(item.currency)")
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal)
        .shadow(color: Color("shadow"), radius: 10)
    }
}

struct HistoryItem: Hashable{
    var title: String
    var date: String
    var amount: String
    var currency: String
}
