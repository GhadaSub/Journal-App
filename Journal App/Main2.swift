//
//  Main2.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 19/04/1446 AH.

import SwiftUI

struct Main2: View {
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var searchText = ""
    @State private var filterOption: FilterOption = .all
    @State private var showAddEntry = false
    @State private var isEditing = false
    @State private var selectedEntry: JournalEntry? = nil

    enum FilterOption: String, CaseIterable {
        case all, bookmarked, recent
    }

    var filteredEntries: [JournalEntry] {
        var filtered = viewModel.myJournalEntries

        switch filterOption {
        case .bookmarked:
            filtered = filtered.filter { $0.isBookmarked }
        case .recent:
            filtered = filtered.sorted { $0.date > $1.date }
        case .all:
            break
        }

        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.date.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        return filtered
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 44, height: 44)

                            Menu {
                                ForEach(FilterOption.allCases, id: \.self) { option in
                                    Button(action: {
                                        filterOption = (filterOption == option) ? .all : option
                                    }) {
                                        HStack {
                                            Text(option.rawValue.capitalized)
                                            if filterOption == option {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .foregroundColor(.lvndr)
                                    .font(.system(size: 24))
                            }
                        }

                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 44, height: 44)

                            Button(action: {
                                isEditing = false
                                selectedEntry = nil
                                showAddEntry.toggle()
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.lvndr)
                                    .font(.system(size: 24))
                            }
                            .sheet(isPresented: $showAddEntry) {
                                AddJournalEntryView(isEditing: $isEditing, selectedEntry: $selectedEntry)
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                    .padding()

                    HStack {
                        Text("Journal")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, -50)
                            .padding(.leading)
                        Spacer()
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 370, height: 50)

                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 10.0)

                            TextField("Search", text: $searchText)
                                .foregroundColor(.white)
                                .padding(10)

                            Button(action: {}) {
                                Image(systemName: "mic")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                        .padding(.horizontal)
                    }

                    if viewModel.myJournalEntries.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)

                            Text("Begin Your Journal")
                                .foregroundColor(.lvndr)
                                .font(.system(size: 24))
                                .font(.title)
                                .fontWeight(.bold)
                                

                            Text("Craft your personal diary, tap the plus icon to begin")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.top, -55)
                                .padding(.horizontal, 40)
                                .frame(width: 350, height: 90)

                            Spacer()
                        }
                        .padding(.top, -60)
                    } else {
                        List {
                            ForEach(filteredEntries) { entry in
                                JournalRow(entry: entry) {
                                    viewModel.toggleBookmark(for: entry)
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        selectedEntry = entry
                                        isEditing = true
                                        showAddEntry.toggle()
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                    .tint(.blue)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.deleteEntry(entry)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
        }
        .accentColor(.white)
    }
}

// MARK: - JournalRow

struct JournalRow: View {
    var entry: JournalEntry
    var toggleBookmark: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(entry.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(entry.content)
                    .font(.body)
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
            Spacer()
            Button(action: toggleBookmark) {
                Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(entry.isBookmarked ? .lvndr : .lvndr)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
        .frame(width: 370)
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

// MARK: - AddJournalEntryView

struct AddJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: JournalViewModel
    @Binding var isEditing: Bool
    @Binding var selectedEntry: JournalEntry?

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
        .background(Color.grayish)
    }

    private func saveEntry() {
        if isEditing, let entry = selectedEntry {
            let updatedEntry = JournalEntry(title: title, date: dateFormatted(date), content: content)
            viewModel.updateEntry(entry, with: updatedEntry)
        } else {
            viewModel.addEntry(title: title, content: content)
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

#Preview {
    Main2()
        .environmentObject(JournalViewModel())
}
