//
//  ContentView.swift
//  CaratBank
//
//  Created by Konrad Krawczyk on 19/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var loggedUser: User?
    
    var body: some View {
        VStack{
            if let _ = loggedUser{
                MainView(loggedUser: $loggedUser)
            }else{
                AuthView(loggedUser: $loggedUser)
            }
        }
    }
}

#Preview {
    ContentView()
}
