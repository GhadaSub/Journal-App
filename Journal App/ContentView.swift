//
//  ContentView.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 17/04/1446 AH. 

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var isActive = false

    var body: some View {
        ZStack {
            if isActive {
                MainView()
                    .environmentObject(viewModel)
            } else {
                splashScreen
            }
        }
    }

    private var splashScreen: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.journalp, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                Text("Journali")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text("Your thoughts, your story")
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(JournalViewModel())
        .modelContainer(for: JournalEntry.self)
}
