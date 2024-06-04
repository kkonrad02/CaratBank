//
//  ProfileView.swift
//  CaratBank
//
//  Created by Konrad Krawczyk on 21/12/2023.
//

import SwiftUI

struct ProfileView: View {
    @Binding var loggedUser: User?
    @Binding var requireRefresh: Bool
    @Binding var showingModal: Bool
    
    var body: some View {
        if let user = loggedUser{
            NavigationStack {
                VStack{
                    GeometryReader{ geometry in
                        VStack{
                            VStack{
                                Image(systemName: "person")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40)
                                    .padding(30)
                                    .background(.white)
                                    .cornerRadius(100)
                                    .shadow(color: Color("darkShadow"), radius: 10, y: 10)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.25)
                            .background(LinearGradient(colors: [Color("gradient3"), Color("gradient4")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            VStack{
                                PreviewModel(text1: "Imię", text2: user.name, disabled: true)
                                    .padding(.top)
                                
                                PreviewModel(text1: "Nazwisko", text2: user.lastname, disabled: true)
                                    .padding(.top)
                                
                                PreviewModel(text1: "Nazwa użytkownika", text2: "@\(user.username)", disabled: true)
                                    .padding(.top)
                                
                                NavigationLink {
                                    ChangeConfirmationView(loggedUser: $loggedUser, requireRefresh: $requireRefresh, showingModal: $showingModal)
                                } label: {
                                    PreviewModel(text1: "Wymagaj potwierdzenia", text2: user.requireConfirmation ? "Tak" : "Nie", disabled: false)
                                        .padding(.top)
                                }

                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.75)
                            .background(Color("background"))
                        }
                    }
                }
                .background(Color("background"))
            }
        }else{
            LoadingView()
        }
    }
}

struct ChangeConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var loggedUser: User?
    @Binding var requireRefresh: Bool
    @Binding var showingModal: Bool
    
    @State private var selectedOption: String = "Nie"
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    @State private var auth = Authenticator()
    
    var body: some View {
        VStack{
            if let user = loggedUser{
                GeometryReader{ geometry in
                    VStack{
                        VStack{
                            Text("Wymagaj potwierdzenia")
                                .font(.system(size: 30))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 30)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.25)
                        .background(LinearGradient(colors: [Color("gradient3"), Color("gradient4")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        VStack{
                            List{
                                Picker("Wymagaj potwierdzenia", selection: $selectedOption){
                                    Text("Nie").tag("Nie")
                                    Text("Tak").tag("Tak")
                                }
                                .shadow(color: Color("shadow"), radius: 10, y: 10)
                            }
                            .frame(height: 100)
                            
                            
                            Button {
                                auth.changeConfirmation(username: user.username, option: selectedOption) { error in
                                    if let error = error{
                                        showAlert(message: error)
                                    }else{
                                        showAlert(message: "Zapisano.")
                                        self.requireRefresh = true
                                        self.showingModal = false
                                    }
                                }
                            } label: {
                                BetterButton(title: "Zapisz")
                            }
                            .alert(alertMessage, isPresented: $showingAlert){
                                Button("Okej", role: .cancel){}
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.75)
                    }
                    .background(Color("background"))
                    .onAppear(){
                        self.selectedOption = user.requireConfirmation ? "Tak" : "Nie"
                    }
                }
            }else{
                LoadingView()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack{
                        Image(systemName: "arrow.backward")
                        Text("Powrót")
                    }
                    .foregroundColor(.white)
                })
            }
        }
    }
    
    private func showAlert(message: String){
        self.alertMessage = message
        self.showingAlert.toggle()
    }
}



#Preview {
//    ProfileView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: false)), requireRefresh: .constant(false), showingModal: .constant(true))
    ChangeConfirmationView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: true)), requireRefresh: .constant(false), showingModal: .constant(true))
}
