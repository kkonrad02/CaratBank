//
//  TransferView.swift
//  CaratBank
//
//  Created by Konrad Krawczyk on 20/12/2023.
//

import SwiftUI

struct TransferView: View {
    @Binding var loggedUser: User?
    @Binding var requireRefresh: Bool
    @State private var loggedAccount: Account?
    
    @State private var reciever: String = ""
    @State private var amount: String = ""
    
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    @State private var auth = Authenticator()
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let user = loggedUser{
            ZStack {
                VStack{
                    GeometryReader{ geometry in
                        VStack{
                            VStack{
                                Text("Przelej pieniądze")
                                    .font(.system(size: 40))
                                    .bold()
                                    .padding(.top, 30)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.25)
                            .background(LinearGradient(colors: [Color("gradient5"), Color("gradient6")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            VStack(alignment: .leading){
                                if let account = loggedAccount{
                                    Text("Konto Główne - \(user.name)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                        .padding(.top)
                                        .padding(.horizontal, 40)
                                    
                                    TextField("Nazwa użytkownika odbiorcy", text: $reciever)
                                        .authBetterField()
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                    
                                    Text("Saldo - \(String(format: "%.02f", account.balance)) \(account.currency)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                        .padding(.top)
                                        .padding(.horizontal, 40)
                                    TextField("Kwota", text: $amount)
                                        .authBetterField()
                                    
                                    Button(action: {
                                        self.isLoading = true
                                        auth.transferMoney(sender: user.username, reciever: reciever, amount: amount) { error in
                                            self.isLoading = false
                                            if let error = error{
                                                showAlert(message: error)
                                            }else{
                                                showAlert(message: "Przelano środki!")
                                                self.requireRefresh = true
                                                self.dismiss()
                                            }
                                        }
                                    }, label: {
                                        BetterButton(title: "Przelej pieniądze")
                                            .padding(.top)
                                    })
                                    .alert(alertMessage, isPresented: $showingAlert){
                                        Button("Okej", role: .cancel){}
                                    }
                                    
                                    Spacer()
                                }else{
                                    LoadingView()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.75)
                            .background(Color("background"))
                        }
                    }
                }
                .background(Color("background"))
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        auth.getAccountInfo(username: user.username) { error, account in
                            if let error = error{
                                print(error)
                            }else{
                                if let account = account{
                                    self.loggedAccount = account
                                }
                            }
                        }
                    }
                })
                
                VStack{
                    if isLoading{
                        LoadingView()
                    }
                }
            }
        }else{
            Text("Błąd podczas ściągania informacji...")
        }
    }
    
    private func showAlert(message: String){
        self.alertMessage = message
        self.showingAlert.toggle()
    }
}

#Preview {
    TransferView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: false)), requireRefresh: .constant(false))
}
