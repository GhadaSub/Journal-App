//
//  Main2.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 19/04/1446 AH.

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var searchText = ""
    @State private var filterOption: FilterOption = .All
    @State private var showAddEntry = false
    @State private var isEditing = false
    @State private var selectedEntry: JournalEntry? = nil

    enum FilterOption: String, CaseIterable {
        case All, Bookmarked, Date
    }

    var filteredEntries: [JournalEntry] {
        var filtered = viewModel.myJournalEntries

        switch filterOption {
        case .Bookmarked:
            filtered = filtered.filter { $0.isBookmarked }
        case .Date:
            filtered = filtered.sorted { $0.date > $1.date }
        case .All:
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
                                .frame(width: 40, height: 40)

                            Menu {
                                ForEach(FilterOption.allCases, id: \.self) { option in
                                    Button(action: {
                                        filterOption = (filterOption == option) ? .All : option
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
                                .frame(width: 35, height: 35)

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
                                    .environment(\.modelContext, modelContext)
                            }
                        }
                    }
                    .padding(5)

                    HStack {
                        Text("Journal")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, -50)
                            .padding(.leading)
                        Spacer()
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
                                .fontWeight(.bold)

                            Text("Craft your personal diary, tap the plus icon to begin")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, -55)
                                .padding(.horizontal, 40)
                                .frame(width: 350, height: 90)

                            Spacer()
                        }
                        .padding(.top, -60)
                    } else {
                        // Show search bar when there are entries
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
                                    .tint(.editpurple)
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
                    .resizable()
                    .scaledToFit()
                    .frame(width: 23, height: 23)
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

#Preview {
    MainView()
        .environmentObject(JournalViewModel()) // Add this
        .modelContainer(for: JournalEntry.self)
}
