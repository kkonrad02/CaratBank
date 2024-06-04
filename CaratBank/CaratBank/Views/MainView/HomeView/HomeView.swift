//
//  HomeView.swift
//  CaratBank
//
//  Created by Konrad Krawczyk on 19/12/2023.
//

import SwiftUI

struct HomeView: View {
    @Binding var loggedUser: User?
    @Binding var loggedAccount: Account?
    @Binding var selectedIndex: Int
    
    @State private var accountBalance: String = "0.00"
    @State private var auth = Authenticator()
    @State private var isLoading: Bool = false
    @State private var showingProfileModal: Bool = false
    @State private var showingStatusModal: Bool = false
    @Binding var requireRefresh: Bool
    
    var body: some View {
        ZStack {
            VStack{
                if let user = loggedUser, let account = loggedAccount{
                    GeometryReader{ geometry in
                        VStack {
                            ZStack{
                                //                            Main Screen
                                VStack(){
                                    Text("Konto główne - \(user.name)")
                                        .foregroundColor(Color("mainDarkGray"))
                                        .font(.system(size: 10))
                                    Text("\(String(format: "%.2f", account.balance)) \(account.currency)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 40))
                                        .bold()
                                    
                                    Button(action: {
                                        self.isLoading = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                            self.isLoading = false
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
                                    }, label: {
                                        Text("Odśwież")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .padding(5)
                                            .overlay{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(.white), lineWidth: 1)
                                            }
                                    })
                                }
                                
                                VStack{
                                    VStack {
                                        HStack {
                                            Spacer()
                                            
                                            Button(action: {
                                                self.showingProfileModal.toggle()
                                            }, label: {
                                                Image(systemName: "person")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 25, height: 25)
                                                    .padding(9)
                                                    .background(.white)
                                                    .cornerRadius(100)
                                                    .shadow(color: Color("darkShadow"), radius: 10, y: 5)
                                                    .foregroundColor(.black)
                                            })
                                            .sheet(isPresented: $showingProfileModal, content: {
                                                ProfileView(loggedUser: $loggedUser, requireRefresh: $requireRefresh, showingModal: $showingProfileModal)
                                            })
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 1)
                                        Spacer()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.25)
                            .background(LinearGradient(colors: [Color("gradient1"), Color("gradient2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            //                        Content
                            VStack{

                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.75)
                            .background(Color("background"))
                        }
                        .onChange(of: requireRefresh, { oldValue, newValue in
                            if requireRefresh{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    auth.getUserInfo(username: user.username) { error, user in
                                        if let error = error{
                                            print(error)
                                        }else{
                                            if let newUser = user{
                                                let savedUser = auth.getIfSavedUser()
                                                auth.saveUser(user: newUser, save: savedUser)
                                                self.loggedUser = newUser
                                            }
                                        }
                                    }
                                }
                                self.requireRefresh = false
                            }
                        })
                        .onAppear(){
                            if requireRefresh{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    auth.getAccountInfo(username: user.username) { error, account in
                                        if let error = error{
                                            print(error)
                                        }else{
                                            if let account = account{
                                                self.loggedAccount = account
                                            }else{
                                                print("Błąd")
                                            }
                                        }
                                    }
                                }
                                self.requireRefresh = false
                            }
                        }
                    }
                }else{
                    LoadingView()
                }
            }
            .background(Color("background"))
            
            VStack{
                if isLoading{
                    LoadingView()
                }
            }
        }
    }
}

#Preview {
    HomeView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: false)), loggedAccount: .constant(Account(username: "kkonrad02", balance: 100, currency: "zł")), selectedIndex: .constant(0), requireRefresh: .constant(false))
}
