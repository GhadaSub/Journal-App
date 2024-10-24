//
//  Main2.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 19/04/1446 AH.
//
import SwiftUI

struct JournalEntry: Identifiable {
    let id = UUID()
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool = false
}

struct Main2: View {
    @State private var searchText = ""
    @State private var filterOption: FilterOption = .all
    @State private var journalEntries: [JournalEntry] = [
        JournalEntry(title: "my birthday", date: "02/02/2024", content: "now i am dreaming and you're singing at my birthday and i've never seen you smiling so big, its nautical themed and theres something im supposed to say but cant for the life of me remember what it is.", isBookmarked: false),
        JournalEntry(title: "I get you, sabrina", date: "15/10/2024", content: "i'm also looking for the answer between the lines, they're confused and i'm upset but we somehow STILL DIDNT TALK ABOUT IT???????????????", isBookmarked: true),
        JournalEntry(title: "wtf is happening", date: "20/10/2024", content: "okay..", isBookmarked: false),
        JournalEntry(title: "here's why I think taylor swift stole the song The Black Dog from me", date: "23/10/2024", content: "i dont think a white woman gets having six weeks of breathing clear air and still missing the smoke, or being maken fun of with some esoteric joke, or wanting to sell your house and set fire to all your clothes and hire a priest to come and exorcise your demons even if you die screaming, more than I do.", isBookmarked: false)
    ]
    @State private var showAddEntry = false
    @State private var isEditing = false
    @State private var selectedEntry: JournalEntry? = nil


    enum FilterOption {
        case all, bookmarked, recent
    }


    var filteredEntries: [JournalEntry] {
        var filtered = journalEntries
        
   
        switch filterOption {
        case .all:
            break
        case .bookmarked:
            filtered = filtered.filter { $0.isBookmarked }
        case .recent:
            filtered = filtered.sorted { $0.date > $1.date }
        }
        
        // Apply search filter
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
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                 
                    HStack {
                        Text("Journal")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        
                        Menu {
                            Button("All Entries", action: { filterOption = .all })
                            Button("Bookmark", action: { filterOption = .bookmarked })
                            Button("Recent", action: { filterOption = .recent })
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .foregroundColor(.lvndr)
                                .font(.system(size: 24))
                        }
                        
                        
                        Button(action: {
                            showAddEntry.toggle()
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.lvndr)
                                .font(.system(size: 24))
                        }
                        .sheet(isPresented: $showAddEntry) {
                            AddJournalEntryView(journalEntries: $journalEntries, isEditing: $isEditing, selectedEntry: $selectedEntry)
                        }
                    }
                    .padding()
                    
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
                                .background(Color.clear)

                            Button(action: {
                                
                            }) {
                                Image(systemName: "mic")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                        .padding(.horizontal)
                    }

                    List {
                        ForEach(filteredEntries) { entry in
                            JournalRow(entry: entry, toggleBookmark: {
                                if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
                                    journalEntries[index].isBookmarked.toggle()
                                }
                            })
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .leading) {
                                Button {
                                    selectedEntry = entry
                                    isEditing = true
                                    showAddEntry.toggle()
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteEntry(entry: entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.black) // Ensure the
                }
            }
        }
        .accentColor(.white)
        .sheet(isPresented: $showAddEntry) {
            AddJournalEntryView(journalEntries: $journalEntries, isEditing: $isEditing, selectedEntry: $selectedEntry)
        }
    }
    
    
    func deleteEntry(entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries.remove(at: index)
        }
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

import SwiftUI

struct AddJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var journalEntries: [JournalEntry]
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
                // Title input
                TextField("Title", text: $title)
                    .focused($titleIsFocused)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    //.padding()
                    .background(Color.bg)
                    .cornerRadius(8)
                    .onTapGesture {
                        titleIsFocused = true
                    }

                
                HStack {
                    Text(dateFormatted(date))
                        .foregroundColor(.tx2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Journal content input
                TextField("Type your Journal...", text: $content)
                    .focused($contentIsFocused)
                    .foregroundColor(.white)
                    .font(.body)
                    //.padding()
                    .background(Color.bg)
                    .cornerRadius(8)
                    .onTapGesture {
                        contentIsFocused = true
                    }

                Spacer()
            }
            .padding()
            .background(Color.bg)
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
            .onDisappear {
                
                titleIsFocused = false
                contentIsFocused = false
            }
        }
        .background(Color.black)
    }

    private func saveEntry() {
        if isEditing, let entry = selectedEntry, let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index].title = title
            journalEntries[index].content = content
            journalEntries[index].date = dateFormatted(date)
        } else {
            let newEntry = JournalEntry(title: title, date: dateFormatted(date), content: content)
            journalEntries.append(newEntry)
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

// MARK: - Placeholder Modifier
struct PlaceholderModifier: ViewModifier {
    var showPlaceholder: Bool
    var placeholder: String

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            content
                .opacity(showPlaceholder ? 0 : 1)
            if showPlaceholder {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 5)
            }
        }
    }
}

extension View {
    func placeholder(when shouldShow: Bool, placeholder: String) -> some View {
        self.modifier(PlaceholderModifier(showPlaceholder: shouldShow, placeholder: placeholder))
    }
}

#Preview {
    Main2()
}

