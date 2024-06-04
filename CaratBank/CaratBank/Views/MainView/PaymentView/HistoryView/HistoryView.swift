//
//  HistoryView.swift
//  CaratBank
//
//  Created by Konrad Krawczyk on 20/12/2023.
//

import SwiftUI

struct HistoryView: View {
    @Binding var loggedUser: User?
    @State private var auth = Authenticator()
    @State private var historyItems: [HistoryItem] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if let user = loggedUser{
            VStack{
                GeometryReader{ geometry in
                    VStack{
                        VStack{
                            Text("Historia")
                                .font(.system(size: 40))
                                .bold()
                                .padding(.top, 30)
                                .foregroundColor(.white)
                        }
                        .frame(height: geometry.size.height * 0.25)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [Color("gradient7"), Color("gradient8")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        VStack{
                            ScrollView{
                                ForEach(historyItems, id: \.self){ item in
                                    HistoryModel(item: item)
                                }
                            }
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.65)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.75)
                        .background(Color("background"))
                    }
                    .onAppear(){
                        auth.getUserHistory(username: user.username) { error, history in
                            if let error = error{
                                print(error)
                            }else{
                                if let history = history{
                                    self.historyItems = history
                                }
                            }
                        }
                    }
                }
            }
            .background(Color("background"))
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
        }else{
            LoadingView()
        }
    }
}

#Preview {
    HistoryView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: false)))
}
