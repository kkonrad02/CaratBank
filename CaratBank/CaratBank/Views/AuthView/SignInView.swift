import SwiftUI

struct SignInView: View {
    @Binding var loggedUser: User?
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var stayLoggedIn: Bool = false
    
    var auth = Authenticator()
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    @State private var isLoading: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                
                AuthLogo()
                
                Spacer()
                
                TextField("Nazwa użytkownika", text: $username)
                    .authBetterField()
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                
                SecureField("Hasło", text: $password)
                    .authBetterField()
                    .textContentType(.password)
                
                AuthDivider()
                
                Toggle(isOn: $stayLoggedIn, label: {
                    Text("Zapamiętaj mnie")
                })
                .padding(.horizontal, 30)
                .padding(.bottom)
                
                Button {
                    self.isLoading = true
                    auth.signIn(username: username, password: password) { error, user in
                        self.isLoading = false
                        if let error = error{
                            showAlert(message: error)
                        }else{
                            guard let user = user else{
                                showAlert(message: "Błąd podczas ściągania informacji.")
                                return
                            }
                            
                            auth.saveUser(user: user, save: stayLoggedIn)
                            self.loggedUser = user
                        }
                    }
                } label: {
                    AuthButton(title: "Zaloguj się")
                }
                .alert(alertMessage, isPresented: $showingAlert){
                    Button("Okej", role: .cancel){}
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("background"))
            
            if isLoading{
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
                    .foregroundColor(Color("main"))
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
    SignInView(loggedUser: .constant(nil))
}
