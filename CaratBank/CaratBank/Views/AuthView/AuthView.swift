import SwiftUI
import LocalAuthentication

struct AuthView: View{
    @Binding var loggedUser: User?
    
    var auth = Authenticator()
    
    var body: some View{
        NavigationStack {
            VStack{
                Spacer()
                
                AuthLogo()
                
                Spacer()
                
                NavigationLink {
                    SignInView(loggedUser: $loggedUser)
                } label: {
                    AuthButton(title: "Zaloguj się")
                }
                
                AuthDivider()
                
                NavigationLink {
                    SignUpView(loggedUser: $loggedUser)
                } label: {
                    AuthSecondaryButton(title: "Załóż konto")
                }
                
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("background"))
        }
        .onAppear(perform: {
            auth.loadUser { user in
                if let user = user{
                    let context = LAContext()
                    var error: NSError?
                    
                    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                        let reason = "Potrzebujemy twojej twarzy do automatycznego logowania."
                        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                            if success{
                                self.loggedUser = user
                            }
                        }
                    }
                }
            }
        })
    }
}

#Preview {
    AuthView(loggedUser: .constant(nil))
}
