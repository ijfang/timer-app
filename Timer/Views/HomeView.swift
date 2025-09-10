//
//  HomeView.swift
//  Timer
//
//  Created by Isabelle Fang on 9/9/25.
//


import SwiftUI


struct HomeView: View {
    @State private var showTimer = false
    
    var body: some View {
        VStack{
            Button("Welcome!"){
                    showTimer.toggle()
            }.fullScreenCover(isPresented: $showTimer){
                TabView {
                    TimerView()
                        .tabItem{
                            Label("Original", systemImage: "timer")
                        }
                    
                    PomodoroView()
                        .tabItem {
                            Label("Pomodoro", systemImage: "leaf.circle")
                        }
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    HomeView()
}
