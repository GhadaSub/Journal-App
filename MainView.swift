//
//  MainView.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 25/04/1446 AH.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var viewModel: JournalViewModel

    var body: some View {
        VStack {
            // Your other UI components...

            Button("Add Journal Entry") {
                // Call the addEntry method and pass the context
                viewModel.addEntry(title: "Sample Title", content: "Sample Content", context: context)
            }
        }
    }
}
