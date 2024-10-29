//
//  JournalEntry.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 25/04/1446 AH.

import Foundation
import SwiftData

@Model
final class JournalEntry {
    let id = UUID()
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool = false

    init(title: String, date: String, content: String, isBookmarked: Bool = false) {
        self.title = title
        self.date = date
        self.content = content
        self.isBookmarked = isBookmarked
    }
}
