import SwiftUI

struct HomeView: View {
    @State private var showDetails = false
    
    var body: some View {
        VStack{
            Button("Welcome!"){
                withAnimation {
                    showDetails.toggle()
                }
            }
            
            if showDetails {
                WindowGroup {
                    TimerView()
                }.transition(.slide)
            }
        }
    }
}