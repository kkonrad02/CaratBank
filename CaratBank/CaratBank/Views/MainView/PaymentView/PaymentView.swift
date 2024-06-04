import SwiftUI

struct PaymentView: View {
    @Binding var loggedUser: User?
    @Binding var requireRefresh: Bool
    
    @State private var showingWithdrawModal: Bool = false
    @State private var showingTransferModal: Bool = false
    
    var body: some View {
        if let _ = loggedUser{
            NavigationStack{
                GeometryReader{ geometry in
                    VStack {
                        VStack{
                            Text("Płatności")
                                .font(.system(size: 40))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 30)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.25)
                        .background(LinearGradient(colors: [Color("gradient3"), Color("gradient4")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        VStack{
                            NavigationLink {
                                HistoryView(loggedUser: $loggedUser)
                            } label: {
                                BetterButton(title: "Historia")
                                    .padding(.top)
                            }
                            
                            Button(action: {
                                self.showingWithdrawModal.toggle()
                            }, label: {
                                BetterSecondaryButton(title: "Wpłać pieniądze")
                                    .padding(.top)
                            })
                            .sheet(isPresented: $showingWithdrawModal, content: {
                                WithdrawView(loggedUser: $loggedUser, requireRefresh: $requireRefresh)
                            })
                            
                            Button(action: {
                                self.showingTransferModal.toggle()
                            }, label: {
                                BetterSecondaryButton(title: "Przelej pieniądze")
                            })
                            .sheet(isPresented: $showingTransferModal, content: {
                                TransferView(loggedUser: $loggedUser, requireRefresh: $requireRefresh)
                            })
                            
                            Spacer()
                        }
                        .frame(height: geometry.size.height * 0.75)
                    }
                    .background(Color("background"))
                }
            }
        }else{
            LoadingView()
        }
    }
}



#Preview {
    PaymentView(loggedUser: .constant(User(name: "Konrad", lastname: "Kraczyk", username: "kkonrad02", requireConfirmation: false)), requireRefresh: .constant(false))
}
