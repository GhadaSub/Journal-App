//
//  PersistenceController.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 23/04/1446 AH.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "YourModelName") // Change to your model name
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
