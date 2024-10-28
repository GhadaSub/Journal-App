//
//  Journal_AppApp.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 17/04/1446 AH.
//

import SwiftUI

@main
struct Journal_AppApp: App {
    @StateObject private var viewModel = JournalViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

