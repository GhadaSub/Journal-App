//
//  MainPage.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 18/04/1446 AH.
//

import SwiftUI
struct MainPage: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Text("Journal")
                    .foregroundColor(.white)
                    .font(.system(size: 34))
                    .fontWeight(.semibold)
                    .position(x: 60, y: 110)
                    .
                Text("Begin Your Journal")
                    .foregroundColor(.lvndr)
                    .font(.title)
                    .fontWeight(.heavy)
                    .frame(width: 282, height: 53)
                Text("Craft your personal diary, tap the plus icon to begin")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 282, height: 53)
            }
            .padding()
        }
    }
}

#Preview {
    MainPage()
}
