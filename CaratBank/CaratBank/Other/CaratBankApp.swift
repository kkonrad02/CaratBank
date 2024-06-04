//
//  CaratBankApp.swift
//  CaratBank
//
//  Created by Konrad Krawczyk on 19/12/2023.
//

import SwiftUI

@main
struct CaratBankApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .onAppear(perform: {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { allowed, error in
                        if allowed{
                            DispatchQueue.main.async{
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }else{
                            print("Error while requesting push notification permission. Error: \(String(describing: error))")
                        }
                    }
                })
        }
    }
}
