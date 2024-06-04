import SwiftUI

struct WithdrawView: View {
    @Binding var loggedUser: User?
    @Binding var requireRefresh: Bool
    
    @State private var amountInput: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    @State private var auth = Authenticator()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            if let user = loggedUser{
                GeometryReader{ geometry in
                    VStack {
                        VStack{
                            Text("Wpłać pieniądze")
                                .font(.system(size: 40))
                                .bold()
                                .padding(.top, 30)
                                .foregroundColor(.white)
                        }
                        .frame(height: geometry.size.height * 0.25)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [Color("gradient5"), Color("gradient6")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        VStack{
                            VStack(alignment: .leading) {
                                Text("Konto Główne - \(user.name)")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("darkShadow"))
                                    .padding(.horizontal, 40)
                                TextField("Kwota", text: $amountInput)
                                    .authBetterField()
                                    .keyboardType(.numbersAndPunctuation)
                            }.padding(.top, 20)
                            
                            
                            Button(action: {
                                auth.withdrawMoney(username: user.username, amount: amountInput) { error in
                                    if let error = error{
                                        showAlert(message: error)
                                    }else{
                                        showAlert(message: "Wpłacono pieniądze!")
                                        self.requireRefresh = true
                                        self.dismiss()
                                    }
                                }
                            }, label: {
                                BetterButton(title: "Wpłać")
                                    .padding(.top)
                            })
                            .alert(alertMessage, isPresented: $showingAlert){
                                Button("Okej", role: .cancel){}
                            }
                            
                            Spacer()
                        }
                        .frame(height: geometry.size.height * 0.75)
                    }
                    .background(Color("background"))
                }
            }else{
                Text("Problem z wczytywaniem informacji...")
            }
        }
    }
    
    private func showAlert(message: String){
        self.alertMessage = message
        self.showingAlert.toggle()
    }
}


#Preview {
    WithdrawView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: false)), requireRefresh: .constant(false))
}
