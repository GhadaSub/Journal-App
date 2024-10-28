//
//  JournalEntry.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 25/04/1446 AH.
//

import Foundation

struct MyJournalEntry: Identifiable {
    var id = UUID() // Ensure this generates a unique ID
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool = false
}

    
    init(title: String, date: String, content: String, isBookmarked: Bool = false) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.content = content
        self.isBookmarked = isBookmarked
    }
}
