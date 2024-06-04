//
//  StatusView.swift
//  CaratBank
//
//  Created by Konrad Krawczyk on 21/12/2023.
//

import SwiftUI

struct StatusView: View {
    @Binding var loggedUser: User?
    @Binding var showingModal: Bool
    @State private var items: [ConfirmationItem] = []
    @State private var auth = Authenticator()
    @State private var isLoading: Bool = false
    
    var body: some View {
        if let user = loggedUser{
            ZStack {
                NavigationStack{
                    VStack{
                        if !items.isEmpty{
                            ForEach(items, id: \.self){ item in
                                NavigationLink {
                                    StatusPreview(item: item, showingModal: $showingModal)
                                } label: {
                                    StatusItem(item: item)
                                        .padding(.top)
                                }

                            }
                            
                            Spacer()
                        }else{
                            if !isLoading{
                                Text("Nie masz żadnych potwierdzeń.")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("background"))
                    .onAppear(perform: {
                        self.isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            auth.getConfirmations(username: user.username) { error, items in
                                self.isLoading = false
                                if let error = error{
                                    print(error)
                                }else{
                                    if let items = items{
                                        self.items = items
                                    }
                                }
                            }
                        }
                    })
                }
                
                VStack{
                    if isLoading{
                        LoadingView()
                    }
                }
            }
        }else{
            LoadingView()
        }
    }
}

struct StatusItem: View {
    var item: ConfirmationItem
    
    var body: some View {
        HStack{
            Text(item.title)
                .foregroundColor(.black)
            
            Spacer()
            
            Text(item.status)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color("shadow"), radius: 10, y: 10)
        .padding(.horizontal)
    }
}

#Preview {
    StatusView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: false)), showingModal: .constant(true))
}
