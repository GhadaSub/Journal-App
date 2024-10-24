//
//  MainPage1.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 18/04/1446 AH.
//

import SwiftUI

struct MainPage1: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea() // Full screen black background
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Image of the journal
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundStyle(.linearGradient(
                            Gradient(colors: [.purple, .orange]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    
                    // Title Text
                    Text("Begin Your Journal")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Subtitle Text
                    Text("Craft your personal diary, tap the plus icon to begin")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .padding(.top, 50) // Adds padding to move content down
                
                VStack {
                    // Custom Navigation Bar
                    HStack {
                        Text("Journal")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // List icon button
                        Button(action: {
                            print("List button tapped")
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.white)
                        }
                        
                        // Plus icon button
                        Button(action: {
                            print("Plus button tapped")
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                    }
                    .padding() // Adds padding around the custom nav bar
                    
                    Spacer() // Pushes content to the bottom
                }
            }
        }
        .accentColor(.white) // Ensures white color for nav buttons
    }
}

#Preview {
    MainPage1()
}
