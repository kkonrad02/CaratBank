import SwiftUI
import LocalAuthentication

struct StatusPreview: View {
    var item: ConfirmationItem
    @Binding var showingModal: Bool
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var auth = Authenticator()
    
    var body: some View {
        VStack{
            GeometryReader{ geometry in
                VStack{
                    VStack{
                        Text("Potwierdzenie")
                            .font(.system(size: 40))
                            .bold()
                            .foregroundColor(.white)
                        Text(item.title)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.25)
                    .background(LinearGradient(colors: [Color("gradient1"), Color("gradient2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    
                    VStack{
                        VStack{
                            Button(action: {
                                let context = LAContext()
                                var error: NSError?
                                
                                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Potrzbeujemy twojej biometrii do potweirdzania tożsamości.") { success, authError in
                                        if success{
                                            auth.confirmConfirmation(username: item.username, title: item.title, status: "confirmed") { error in
                                                if let error = error{
                                                    print(error)
                                                }else{
                                                    showAlert(message: "Potwierdzono.")
                                                    self.showingModal = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }, label: {
                                BetterButton(title: "Potwierdź")
                                    .padding(.top)
                            })
                            .alert(alertMessage, isPresented: $showingAlert){
                                Button("Okej", role: .cancel){}
                            }
                            
                            Button(action: {
                                let context = LAContext()
                                var error: NSError?
                                
                                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Potrzbeujemy twojej biometrii do potweirdzania tożsamości.") { success, authError in
                                        if success{
                                            auth.confirmConfirmation(username: item.username, title: item.title, status: "declined") { error in
                                                if let error = error{
                                                    print(error)
                                                }else{
                                                    showAlert(message: "Odrzucono.")
                                                    self.showingModal = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }, label: {
                                BetterWarningButton(title: "Odrzuć")
                                    .padding(.top)
                            })
                            
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.75)
                    .background(Color("background"))
                    
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
                .background(Color("background"))
            }
        }
    }
    
    private func showAlert(message: String){
        self.alertMessage = message
        self.showingAlert.toggle()
    }
}

#Preview {
    StatusPreview(item: ConfirmationItem(username: "kkonrad02", title: "Logowanie na stronie", status: "Oczekuję"), showingModal: .constant(true))
}
