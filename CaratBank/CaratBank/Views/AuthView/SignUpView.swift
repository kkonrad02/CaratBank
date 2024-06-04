import SwiftUI

struct SignUpView: View {
    @Binding var loggedUser: User?
    
    @State private var name: String = ""
    @State private var lastname: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
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
                
                TextField("Imię", text: $name)
                    .authBetterField()
                    .textContentType(.givenName)
                
                TextField("Nazwisko", text: $lastname)
                    .authBetterField()
                    .textContentType(.familyName)
                
                TextField("Nazwa użytkownika", text: $username)
                    .authBetterField()
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                
                SecureField("Hasło", text: $password)
                    .authBetterField()
                    .textContentType(.newPassword)
                
                SecureField("Powtórz hasło", text: $passwordConfirm)
                    .authBetterField()
                    .textContentType(.newPassword)
                
                AuthDivider()
                
                Button(action: {
                    self.isLoading = true
                    let user = User(
                        name: name,
                        lastname: lastname,
                        username: username,
                        password: password,
                        passwordConfirm: passwordConfirm,
                        requireConfirmation: false
                    )
                    
                    auth.signUp(user: user) { error in
                        DispatchQueue.main.async{
                            self.isLoading = false
                            if let error = error{
                                showAlert(message: error)
                            }else{
                                self.loggedUser = user
                            }
                        }
                    }
                }, label: {
                    AuthButton(title: "Załóż konto")
                })
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
    SignUpView(loggedUser: .constant(nil))
}
