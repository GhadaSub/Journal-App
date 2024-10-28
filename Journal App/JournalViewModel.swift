//
//  JournalViewModel.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 25/04/1446 AH.

import SwiftUI
import Combine

class JournalViewModel: ObservableObject {
    @Published var myJournalEntries: [JournalEntry] = []

    init() {
        // Initial entries if needed
    }

    func addEntry(title: String, content: String) {
        let newEntry = JournalEntry(title: title, date: dateFormatted(Date()), content: content)
        myJournalEntries.append(newEntry)
    }

    func updateEntry(_ entry: JournalEntry, with newEntry: JournalEntry) {
        if let index = myJournalEntries.firstIndex(where: { $0.id == entry.id }) {
            myJournalEntries[index] = newEntry
        }
    }

    func deleteEntry(_ entry: JournalEntry) {
        myJournalEntries.removeAll { $0.id == entry.id }
    }

    func toggleBookmark(for entry: JournalEntry) {
        if let index = myJournalEntries.firstIndex(where: { $0.id == entry.id }) {
            myJournalEntries[index].isBookmarked.toggle()
        }
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

