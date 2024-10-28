//
//  ContentView.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 17/04/1446 AH.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var isActive = false

    var body: some View {
        ZStack {
            if isActive {
                Main2()
            } else {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.topbg, .black]),
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
    }
}

// Extension to create Color from hex
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    ContentView()
        .environmentObject(JournalViewModel())
}

