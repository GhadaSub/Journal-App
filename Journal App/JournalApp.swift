//
//  Journal_AppApp.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 17/04/1446 AH.
// this is my Journal_AppApp

import SwiftUI
import SwiftData

@main
struct JournalApp: App {
    @StateObject private var viewModel = JournalViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .modelContainer(for: JournalEntry.self)
        }
    }
}

