import SwiftUI

struct MainView: View {
    @Binding var loggedUser: User?
    @State private var selectedIndex: Int = 0
    @State private var loggedAccount: Account?
    @State private var requireUpdate: Bool = false
    @State private var auth = Authenticator()
    
    var body: some View {
        ZStack{
            if let _ = loggedUser{
                VStack{
                    switch(selectedIndex){
                    case 0:
                        HomeView(loggedUser: $loggedUser, loggedAccount: $loggedAccount, selectedIndex: $selectedIndex, requireRefresh: $requireUpdate)
                    case 1:
                        PaymentView(loggedUser: $loggedUser, requireRefresh: $requireUpdate)
                    case 2:
                        SettingsView(loggedUser: $loggedUser)
                    default:
                        Text("Błąd podczas inicjalizacji aplikacji.")
                    }
                }
                
                VStack{
                    Spacer()
                    
                    NavBarView(selectedIndex: $selectedIndex)
                }
            }else{
                Text("Błąd podczas ściągania informacji.")
            }
        }
        .onAppear(perform: {
            if let user = loggedUser{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    auth.getAccountInfo(username: user.username) { error, account in
                        if let error = error{
                            print(error)
                        }else{
                            if let account = account{
                                DispatchQueue.main.async{
                                    self.loggedAccount = account
                                }
                            }else{
                                print("Nie znaleziono konta.")
                            }
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    if let deviceTokenString = UserDefaults.standard.string(forKey: "deviceTokenString"){
                        auth.storeToken(deviceToken: deviceTokenString, username: user.username)
                    }
                }
            }
        })
    }
}



#Preview {
    MainView(loggedUser: .constant(User(name: "Konrad", lastname: "Krawczyk", username: "kkonrad02", requireConfirmation: false)))
}
