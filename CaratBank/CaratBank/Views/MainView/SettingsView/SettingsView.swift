//
//  SettingsView.swift
//  CaratBank
//
//  Created by Konrad Krawczyk on 19/12/2023.
//

import SwiftUI

struct SettingsView: View {
    @Binding var loggedUser: User?
    @State private var auth = Authenticator()
    @State private var showingConfirmationModal: Bool = false
    
    var body: some View {
        VStack{
            GeometryReader{ geometry in
                VStack{
                    VStack{
                        Text("Ustawienia")
                            .font(.system(size: 40))
                            .bold()
                            .padding(.top, 30)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.25)
                    .background(LinearGradient(colors: [Color("gradient5"), Color("gradient6")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    
                    VStack{
                        Button(action: {
                            self.showingConfirmationModal.toggle()
                        }, label: {
                            BetterButton(title: "Menadżer potwierdzeń")
                        })
                        .padding(.top)
                        .sheet(isPresented: $showingConfirmationModal, content: {
                            StatusView(loggedUser: $loggedUser, showingModal: $showingConfirmationModal)
                        })
                        
                        Button(action: {
                            auth.saveUser(user: User(name: "", lastname: "", username: "", requireConfirmation: false), save: false)
                            self.loggedUser = nil
                        }, label: {
                            BetterSecondaryButton(title: "Wyloguj się")
                                .padding(.top)
                        })
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.75)
                    .background(Color("background"))
                }
                .background(Color("background"))
            }
        }
    }
}

#Preview {
    SettingsView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: false)))
}
