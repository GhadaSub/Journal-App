//
//  AddJournalEntryView.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 26/04/1446 AH.

import SwiftUI

struct AddJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: JournalViewModel
    @Binding var isEditing: Bool
    @Binding var selectedEntry: JournalEntry?
    @Environment(\.modelContext) var context // Add this line

    @State private var title = ""
    @State private var content = ""
    @State private var date = Date()

    @FocusState private var titleIsFocused: Bool
    @FocusState private var contentIsFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Title", text: $title)
                    .focused($titleIsFocused)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .onTapGesture {
                        titleIsFocused = true
                    }

                HStack {
                    Text(dateFormatted(date))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                TextField("Type your Journal...", text: $content, axis: .vertical)
                    .focused($contentIsFocused)
                    .foregroundColor(.white)
                    .font(.body)
                    .cornerRadius(8)
                    .onTapGesture {
                        contentIsFocused = true
                    }

                Spacer()
            }
            .padding()
            .background(Color.grayish)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.lvndr),
                trailing: Button("Save") {
                    saveEntry()
                    dismiss()
                }
                .foregroundColor(.lvndr)
            )
            .onAppear {
                if isEditing, let entry = selectedEntry {
                    title = entry.title
                    content = entry.content
                    date = dateFromString(entry.date) ?? Date()
                }
            }
        }
        .background(Color.journalp)
    }

    private func saveEntry() {
        if isEditing, let entry = selectedEntry {
            let updatedEntry = JournalEntry(title: title, date: dateFormatted(date), content: content)
            viewModel.updateEntry(entry, with: updatedEntry)
        } else if !title.isEmpty && !content.isEmpty {
            viewModel.addEntry(title: title, content: content, context: context)
        }
    }


    func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: dateString)
    }
}
